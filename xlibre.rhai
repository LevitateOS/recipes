// xlibre: a Recipe group, installed into the system root (`recipe --system install xlibre`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps).
// Generated: the two pin blocks, `version` and `network_max_bytes`, written by
// `cargo xtask base groups levitate` (glibc: Fedora RPMs) and
// `cargo xtask base groups acorn` (musl: Alpine APKs) from the seeds below. A
// package more than one group needs belongs to desktop-libs.
//
// The X server itself (Xorg, its setuid wrapper, /usr/bin/X, the modesetting
// and libinput drivers, the server's other modules and its xorg.conf.d
// snippets) is not in a package: the OS builder compiles it from pinned
// XLibre source (distro/builder/os-recipes/xlibre.rhai) and publishes the
// tree as the LevitateOS/prebuilt release `display-server-<key16>`. This
// recipe pins that archive (PREBUILT below, as rec-apps pins the desktop
// apps) and puts the files FILES lists into the same system tree as the
// packages. Nothing generates PREBUILT: when a new display-server prebuilt is
// published (the XLibre pins or the Alpine build root changed), move PREBUILT
// to the newest `display-server-<key16>` release by hand: its asset's URL and
// the SHA-256 GitHub shows for it, and OTHER_DOWNLOAD_BYTES to its size.
const RECIPE_API = 3;
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443", "github.com:443", "release-assets.githubusercontent.com:443", "objects.githubusercontent.com:443"],
    network_max_bytes: 6291456,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "drivers-codecs",
    libc: ["musl"],
    systems: ["acornos"],
    details: "The XLibre X server, its libinput driver and what they load at run time: the keymap compiler and keymaps, the cursor and fixed fonts, Mesa's EGL and GBM for glamor and the libraries the server links. The server itself, with its setuid wrapper, /usr/bin/X and the modesetting and libinput drivers, is the OS builder's pinned prebuilt tree, compiled from pinned XLibre source.",
    homepage: "https://github.com/X11Libre",
    license: "MIT AND X11 AND LGPL-2.1-or-later",
    steps: #{
        acquire: "Takes each pinned package and the pinned display-server prebuilt by their SHA-256, from the install medium's cache or the distribution's mirror and GitHub.",
        build: "Unpacks the packages natively into one system tree, without running their scripts, and adds the X server's files from the prebuilt, the wrapper setuid root.",
        install: "Publishes the system tree for Recipe to write into the system root, with a receipt.",
    },
    keeps: [],
};

// What this group installs, by name; the generator adds what they need.
// LevitateOS (glibc, Fedora 45):
const SEEDS_GLIBC = [];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "xkbcomp", "font-cursor-misc", "font-misc-misc", "libxfont2", "libxcvt"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs"];

let ctx = #{
    name: "xlibre",
    version: "2026.11.16",
    description: "The XLibre display server and its run-time parts",
};

// The display-server prebuilt: the LevitateOS/prebuilt release
// `display-server-<key16>` that `prebuilt publish display-server acorn`
// makes. [file, URL, SHA-256 (the digest GitHub publishes for the asset)].
// Moved by hand to each new release (see the header).
const OTHER_DOWNLOAD_BYTES = 1469755;
const PREBUILT = #{
    musl: ["display-server-acorn.tar.gz",
           "https://github.com/LevitateOS/prebuilt/releases/download/display-server-56df0167e337c893/display-server-acorn.tar.gz",
           "76374e35feae26a044e4f5e5bd1045403473d6f0bf85454025dccf177008bfe5"],
};
// What the system tree takes from the prebuilt tree: [path, mode], the
// builder's installed-files list. Xorg.wrap is setuid root as in Alpine's
// package; the prebuilt keeps that mode in its target metadata, which a
// plain unpack does not carry, so it is set here. /usr/bin/X (the link the
// display manager starts) and /var/lib/xkb are made in configure.
const XORG_MODULES = "usr/lib/xorg/modules/xlibre-25";
const FILES = [
    ["usr/bin/Xorg", 0o755],
    ["usr/bin/gtf", 0o755],
    ["usr/libexec/Xorg", 0o755],
    ["usr/libexec/Xorg.wrap", 0o4555],
    ["usr/lib/xorg/protocol.txt", 0o644],
    [XORG_MODULES + "/drivers/modesetting_drv.so", 0o755],
    [XORG_MODULES + "/input/libinput_drv.so", 0o755],
    [XORG_MODULES + "/extensions/libglx.so", 0o755],
    [XORG_MODULES + "/libglamoregl.so", 0o755],
    [XORG_MODULES + "/libexa.so", 0o755],
    [XORG_MODULES + "/libfbdevhw.so", 0o755],
    [XORG_MODULES + "/libint10.so", 0o755],
    [XORG_MODULES + "/libshadow.so", 0o755],
    [XORG_MODULES + "/libshadowfb.so", 0o755],
    [XORG_MODULES + "/libvgahw.so", 0o755],
    [XORG_MODULES + "/libwfb.so", 0o755],
    ["usr/share/X11/xorg.conf.d/10-quirks.conf", 0o644],
    ["usr/share/X11/xorg.conf.d/40-libinput.conf", 0o644],
];

// BEGIN GENERATED PINS glibc
// No glibc build: this recipe names no seeds in SEEDS_GLIBC. Written by
// `cargo xtask base groups levitate`; do not edit.
const RPM_PINNED_ON = "";
const RPM_PINNED_BYTES = 0;
const RPM_PINS = [];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-16): 7 packages, 3913476 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-16";
const APK_PINNED_BYTES = 3913476;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["font-alias", "font-alias-1.0.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/font-alias-1.0.6-r0.apk", "754e5c1d19c2c69d5a2c3c02c7340cad7df3c26e63789516372ea164b564b927", 3949, "custom", false],
    ["font-cursor-misc", "font-cursor-misc-1.0.4-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/font-cursor-misc-1.0.4-r1.apk", "a1a0c0659a9a48e24b4cc4b35583f4e57da9d2a0ae2cc8adb9be1143b66911b4", 7013, "Public Domain", false],
    ["font-misc-misc", "font-misc-misc-1.1.3-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/font-misc-misc-1.1.3-r1.apk", "2c48f2a8529ac63243a0bdd5e7ab2329e0a8b8f996ffe95faed8b79fb05b4a52", 3688045, "Public Domain", false],
    ["libxcvt", "libxcvt-0.1.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libxcvt-0.1.3-r0.apk", "809b454981887c1d1d835c909c46a80650ca72a73a92268a2cf8a666ad82b6b7", 6870, "custom", false],
    ["libxfont2", "libxfont2-2.0.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libxfont2-2.0.8-r0.apk", "f8bf87b9ce835cb307eb8a3d270e226c4437757478c52ba3ad384cecc2ac6fef", 102320, "MIT", false],
    ["util-macros", "util-macros-1.20.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/util-macros-1.20.2-r0.apk", "7c129d085b646b13ccef3738e93038221aec840c1a6764279c5adc9950ba1bdc", 24899, "MIT", false],
    ["xkbcomp", "xkbcomp-1.5.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/xkbcomp-1.5.0-r0.apk", "8bfbd3c8ce7180e8cf599d5a0b791993b61fa98f3a19c47aaf5fcbe30c12d0ba", 80380, "MIT", false],
];
// END GENERATED PINS musl

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
// The display-server prebuilt (xlibre only: not a step of the shared tail in
// other group recipes).
ctx.prebuilt = PREBUILT[ctx.libc];
ctx.prebuilt_archive = join_path(ctx.downloads, "display-server-prebuilt.tar.gz");
ctx.prebuilt_unpacked = join_path(RUNTIME.paths.build, "display-server-unpacked");
if ctx.pinned_bytes + OTHER_DOWNLOAD_BYTES > NEEDS.network_max_bytes {
    throw "the pinned packages (" + ctx.pinned_bytes + " bytes) and the display-server prebuilt exceed NEEDS.network_max_bytes; " +
        "`cargo xtask base groups <distro>` sets it";
}
// What the system tree was made from: one line per pinned package.
ctx.pins_record = "";
for pin in ctx.pins {
    ctx.pins_record += pin[3] + "  " + pin[1] + "\n";
}
if type_of(ctx.prebuilt) != "()" {
    ctx.pins_record += ctx.prebuilt[2] + "  " + ctx.prebuilt[0] + "\n";
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
    // The display-server prebuilt.
    if !is_file(ctx.prebuilt_archive) { return needs_work(ctx, "download " + ctx.prebuilt[0]); }
    verify_sha256(ctx.prebuilt_archive, ctx.prebuilt[2]);
    ready(ctx)
}

// Each pinned file by its SHA-256: from the install medium's cache when
// Recipe finds it there, else from the distribution's mirror.
fn acquire(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    mkdir(ctx.downloads);
    let done = 0;
    let total = ctx.pins.len() + 1;
    for pin in ctx.pins {
        progress(done, total, "packages");
        download(pin[2], archive_of(ctx, pin), pin[3]);
        done += 1;
    }
    // The display-server prebuilt.
    progress(done, total, "packages");
    download(ctx.prebuilt[1], ctx.prebuilt_archive, ctx.prebuilt[2]);
    progress(total, total, "packages");
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

// The X server from the pinned prebuilt, into the same tree as the packages
// (build calls this before the tree is finalized).
fn configure(ctx) {
    if ctx.format != "apk" || type_of(ctx.prebuilt) == "()" { throw ctx.no_build; }
    verify_sha256(ctx.prebuilt_archive, ctx.prebuilt[2]);
    if exists(ctx.prebuilt_unpacked) { rm(ctx.prebuilt_unpacked); }
    mkdir(ctx.prebuilt_unpacked);
    extract(ctx.prebuilt_archive, ctx.prebuilt_unpacked);
    for file in FILES {
        let from = join_path(ctx.prebuilt_unpacked, file[0]);
        if !is_file(from) { throw "the prebuilt display server lacks /" + file[0]; }
        let dest = join_path(ctx.system, file[0]);
        mkdir(dirname(dest));
        if exists(dest) { rm(dest); }
        copy_file(from, dest);
        target_mode(ctx.system, file[0], file[1]);
    }
    rm(ctx.prebuilt_unpacked);
    // The link the display manager starts (SDDM runs /usr/bin/X): to the
    // wrapper script, as the server's own install makes it.
    put_link(ctx, "usr/bin/X", "Xorg");
    // Where the server writes the keymaps xkbcomp compiles: empty, a state
    // seed (the server's -Dxkb_output_dir).
    mkdir(join_path(ctx.system, "var/lib/xkb"));
    target_mode(ctx.system, "var/lib/xkb", 0o755);
}
