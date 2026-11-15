// mousepad: a Recipe group, installed into the system root (`recipe --system install mousepad`)
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
    network_max_bytes: 2097152,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "app",
    category: "utilities",
    libc: ["musl"],
    systems: ["acornos"],
    details: "Mousepad, a simple plain text editor.",
    homepage: "https://docs.xfce.org/apps/mousepad/start",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["mousepad"], menu: ["Mousepad"] },
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
    "mousepad"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs", "spelling"];

let ctx = #{
    name: "mousepad",
    version: "2026.11.16",
    description: "A text editor",
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
// 2026-11-16): 11 packages, 1263289 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-16";
const APK_PINNED_BYTES = 1263289;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["enchant2-data", "enchant2-data-2.8.15-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/enchant2-data-2.8.15-r0.apk", "1be5d65bf122c5c375728af9af52dde63412ef6d98c5089c99095b0d9c8ff869", 1697, "LGPL-2.1-or-later", false],
    ["enchant2-hunspell", "enchant2-hunspell-2.8.15-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/enchant2-hunspell-2.8.15-r0.apk", "0c8cc525327dc6937aa8aea0af2cb341a6ba16b00858c1267b8a0c9a8c45233f", 12685, "LGPL-2.1-or-later", false],
    ["enchant2-libs", "enchant2-libs-2.8.15-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/enchant2-libs-2.8.15-r0.apk", "34c7fdeb0b5313e362f0bd0fcd4d96ee636ac906770e67bb8fc5406d0ae3de5e", 26651, "LGPL-2.1-or-later", false],
    ["gspell", "gspell-1.14.4-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gspell-1.14.4-r0.apk", "27bc7825fdbe1660a22d1e1b624c60b29d67b371ef029077abbc0b6111275768", 117797, "LGPL-2.1-or-later", false],
    ["gtksourceview4", "gtksourceview4-4.8.4-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gtksourceview4-4.8.4-r4.apk", "fbc1905d4a5f7cbb1e33723ae1e9aef194da0878fde1134ec7840eea9afe843c", 587178, "GPL-2.0-or-later", false],
    ["libgtop", "libgtop-2.41.3-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libgtop-2.41.3-r1.apk", "810cfc7f4a50c2633ab6d022c63158b8512b788045a34524845d738301959f11", 44438, "LGPL-2.1-or-later", false],
    ["libxfce4ui", "libxfce4ui-4.20.1-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libxfce4ui-4.20.1-r1.apk", "19db529ac4d013e935470bbc2d3bc36278f9722bd7a5de234abf08e909ed4e70", 150199, "GPL-2.0-only", false],
    ["libxfce4util", "libxfce4util-4.20.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libxfce4util-4.20.1-r0.apk", "15e4802fe99771c93089080754a5f237221f6d5c7d676299aeccf19979a1e8e3", 37431, "GPL-2.0-only", false],
    ["mousepad", "mousepad-0.7.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/mousepad-0.7.0-r0.apk", "1d18dde5eeefb5087f50382304889f2c81e4cd094a65a6454283c34ff7b74453", 188904, "GPL-2.0-or-later", false],
    ["xfconf", "xfconf-4.20.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xfconf-4.20.0-r2.apk", "c936df109484021fb9d903f77acdd1b5b6365127a654280e3d835b82aa93dfd1", 93660, "GPL-2.0-only", false],
    ["xfconf-bash-completion", "xfconf-bash-completion-4.20.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xfconf-bash-completion-4.20.0-r2.apk", "5693c2c21a2a78980cedf6220a455a49974015de7f765105e8095f4b6c411498", 2649, "GPL-2.0-only", false],
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

// This group adds no configuration of its own.
fn configure(ctx) { }
