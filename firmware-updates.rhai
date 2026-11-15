// firmware-updates: a Recipe group, installed into the system root (`recipe --system install firmware-updates`)
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
    network_max_bytes: 8388608,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "drivers-codecs",
    libc: ["musl"],
    systems: ["acornos"],
    details: "fwupd, which reads and applies firmware updates published to the Linux Vendor Firmware Service.",
    homepage: "https://fwupd.org",
    license: "LGPL-2.1-or-later",
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
    "fwupd"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [
    "g plugdev -"
];
let deps = ["desktop-libs"];

let ctx = #{
    name: "firmware-updates",
    version: "2026.11.15",
    description: "Firmware updates through fwupd",
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
// 2026-11-15): 21 packages, 7420377 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-15";
const APK_PINNED_BYTES = 7420377;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["confuse", "confuse-3.3-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/confuse-3.3-r4.apk", "bca89843d222630acd850153b98b1400d5b88e58185f1c5f85959bd0ce19fe3e", 22339, "ISC", false],
    ["flashrom-libs", "flashrom-libs-1.6.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/flashrom-libs-1.6.0-r0.apk", "6d9419f4ecdbcc66d1d07bde32a1e7844b1403f5d3f86793049d64fef360a3f5", 221685, "GPL-2.0-or-later", false],
    ["fwupd", "fwupd-2.0.20-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/fwupd-2.0.20-r4.apk", "f7d73d209c4dd6a84742c91543a568c540c0d3a6fda0316ce4353f11d0701a6a", 4601207, "LGPL-2.1-or-later", false],
    ["fwupd-openrc", "fwupd-openrc-2.0.20-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/fwupd-openrc-2.0.20-r4.apk", "aff97a10269a12469413fbb449fe10c258f040f9ced27223ed50c34383649b7b", 2009, "LGPL-2.1-or-later", false],
    ["fwupd-polkit", "fwupd-polkit-2.0.20-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/fwupd-polkit-2.0.20-r4.apk", "cf4385b6c6496aa905b7408683c1aa6bc77007c48ae4506e569d9c56daa37b29", 27338, "LGPL-2.1-or-later", false],
    ["libarchive", "libarchive-3.8.11-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libarchive-3.8.11-r0.apk", "275ca3b65a540656c91f776a7e0f3ceee5240982218d16b6acba7d040f765599", 325544, "BSD-2-Clause AND BSD-3-Clause AND Public-Domain", false],
    ["libcbor", "libcbor-0.13.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libcbor-0.13.0-r0.apk", "bf24e82b1b10bac89d0139e130aeef974a39ed3098685ac04e69724235992830", 21942, "MIT", false],
    ["libftdi1", "libftdi1-1.5-r5.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libftdi1-1.5-r5.apk", "0c0738e3ad01bd10c39614150a8dcfd912965de505c59dd52c57b478b3ca0fbc", 33245, "LGPL-2.1-or-later AND GPL-2.0-only", false],
    ["libftdi1-udev", "libftdi1-udev-1.5-r5.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libftdi1-udev-1.5-r5.apk", "bb9b641d30504a47c474f951b1a9d0ed7111a01cce2cae5a90a2fdc829628f65", 1884, "LGPL-2.1-or-later AND GPL-2.0-only", false],
    ["libjcat", "libjcat-0.2.3-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libjcat-0.2.3-r2.apk", "9d58ee6ffd3efdc5b029649a8b7381646bf15aa2d7f17771a37320f50bedec74", 50793, "LGPL-2.1-or-later", false],
    ["libmbim", "libmbim-1.34.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libmbim-1.34.0-r1.apk", "d2e5b3bb1a7acf8d581e1bd8800731c755028df60621d5e8f088e43cc9a9080e", 277767, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["libmbim-bash-completion", "libmbim-bash-completion-1.34.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libmbim-bash-completion-1.34.0-r1.apk", "5e18e7e0a8de0a7a5e621f0cbd7b98114627c50d7e061292f582a83184a7d13a", 2376, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["libmbim-udev", "libmbim-udev-1.34.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libmbim-udev-1.34.0-r1.apk", "928f1c8822d54f550838cb39e9066e83b5cd8054599d1db781aecff912220531", 1910, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["libqmi", "libqmi-1.38.0_git20260414-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libqmi-1.38.0_git20260414-r0.apk", "2d2aab20dceb1f00f380e2f29e347758a45ab4c6db48de83d7c63a4ea90acfd0", 1427900, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["libqmi-bash-completion", "libqmi-bash-completion-1.38.0_git20260414-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libqmi-bash-completion-1.38.0_git20260414-r0.apk", "8e9ad7235362cd5242676b307a5cd8c4517940b1e965ffb4356ed58842022e09", 2767, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["libqrtr-glib", "libqrtr-glib-1.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libqrtr-glib-1.4.0-r0.apk", "73251e5c370ded1e47df8198c3902a9650848d88efcd1ddd8df12b6b9ef3f9cd", 15896, "LGPL-2.1-or-later", false],
    ["lz4-libs", "lz4-libs-1.10.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/lz4-libs-1.10.0-r1.apk", "3ad4912ab8ecf5f6236fdb751f88243006b3a8f152684e455b781e16284dd298", 79080, "BSD-2-Clause AND GPL-2.0-or-later", false],
    ["protobuf-c", "protobuf-c-1.5.2-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/protobuf-c-1.5.2-r2.apk", "7b27bf483eae1076ed9c5e76463ddb093e49a3b11e64312ec5c1bfa78aa1c604", 13365, "BSD-2-Clause", false],
    ["tpm2-tss-esys", "tpm2-tss-esys-4.1.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/tpm2-tss-esys-4.1.2-r0.apk", "f57f077b6d5eef91417937950c905c3d19a91145007dd441d12c82e82458a9a1", 186803, "BSD-2-Clause", false],
    ["tpm2-tss-mu", "tpm2-tss-mu-4.1.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/tpm2-tss-mu-4.1.2-r0.apk", "cbab61524026c254222679df7d964c15c3b3d2f677ee0aed02752ca4619135b0", 66135, "BSD-2-Clause", false],
    ["tpm2-tss-sys", "tpm2-tss-sys-4.1.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/tpm2-tss-sys-4.1.2-r0.apk", "c8ce365363f3c23c4425ead0a2df8c8123b67e6170cbceade013128ddea3b1d3", 38392, "BSD-2-Clause", false],
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
