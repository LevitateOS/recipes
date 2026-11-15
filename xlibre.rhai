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
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    network_max_bytes: 4194304,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "drivers-codecs",
    libc: ["musl"],
    systems: ["acorn"],
    details: "What the XLibre X server and its libinput driver load at run time: the keymap compiler and keymaps, the cursor and fixed fonts, Mesa's EGL and GBM for glamor and the libraries the server links. The server itself is built from pinned source by the OS builder today; moving it into this recipe is a later step.",
    homepage: "https://github.com/X11Libre",
    license: "MIT AND X11 AND LGPL-2.1-or-later",
    steps: #{
        acquire: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        build: "Unpacks the packages natively into one system tree, without running their scripts.",
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
    version: "2026.11.13",
    description: "The run-time parts of the XLibre display server",
};

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
// 2026-11-13): 7 packages, 3913476 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-13";
const APK_PINNED_BYTES = 3913476;
// [name, file, URL, SHA-256, bytes, licence]
const APK_PINS = [
    ["font-alias", "font-alias-1.0.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/font-alias-1.0.6-r0.apk", "754e5c1d19c2c69d5a2c3c02c7340cad7df3c26e63789516372ea164b564b927", 3949, "custom"],
    ["font-cursor-misc", "font-cursor-misc-1.0.4-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/font-cursor-misc-1.0.4-r1.apk", "a1a0c0659a9a48e24b4cc4b35583f4e57da9d2a0ae2cc8adb9be1143b66911b4", 7013, "Public Domain"],
    ["font-misc-misc", "font-misc-misc-1.1.3-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/font-misc-misc-1.1.3-r1.apk", "2c48f2a8529ac63243a0bdd5e7ab2329e0a8b8f996ffe95faed8b79fb05b4a52", 3688045, "Public Domain"],
    ["libxcvt", "libxcvt-0.1.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libxcvt-0.1.3-r0.apk", "809b454981887c1d1d835c909c46a80650ca72a73a92268a2cf8a666ad82b6b7", 6870, "custom"],
    ["libxfont2", "libxfont2-2.0.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libxfont2-2.0.8-r0.apk", "f8bf87b9ce835cb307eb8a3d270e226c4437757478c52ba3ad384cecc2ac6fef", 102320, "MIT"],
    ["util-macros", "util-macros-1.20.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/util-macros-1.20.2-r0.apk", "7c129d085b646b13ccef3738e93038221aec840c1a6764279c5adc9950ba1bdc", 24899, "MIT"],
    ["xkbcomp", "xkbcomp-1.5.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/xkbcomp-1.5.0-r0.apk", "8bfbd3c8ce7180e8cf599d5a0b791993b61fa98f3a19c47aaf5fcbe30c12d0ba", 80380, "MIT"],
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
// of its scripts. Paths a system package does not own (per-machine and
// run-time data: var, run, tmp and the like) are left out; the system makes
// them at boot. Owners stay names, resolved in the root the group is written
// into, after the accounts it needs are made there: those in its own
// usr/lib/sysusers.d (Fedora packages ship them) and ACCOUNTS_* above.
fn build(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    if exists(ctx.record) { rm(ctx.record); }
    if exists(ctx.system) { rm(ctx.system); }
    mkdir(ctx.system);
    let done = 0;
    for pin in ctx.pins {
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
    progress(done, ctx.pins.len(), "packages");
    for dir in ["var", "run", "tmp", "boot", "home", "root", "proc", "sys", "dev", "lost+found"] {
        let path = join_path(ctx.system, dir);
        if exists(path) { rm(path); }
    }
    target_finalize(ctx.system, #{ owners: "apply", accounts: ctx.accounts });
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
