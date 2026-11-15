// konsole: a Recipe group, installed into the system root (`recipe --system install konsole`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps).
// Generated: the two pin blocks, `version` and `network_max_bytes`, written by
// `cargo xtask base groups levitate` (glibc: Fedora RPMs) and
// `cargo xtask base groups acorn` (musl: Alpine APKs) from the seeds below. A
// package more than one group needs belongs to desktop-libs.
const RECIPE_API = 3;
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    network_max_bytes: 3145728,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "app",
    category: "utilities",
    libc: ["glibc"],
    systems: ["levitateos"],
    details: "Konsole, the terminal of the Plasma desktop, with tabs, split views and profiles.",
    homepage: "https://konsole.kde.org",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["konsole"], menu: ["Konsole"] },
    steps: #{
        acquire: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        build: "Unpacks the packages natively into one system tree, without running their scripts.",
        install: "Publishes the system tree for Recipe to write into the system root, with a receipt.",
    },
    keeps: [],
};

// What this group installs, by name; the generator adds what they need.
// LevitateOS (glibc, Fedora 45):
const SEEDS_GLIBC = [
    "konsole"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs"];

let ctx = #{
    name: "konsole",
    version: "2026.11.15",
    description: "KDE's terminal",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-15): 4 packages, 3117378 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-15";
const RPM_PINNED_BYTES = 3117378;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["keditbookmarks", "keditbookmarks-26.08.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/keditbookmarks-26.08.3-1.fc45.x86_64.rpm", "dd1f06c195228fda3e566bbc49058c5a0e25c5db7b612aac40791d95235cff9f", 450466, "GPL-2.0-only AND GPL-3.0-only AND LicenseRef-Callaway-GFDL", false],
    ["keditbookmarks-libs", "keditbookmarks-libs-26.08.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/keditbookmarks-libs-26.08.3-1.fc45.x86_64.rpm", "48d4c363efbe0256bbe7a887e63602f93505778dc79011a1c5a59af60f5b3315", 52441, "GPL-2.0-only AND GPL-3.0-only AND LicenseRef-Callaway-GFDL", false],
    ["konsole", "konsole-26.08.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/konsole-26.08.3-1.fc45.x86_64.rpm", "7a78e0f6a770dea8f4a3523d7774eb18b201f98367aa0f289a088fe90b8ed701", 1490267, "CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)", false],
    ["konsole-part", "konsole-part-26.08.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/konsole-part-26.08.3-1.fc45.x86_64.rpm", "5a61db346da0f9bd42265d97c7e0510390701b5d32d86f74afe8380c0f07f4f3", 1124204, "CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// No musl build: this recipe names no seeds in SEEDS_MUSL. Written by
// `cargo xtask base groups acorn`; do not edit.
const APK_PINNED_ON = "";
const APK_PINNED_BYTES = 0;
const APK_PINS = [];
// END GENERATED PINS musl

// BEGIN GENERATED OS FACTS glibc
// Written by `cargo xtask base groups levitate` from distro/variants/levitate/distro.toml
// (identity, profile, look); do not edit.
const RPM_OS = #{
    id: "levitateos",
    name: "LevitateOS",
    home_url: "https://levitateos.org",
    desktop: "plasma",
    appearance: "dark",
    light: #{
        surface: "#DDE2D2",
        surface_raised: "#E8ECDF",
        surface_sunken: "#CFD6C3",
        text: "#14221A",
        text_secondary: "#465047",
        text_muted: "#5C6459",
        rule: "#AEB8A4",
        hairline: "#C6CDB9",
        accent: "#214438",
        highlight: "#644532",
        band: "#214438",
        on_band: "#F2EEE4",
        ok: "#2F6B3F",
        warn: "#7F5200",
        bad: "#B22F27",
    },
    dark: #{
        surface: "#14221A",
        surface_raised: "#1D2D24",
        surface_sunken: "#0D1711",
        text: "#F2EEE4",
        text_secondary: "#BAC5B7",
        text_muted: "#9AA89D",
        rule: "#3A4B40",
        hairline: "#2A3B31",
        accent: "#C7D9BA",
        highlight: "#E4CBA6",
        band: "#214438",
        on_band: "#F2EEE4",
        ok: "#A9CF9A",
        warn: "#F0B866",
        bad: "#F0A497",
    },
};
// END GENERATED OS FACTS glibc

// BEGIN GENERATED OS FACTS musl
// Written by `cargo xtask base groups acorn` from distro/variants/acorn/distro.toml
// (identity, profile, look); do not edit.
const APK_OS = #{
    id: "acornos",
    name: "AcornOS",
    home_url: "",
    desktop: "lxqt",
    appearance: "dark",
    light: #{
        surface: "#E6DFCF",
        surface_raised: "#EFE9DB",
        surface_sunken: "#D9D1BE",
        text: "#241A12",
        text_secondary: "#54483C",
        text_muted: "#6B5D4F",
        rule: "#C2B8A2",
        hairline: "#D0C7B3",
        accent: "#644532",
        highlight: "#214438",
        band: "#644532",
        on_band: "#F2EEE4",
        ok: "#2F6B3F",
        warn: "#7F5200",
        bad: "#B22F27",
    },
    dark: #{
        surface: "#1F1711",
        surface_raised: "#2B2019",
        surface_sunken: "#150F0A",
        text: "#F2EEE4",
        text_secondary: "#CDBFAE",
        text_muted: "#A89886",
        rule: "#4D3D30",
        hairline: "#382B21",
        accent: "#E4CBA6",
        highlight: "#C7D9BA",
        band: "#644532",
        on_band: "#F2EEE4",
        ok: "#A9CF9A",
        warn: "#F0B866",
        bad: "#F0A497",
    },
};
// END GENERATED OS FACTS musl

// The rest is the same in every group recipe.
//
// Which build this system takes: the Fedora RPMs on glibc (LevitateOS), the
// Alpine APKs on musl (AcornOS). RUNTIME.host.libc is the C library of the
// system the group is installed into.
ctx.libc = RUNTIME.host.libc;
ctx.downloads = join_path(RUNTIME.paths.build, "downloads");
ctx.record = join_path(RUNTIME.paths.build, "system.pins");
ctx.system = join_path(RUNTIME.paths.output, "system");
if ctx.libc == "glibc" {
    ctx.format = "rpm";
    ctx.accounts = ACCOUNTS_GLIBC;
    ctx.pins = RPM_PINS;
    ctx.pinned_bytes = RPM_PINNED_BYTES;
} else if ctx.libc == "musl" {
    ctx.format = "apk";
    ctx.accounts = ACCOUNTS_MUSL;
    ctx.pins = APK_PINS;
    ctx.pinned_bytes = APK_PINNED_BYTES;
} else {
    ctx.format = "";
    ctx.accounts = [];
    ctx.pins = [];
    ctx.pinned_bytes = 0;
}
ctx.no_build = ctx.name + " has pins for glibc (Fedora RPMs, LevitateOS) and musl (Alpine APKs, AcornOS); " +
    "this system's C library is " + ctx.libc + ", for which it has none. `cargo xtask base groups <distro>` " +
    "writes a variant's pins once the recipe names seeds for its C library.";
if ctx.pinned_bytes > NEEDS.network_max_bytes {
    throw "the pinned packages (" + ctx.pinned_bytes + " bytes) exceed NEEDS.network_max_bytes; " +
        "`cargo xtask base groups <distro>` sets it";
}
// What the system tree was made from: one line per pinned package.
ctx.pins_record = "";
for pin in ctx.pins {
    ctx.pins_record += pin[3] + "  " + pin[1] + "\n";
}

fn archive_of(ctx, pin) {
    join_path(ctx.downloads, pin[1])
}

fn check_system(ctx) {
    if ctx.pins.is_empty() { return needs_work(ctx, ctx.no_build); }
    if !is_file(ctx.record) || !is_dir(ctx.system) {
        return needs_work(ctx, "unpack the " + ctx.pins.len() + " packages of " + ctx.name);
    }
    if read_file(ctx.record) != ctx.pins_record {
        return needs_work(ctx, "the pinned package set of " + ctx.name + " changed");
    }
    ready(ctx)
}

fn is_acquired(ctx) {
    if ctx.pins.is_empty() { return needs_work(ctx, ctx.no_build); }
    for pin in ctx.pins {
        let archive = archive_of(ctx, pin);
        if !is_file(archive) { return needs_work(ctx, "download " + pin[1]); }
        verify_sha256(archive, pin[3]);
    }
    ready(ctx)
}

// Each pinned file by its SHA-256: from the install medium's cache when
// Recipe finds it there, else from the distribution's mirror.
fn acquire(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    mkdir(ctx.downloads);
    let done = 0;
    for pin in ctx.pins {
        progress(done, ctx.pins.len(), "packages");
        download(pin[2], archive_of(ctx, pin), pin[3]);
        done += 1;
    }
    progress(done, ctx.pins.len(), "packages");
    ctx
}

fn is_built(ctx) {
    check_system(ctx)
}

// Unpacks every package into one system tree, natively, without running any
// of its scripts. Paths a system package does not own (run-time data: run,
// tmp and the like) are left out. Under var/, only what a package needs and
// nothing at boot makes (pin[6]: it ships no tmpfiles.d, and AcornOS runs
// none) is kept, as state seeds: created where missing, never owned or
// removed. Owners stay names, resolved in the root the group is written
// into, after the accounts it needs are made there: those in its own
// usr/lib/sysusers.d (Fedora packages ship them) and ACCOUNTS_* above.
fn build(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    if exists(ctx.record) { rm(ctx.record); }
    if exists(ctx.system) { rm(ctx.system); }
    mkdir(ctx.system);
    let done = 0;
    // Packages whose var/ is not kept first, then the var/ they left, then
    // the packages whose var/ is kept.
    for seeds in [false, true] {
        for pin in ctx.pins {
            if pin[6] != seeds { continue; }
            progress(done, ctx.pins.len(), "packages");
            let archive = archive_of(ctx, pin);
            verify_sha256(archive, pin[3]);
            if ctx.format == "apk" {
                target_extract_apk(archive, ctx.system);
            } else {
                target_extract_rpm(archive, ctx.system);
            }
            done += 1;
        }
        let state = join_path(ctx.system, "var");
        if !seeds && exists(state) { rm(state); }
    }
    progress(done, ctx.pins.len(), "packages");
    // This group's configuration (configure, above): files in its own tree,
    // so the receipt owns them and removing the group removes them.
    configure(ctx);
    for dir in ["run", "tmp", "boot", "home", "root", "proc", "sys", "dev", "lost+found", "var/run", "var/tmp", "var/lock"] {
        let path = join_path(ctx.system, dir);
        if exists(path) { rm(path); }
    }
    target_finalize(ctx.system, #{ owners: "apply", seed: "var", accounts: ctx.accounts });
    write_file(ctx.record, ctx.pins_record);
    ctx
}

fn is_installed(ctx) {
    if !is_dir(ctx.system) { return needs_work(ctx, "unpack the packages of " + ctx.name); }
    ctx.outputs.system = ctx.system;
    check_system(ctx)
}

fn install(ctx) {
    // The unpacked tree is already in owned storage; publish it as it is.
    ctx.outputs.system = ctx.system;
    ctx
}

fn remove(ctx) {
    if exists(ctx.system) { rm(ctx.system); }
    if exists(ctx.record) { rm(ctx.record); }
    ctx.outputs = #{};
    ctx
}

// ---------------------------------------------------------------------------
// Configuration helpers: what a group adds to its own tree.
// ---------------------------------------------------------------------------

// `content` at `path` (relative to the tree) with `mode`, replacing what is there.
fn put(ctx, path, content, mode) {
    let dest = join_path(ctx.system, path);
    mkdir(dirname(dest));
    if exists(dest) { rm(dest); }
    write_file(dest, content);
    target_mode(ctx.system, path, mode);
}
// A symbolic link at `path` to `target`.
fn put_link(ctx, path, target) {
    let dest = join_path(ctx.system, path);
    mkdir(dirname(dest));
    ln_force(target, dest);
}
// The text of the packaged file `path`; the group's packages must ship it.
fn tree_text(ctx, path) {
    let file = join_path(ctx.system, path);
    if !is_file(file) { throw ctx.name + ": its packages no longer ship /" + path; }
    read_file(file)
}
// Start a system service at boot, in this system's init's own form: on
// systemd (Fedora) the links `systemctl enable` makes, the unit's Alias=
// names included (D-Bus activation finds dbus-org.* through them); on
// OpenRC (Alpine) the service in its runlevel.
fn enable_service(ctx, unit, service) {
    if ctx.format == "rpm" {
        let file = "usr/lib/systemd/system/" + unit;
        let text = tree_text(ctx, file);
        put_link(ctx, "etc/systemd/system/multi-user.target.wants/" + unit, "/" + file);
        for line in text.split("\n") {
            if line.starts_with("Alias=") {
                for alias in trim(line.sub_string(6)).split(" ") {
                    if alias != "" { put_link(ctx, "etc/systemd/system/" + alias, "/" + file); }
                }
            }
        }
    } else {
        if !is_file(join_path(ctx.system, "etc/init.d/" + service)) { throw ctx.name + ": its packages no longer ship the OpenRC service " + service; }
        put_link(ctx, "etc/runlevels/default/" + service, "/etc/init.d/" + service);
    }
}

// ---------------------------------------------------------------------------
// This group's configuration (hand-written).
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// The look, as the OS builder computed it (installed-system.rhai): the colour
// schemes and settings derived from the OS's palettes (ctx.os, the generated
// OS facts). Kept the same as the builder's functions.
// ---------------------------------------------------------------------------

// Mode `mode`'s palette: role -> "#RRGGBB".
fn palette(os, mode) {
    let p = os[mode];
    if type_of(p) != "map" { throw "the OS facts have no " + mode + " palette"; }
    p
}
// The palette roles (distro_contract::Palette).
fn palette_roles() {
    ["surface", "surface_raised", "surface_sunken", "text", "text_secondary", "text_muted", "rule", "hairline",
     "accent", "highlight", "band", "on_band", "ok", "warn", "bad"]
}
// "#RRGGBB" as [r, g, b].
fn rgb(hex) { [parse_int(hex.sub_string(1, 2), 16), parse_int(hex.sub_string(3, 2), 16), parse_int(hex.sub_string(5, 2), 16)] }

// A palette's colours as [r, g, b] (0-255).
fn rgb_palette(p) {
    let out = #{};
    for role in palette_roles() {
        out[role] = rgb(p[role]);
    }
    out
}
// `a` moved towards `b` by `t` (0.0 to 1.0); both [r, g, b].
fn mix(a, b, t) {
    let out = [];
    for i in 0..3 { out.push((a[i].to_float() * (1.0 - t) + b[i].to_float() * t).round().to_int()); }
    out
}
// "r,g,b", as KDE and Konsole write a colour.
fn kde(c) { "" + c[0] + "," + c[1] + "," + c[2] }
// Whether a colour is dark (relative luminance under one half).
fn is_dark(c) {
    (0.2126 * c[0].to_float() + 0.7152 * c[1].to_float() + 0.0722 * c[2].to_float()) / 255.0 < 0.5
}
// The palette (as [r, g, b]) whose accent and status colours read on `bg`:
// the dark mode's on a dark background, the light mode's on a light one.
fn palette_on(os, bg) {
    let mode = if is_dark(bg) { "dark" } else { "light" };
    rgb_palette(palette(os, mode))
}
// The icon theme of the mode (Breeze on both desktops).
fn icon_theme(mode) { if mode == "dark" { "breeze-dark" } else { "breeze" } }
// The colour schemes' name for mode `mode`: the OS's name and the mode
// ("LevitateOSLight"), the name of a KDE colour scheme and of a terminal scheme.
fn scheme_name(os, mode) {
    let name = os.name.replace(" ", "");
    name + (if mode == "dark" { "Dark" } else { "Light" })
}

// `text` (an INI file) with `key` in `section` set to `value`: the line
// replaced where the key is there, added at the end of the section where it
// is not, and the section added at the end where the file lacks it.
fn ini_set(text, section, key, value) {
    if text.ends_with("\n") { text = text.sub_string(0, text.len() - 1); }
    let out = "";
    let current = "";
    let seen = false;
    let done = false;
    for line in text.split("\n") {
        let t = trim(line);
        if t.starts_with("[") && t.ends_with("]") {
            if current == section && !done { out += key + "=" + value + "\n"; done = true; }
            current = t.sub_string(1, t.len() - 2);
            if current == section { seen = true; }
        } else if current == section && t.starts_with(key + "=") {
            if !done { out += key + "=" + value + "\n"; done = true; }
            continue;
        }
        out += line + "\n";
    }
    if !done {
        if !seen { out += "\n[" + section + "]\n"; }
        out += key + "=" + value + "\n";
    }
    out
}

// One group of a KDE colour scheme: backgrounds `bg` and `alt`, text `fg`,
// `inactive` text, the `active`, link and focus colour `active`, `visited`
// links, and `status`'s ok, warn and bad as positive, neutral and negative.
fn kde_group(name, bg, alt, fg, inactive, active, visited, status) {
    let t = "[" + name + "]\n";
    t += "BackgroundAlternate=" + kde(alt) + "\nBackgroundNormal=" + kde(bg) + "\n";
    t += "DecorationFocus=" + kde(active) + "\nDecorationHover=" + kde(active) + "\n";
    t += "ForegroundActive=" + kde(active) + "\nForegroundInactive=" + kde(inactive) + "\n";
    t += "ForegroundLink=" + kde(active) + "\nForegroundNegative=" + kde(status.bad) + "\n";
    t += "ForegroundNeutral=" + kde(status.warn) + "\nForegroundNormal=" + kde(fg) + "\n";
    t += "ForegroundPositive=" + kde(status.ok) + "\nForegroundVisited=" + kde(visited) + "\n\n";
    t
}
// The colour groups of mode `mode`'s KDE colour scheme, from its palette:
// window surface, views raised with sunken alternate rows, the accent for
// selection (with surface text), focus, hover and links, the highlight for
// visited links, ok/warn/bad for positive/neutral/negative, and the band
// (with on_band text) for headers, title bars and the complementary areas
// (login and lock screens, OSDs). The effects are Breeze's.
fn kde_colour_groups(os, mode) {
    let p = rgb_palette(palette(os, mode));
    let s = palette_on(os, p.accent);
    let b = palette_on(os, p.band);
    let t = "[ColorEffects:Disabled]\nColor=56,56,56\nColorAmount=0\nColorEffect=0\nContrastAmount=0.65\nContrastEffect=1\nIntensityAmount=0.1\nIntensityEffect=2\n\n";
    t += "[ColorEffects:Inactive]\nChangeSelectionColor=true\nColor=112,111,110\nColorAmount=0.025\nColorEffect=2\nContrastAmount=0.1\nContrastEffect=2\nEnable=false\nIntensityAmount=0\nIntensityEffect=0\n\n";
    t += kde_group("Colors:Button", p.surface_raised, mix(p.surface_raised, p.accent, 0.25), p.text, p.text_muted, p.accent, p.highlight, p);
    t += kde_group("Colors:Complementary", p.band, mix(p.band, p.on_band, 0.1), p.on_band, mix(p.on_band, p.band, 0.35), b.accent, b.highlight, b);
    t += kde_group("Colors:Header", p.band, mix(p.band, p.on_band, 0.1), p.on_band, mix(p.on_band, p.band, 0.35), b.accent, b.highlight, b);
    t += kde_group("Colors:Header][Inactive", p.surface, p.surface_sunken, p.text, p.text_muted, p.accent, p.highlight, p);
    t += kde_group("Colors:Selection", p.accent, mix(p.accent, p.surface, 0.5), p.surface, mix(p.surface, p.accent, 0.3), p.surface, p.surface, s);
    t += kde_group("Colors:Tooltip", p.surface_raised, p.surface, p.text, p.text_muted, p.accent, p.highlight, p);
    t += kde_group("Colors:View", p.surface_raised, p.surface_sunken, p.text, p.text_muted, p.accent, p.highlight, p);
    t += kde_group("Colors:Window", p.surface, p.surface_sunken, p.text, p.text_muted, p.accent, p.highlight, p);
    t += "[WM]\nactiveBackground=" + kde(p.band) + "\nactiveBlend=" + kde(p.band) + "\nactiveForeground=" + kde(p.on_band) + "\n";
    t += "inactiveBackground=" + kde(p.surface_sunken) + "\ninactiveBlend=" + kde(p.surface_sunken) + "\ninactiveForeground=" + kde(p.text_muted) + "\n\n";
    t
}
// Mode `mode`'s whole KDE colour scheme file.
fn kde_colour_scheme(os, mode) {
    let t = kde_colour_groups(os, mode);
    t += "[General]\nColorScheme=" + scheme_name(os, mode) + "\nName=" + os.name + (if mode == "dark" { " Dark" } else { " Light" }) + "\nshadeSortColumn=true\n\n";
    t += "[KDE]\ncontrast=4\n";
    t
}

// The terminal's blue, magenta and cyan for mode `mode` (the same on both
// distros): the look palette has no such hues, and its accent and highlight
// sit too close to green and yellow to tell apart in `ls`, diffs and
// compiler output.
fn terminal_hues(mode) {
    if mode == "dark" { #{ blue: "#9BB8D9", magenta: "#D4A5C9", cyan: "#9ACFC4" } }
    else { #{ blue: "#2A5C8A", magenta: "#7A3F6E", cyan: "#1F6F6B" } }
}

// Mode `mode`'s terminal colour scheme (Konsole's and QTermWidget's format):
// the palette's surface behind its text, and a 16-colour set at least 3:1 on
// that surface: black the text on light (on dark, the muted text dimmed
// towards the surface, which still reads), bright black the muted text,
// white the secondary text and bright white the text; red, green, yellow
// bad, ok, warn; blue, magenta, cyan terminal_hues. Bright colours lean
// towards the text, faint ones towards the surface.
fn terminal_scheme(os, mode) {
    let p = rgb_palette(palette(os, mode));
    let hues = terminal_hues(mode);
    let blue = rgb(hues.blue);
    let magenta = rgb(hues.magenta);
    let cyan = rgb(hues.cyan);
    let black = if mode == "dark" { mix(p.text_muted, p.surface, 0.35) } else { p.text };
    let colours = [
        [black, p.text_muted],
        [p.bad, mix(p.bad, p.text, 0.25)],
        [p.ok, mix(p.ok, p.text, 0.25)],
        [p.warn, mix(p.warn, p.text, 0.25)],
        [blue, mix(blue, p.text, 0.25)],
        [magenta, mix(magenta, p.text, 0.25)],
        [cyan, mix(cyan, p.text, 0.25)],
        [p.text_secondary, p.text],
    ];
    let t = "[Background]\nColor=" + kde(p.surface) + "\n\n[BackgroundFaint]\nColor=" + kde(p.surface) + "\n\n[BackgroundIntense]\nColor=" + kde(p.surface) + "\n\n";
    for i in 0..8 {
        let c = colours[i];
        t += "[Color" + i + "]\nColor=" + kde(c[0]) + "\n\n";
        t += "[Color" + i + "Faint]\nColor=" + kde(mix(c[0], p.surface, 0.5)) + "\n\n";
        t += "[Color" + i + "Intense]\nColor=" + kde(c[1]) + "\n\n";
    }
    t += "[Foreground]\nColor=" + kde(p.text) + "\n\n[ForegroundFaint]\nColor=" + kde(p.text_secondary) + "\n\n[ForegroundIntense]\nColor=" + kde(p.text) + "\n\n";
    t += "[General]\nBlur=false\nColorRandomization=false\nDescription=" + os.name + (if mode == "dark" { " Dark" } else { " Light" }) + "\nOpacity=1\nWallpaper=\n";
    t
}


// Konsole's colours: the OS's terminal schemes in both modes, and a default
// profile on the dark one (a terminal is dark on both distros).
ctx.os = RPM_OS;
fn configure(ctx) {
    let os = ctx.os;
    for m in ["light", "dark"] {
        put(ctx, "usr/share/konsole/" + scheme_name(os, m) + ".colorscheme", terminal_scheme(os, m), 0o644);
    }
    let profile = os.name.replace(" ", "");
    put(ctx, "usr/share/konsole/" + profile + ".profile",
        "[Appearance]\nColorScheme=" + scheme_name(os, "dark") + "\n\n[General]\nName=" + profile + "\nParent=FALLBACK/\n", 0o644);
    let rc = read_file_or_empty(join_path(ctx.system, "etc/xdg/konsolerc"));
    put(ctx, "etc/xdg/konsolerc", ini_set(rc, "Desktop Entry", "DefaultProfile", profile + ".profile"), 0o644);
}
