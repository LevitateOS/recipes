#!/usr/bin/python3 -I
"""Pin the Fedora package set of the `desktop-runtime` Recipe library recipe.

The approach of `cargo xtask base lock` (LevitateOS xtask/src/tasks/base.rs),
narrowed to what a carried runtime needs:

- read the Fedora RELEASE release and updates repositories' primary index
  (checked against repomd.xml), newest build of each x86_64/noarch name;
- resolve the closure of SEEDS following only *shared-library* requires
  (`libfoo.so.N()(64bit)` and its versioned forms), so the set is every
  package that ships a library something in the set links against, and no
  package that only a program, daemon, scriptlet or data dependency pulls in;
  providers are chosen by the same rule as base.rs;
- download each RPM once into the cache, check it against the index
  SHA-256 and the release signing key (rpmkeys --checksig);
- write the pin list as Rhai into the recipe between the markers
  `// BEGIN GENERATED PINS` and `// END GENERATED PINS`.

Regenerate (network; a few minutes, ~70 MB):

    python3 -I generators/desktop-runtime-pins.py --recipe desktop-runtime.rhai

`--check` only reports what would change.
"""

import argparse
import datetime
import hashlib
import io
import os
import re
import subprocess
import sys
import urllib.request
import xml.etree.ElementTree as ET

RELEASE = 45
MIRROR = "https://dl.fedoraproject.org/pub/fedora/linux"
REPOS = [
    f"{MIRROR}/releases/{RELEASE}/Everything/x86_64/os/",
    f"{MIRROR}/updates/{RELEASE}/Everything/x86_64/",
]
KEY = "/home/vince/Projects/LevitateOS/distro/variants/levitate/keys/RPM-GPG-KEY-fedora-45-primary"
HERE = os.path.dirname(os.path.abspath(__file__))
CACHE = os.path.join(os.path.dirname(HERE), "rpms")

# What Electron 3x/4x and Chrome declare (readelf NEEDED and Depends), plus the
# libraries those load by name rather than link (NSS's softokn/freebl), and the
# packages that carry the runtime data (glibc-common: the C.utf8 locale; dconf:
# the GSettings GIO module; librsvg2 for glycin's SVG loader).
SEEDS = [
    # C and C++ runtime
    "glibc", "glibc-common", "libgcc", "libstdc++",
    # GTK 3 stack
    "gtk3", "glib2", "pango", "cairo", "cairo-gobject", "harfbuzz",
    "fontconfig", "freetype", "gdk-pixbuf2", "librsvg2",
    "atk", "at-spi2-atk", "at-spi2-core", "dconf",
    # D-Bus, NSS
    "dbus-libs", "nss", "nspr", "nss-util", "nss-softokn", "nss-softokn-freebl",
    # X11 / xcb / xkb
    "libX11", "libX11-xcb", "libXcomposite", "libXdamage", "libXext",
    "libXfixes", "libXrandr", "libXtst", "libXScrnSaver", "libXi",
    "libXcursor", "libxcb", "libxkbcommon", "libxkbcommon-x11", "libxshmfence",
    # graphics buffers, Wayland
    "mesa-libgbm", "libdrm", "libwayland-client", "libwayland-cursor",
    "libwayland-egl", "libva",
    # printing, sound, secrets, notifications, misc
    "cups-libs", "alsa-lib", "libsecret", "libnotify", "expat", "libuuid",
    "systemd-libs",
]

# Packages taken for some files only, whose requires are not followed: Fedora
# 45's gdk-pixbuf decodes through glycin, whose loaders are programs here; the
# recipe keeps glycin-image-rs and glycin-svg (libc/libgcc_s/librsvg2/cairo/
# GLib only) and not the HEIF and JPEG XL loaders that pull libheif and libjxl.
# The recipe's closure check proves what it keeps links only inside the set.
FILES_ONLY = ["glycin-loaders"]

SONAME = re.compile(r"^[^ ()]+\.so(\.[^ ()]*)?(\([^)]*\))?\(64bit\)$")


def fetch(url):
    with urllib.request.urlopen(url, timeout=120) as r:
        return r.read()


def rpmvercmp(a, b):
    # rpm's segment comparison, enough for Fedora's version strings.
    def segs(s):
        out, i = [], 0
        while i < len(s):
            c = s[i]
            if c == "~" or c == "^":
                out.append(c)
                i += 1
            elif c.isdigit():
                j = i
                while j < len(s) and s[j].isdigit():
                    j += 1
                out.append(int(s[i:j]))
                i = j
            elif c.isalpha():
                j = i
                while j < len(s) and s[j].isalpha():
                    j += 1
                out.append(s[i:j])
                i = j
            else:
                i += 1
        return out

    x, y = segs(a), segs(b)
    for p, q in zip(x, y):
        if p == q:
            continue
        if p == "~":
            return -1
        if q == "~":
            return 1
        if p == "^":
            return -1
        if q == "^":
            return 1
        if isinstance(p, int) and isinstance(q, int):
            return -1 if p < q else 1
        if isinstance(p, int):
            return 1
        if isinstance(q, int):
            return -1
        return -1 if p < q else 1
    if len(x) == len(y):
        return 0
    longer = x if len(x) > len(y) else y
    nxt = longer[min(len(x), len(y))]
    sign = 1 if len(x) > len(y) else -1
    if nxt == "~":
        return -sign
    return sign


def evr_cmp(a, b):
    ea, eb = int(a["epoch"] or 0), int(b["epoch"] or 0)
    if ea != eb:
        return -1 if ea < eb else 1
    return rpmvercmp(a["ver"], b["ver"]) or rpmvercmp(a["rel"], b["rel"])


def primary(repo, newest):
    repomd = fetch(repo + "repodata/repomd.xml").decode()
    sect = next(s for s in repomd.split("<data ") if s.startswith('type="primary"'))
    href = re.search(r'<location href="([^"]+)"', sect).group(1)
    sha = re.search(r'<checksum type="sha256">([0-9a-f]+)</checksum>', sect).group(1)
    blob = fetch(repo + href)
    if hashlib.sha256(blob).hexdigest() != sha:
        sys.exit(f"{repo}{href} does not match repomd.xml")
    tool = {"zst": "zstd", "gz": "gzip", "xz": "xz"}[href.rsplit(".", 1)[1]]
    xml = subprocess.run([tool, "-dc"], input=blob, capture_output=True, check=True).stdout
    ns = {"c": "http://linux.duke.edu/metadata/common", "rpm": "http://linux.duke.edu/metadata/rpm"}
    for _, el in ET.iterparse(io.BytesIO(xml)):
        if el.tag != "{http://linux.duke.edu/metadata/common}package":
            continue
        arch = el.findtext("c:arch", namespaces=ns)
        if arch not in ("x86_64", "noarch"):
            el.clear()
            continue
        v = el.find("c:version", ns)
        fmt = el.find("c:format", ns)
        size = el.find("c:size", ns)
        p = {
            "name": el.findtext("c:name", namespaces=ns),
            "arch": arch,
            "epoch": v.get("epoch"), "ver": v.get("ver"), "rel": v.get("rel"),
            "sha256": el.find("c:checksum", ns).text,
            "url": repo + el.find("c:location", ns).get("href"),
            "size": int(size.get("package")),
            "installed": int(size.get("installed")),
            "provides": [e.get("name") for e in fmt.findall("rpm:provides/rpm:entry", ns)]
            + [f.text for f in fmt.findall("c:file", ns)],
            "requires": [e.get("name") for e in fmt.findall("rpm:requires/rpm:entry", ns)],
        }
        assert el.find("c:checksum", ns).get("type") == "sha256"
        cur = newest.get(p["name"])
        if cur is None or evr_cmp(p, cur) > 0:
            newest[p["name"]] = p
        el.clear()


def resolve(pkgs):
    providers = {}
    for p in pkgs.values():
        for cap in p["provides"] + [p["name"]]:
            providers.setdefault(cap, [])
            if p["name"] not in providers[cap]:
                providers[cap].append(p["name"])
    missing = [s for s in SEEDS + FILES_ONLY if s not in pkgs]
    if missing:
        sys.exit("Fedora has no x86_64/noarch build of: " + ", ".join(missing))
    chosen, provided, todo, skipped = set(), set(), [], {}
    prefer = set(SEEDS)

    def install(n):
        if n not in chosen:
            chosen.add(n)
            provided.add(n)
            provided.update(pkgs[n]["provides"])
            todo.append(n)

    for s in SEEDS:
        install(s)
    for s in FILES_ONLY:
        chosen.add(s)
    unresolved = []
    while todo:
        n = todo.pop()
        for req in pkgs[n]["requires"]:
            if req.startswith("rpmlib(") or not SONAME.match(req):
                skipped.setdefault(n, []).append(req)
                continue
            if req in provided:
                continue
            cands = providers.get(req)
            if not cands:
                unresolved.append(f"{n} requires {req}")
                continue
            install(min(cands, key=lambda c: (c != req, c not in prefer, len(c), c)))
    if unresolved:
        sys.exit("unresolvable:\n  " + "\n  ".join(sorted(set(unresolved))))
    return chosen, skipped


def nevra(p):
    return f'{p["name"]}-{p["ver"]}-{p["rel"]}.{p["arch"]}'


def download_verified(rpms):
    os.makedirs(CACHE, exist_ok=True)
    files = []
    for p in rpms:
        path = os.path.join(CACHE, p["url"].rsplit("/", 1)[1])
        def ok():
            if not os.path.isfile(path):
                return False
            h = hashlib.sha256()
            with open(path, "rb") as f:
                for chunk in iter(lambda: f.read(1 << 20), b""):
                    h.update(chunk)
            return h.hexdigest() == p["sha256"]
        if not ok():
            data = fetch(p["url"])
            if hashlib.sha256(data).hexdigest() != p["sha256"] or len(data) != p["size"]:
                sys.exit(f'{p["url"]} does not match its repository checksum/size')
            with open(path + ".part", "wb") as f:
                f.write(data)
            os.replace(path + ".part", path)
        files.append(path)
    return files


def check_signatures(files):
    db = os.path.join(os.path.dirname(HERE), "rpmdb")
    os.makedirs(db, exist_ok=True)
    subprocess.run(["rpmkeys", "--dbpath", db, "--import", KEY], check=True)
    out = subprocess.run(["rpmkeys", "--dbpath", db, "--checksig", *files], capture_output=True, text=True)
    bad = [l for l in out.stdout.splitlines() if not l.endswith("signatures OK")]
    if out.returncode or bad or len(out.stdout.splitlines()) != len(files):
        sys.exit("signature check failed:\n" + "\n".join(bad) + out.stderr)
    print(f"[ok] {len(files)} RPMs signed by the Fedora {RELEASE} key", file=sys.stderr)


def render(rpms):
    total = sum(p["size"] for p in rpms)
    lines = [
        "// BEGIN GENERATED PINS",
        f"// Generated on {datetime.date.today()} from the Fedora {RELEASE} release and updates",
        "// repositories' primary metadata: the seeds below and every package whose",
        "// shared library one of them links against. Each RPM was checked against its",
        "// repository SHA-256 and size and the Fedora signing key. Do not edit: rerun",
        "// the generator (see the recipe header).",
        "// Seeds: " + " ".join(SEEDS) + ".",
        "// Taken for some files only (requires not followed): " + " ".join(FILES_ONLY) + ".",
        f"const FEDORA_RELEASE = {RELEASE};",
        f'const PINNED_ON = "{datetime.date.today()}";',
        f"const PINNED_BYTES = {total};",
        "// [name, NEVRA, URL, SHA256, bytes]",
        "const PINS = [",
    ]
    for p in rpms:
        lines.append(f'    ["{p["name"]}", "{nevra(p)}", "{p["url"]}", "{p["sha256"]}", {p["size"]}],')
    lines += ["];", "// END GENERATED PINS"]
    import textwrap
    out = []
    for l in lines:
        if l.startswith("// Seeds: ") or l.startswith("// Taken for"):
            out += textwrap.wrap(l, 80, subsequent_indent="//   ", break_on_hyphens=False)
        else:
            out.append(l)
    lines = out
    return "\n".join(lines) + "\n"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--recipe", help="splice the pins into this recipe")
    ap.add_argument("--out", default=os.path.join(os.path.dirname(HERE), "pins.rhai"))
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--skipped", action="store_true", help="list the requires not followed")
    a = ap.parse_args()
    newest = {}
    for repo in REPOS:
        print(f"[step] read {repo}", file=sys.stderr)
        primary(repo, newest)
    chosen, skipped = resolve(newest)
    rpms = [newest[n] for n in sorted(chosen)]
    if a.skipped:
        for n in sorted(skipped):
            print(n + ": " + ", ".join(sorted(set(skipped[n]))))
    text = render(rpms)
    print(f"{len(rpms)} packages, {sum(p['size'] for p in rpms)} bytes to download, "
          f"{sum(p['installed'] for p in rpms)} bytes installed", file=sys.stderr)
    if a.recipe:
        old = open(a.recipe).read()
        m = re.search(r"// BEGIN GENERATED PINS\n.*?// END GENERATED PINS\n", old, re.S)
        if not m:
            sys.exit("recipe has no generated pins block")
        old_pins = set(re.findall(r'^    \["[^"]+", "([^"]+)"', m.group(0), re.M))
        new_pins = {nevra(p) for p in rpms}
        for x in sorted(old_pins - new_pins):
            print("  - " + x)
        for x in sorted(new_pins - old_pins):
            print("  + " + x)
        if a.check:
            sys.exit(1 if old_pins != new_pins else 0)
    files = download_verified(rpms)
    check_signatures(files)
    if a.recipe:
        new = old[: m.start()] + text + old[m.end():]
        stamp = datetime.date.today().strftime("%Y%m%d")
        new, k = re.subn(r'version: "\d+\.\d{8}"', f'version: "{RELEASE}.{stamp}"', new, count=1)
        if k != 1:
            sys.exit("recipe has no version: \"RELEASE.YYYYMMDD\" line")
        open(a.recipe, "w").write(new)
        print(f"wrote {a.recipe}", file=sys.stderr)
    else:
        open(a.out, "w").write(text)
        print(f"wrote {a.out}", file=sys.stderr)


if __name__ == "__main__":
    main()
