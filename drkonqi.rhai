// drkonqi: a Recipe group, installed into the system root (`recipe --system install drkonqi`)
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
    network_max_bytes: 4194304,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "app",
    category: "utilities",
    libc: ["glibc"],
    systems: ["levitateos"],
    details: "DrKonqi shows what happened when a KDE program crashes and helps report it. Fedora's build needs Konsole.",
    homepage: "https://invent.kde.org/plasma/drkonqi",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["drkonqi"], menu: [] },
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
    "plasma-drkonqi"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs", "plasma", "konsole"];

let ctx = #{
    name: "drkonqi",
    version: "2026.11.15",
    description: "KDE's crash handler",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-15): 11 packages, 4009088 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-15";
const RPM_PINNED_BYTES = 4009088;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["elfutils", "elfutils-0.197-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/e/elfutils-0.197-1.fc45.x86_64.rpm", "46c498fc255dada98dfb250cfde0cd9c46b0e3e3855df643879db3b04ed23c64", 640402, "GPL-3.0-or-later AND (GPL-2.0-or-later OR LGPL-3.0-or-later) AND GFDL-1.3-no-invariants-or-later", false],
    ["elfutils-debuginfod-client", "elfutils-debuginfod-client-0.197-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/e/elfutils-debuginfod-client-0.197-1.fc45.x86_64.rpm", "86ca56dc35a1ca90a60ae458f627dbb3f440425ac8d80fa185bb6ebb8ce249df", 48496, "GPL-3.0-or-later AND (GPL-2.0-or-later OR LGPL-3.0-or-later)", false],
    ["elfutils-libs", "elfutils-libs-0.197-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/e/elfutils-libs-0.197-1.fc45.x86_64.rpm", "4a1196bc36a8ddae162d17d8158c52c137a027e7811d643b31da64ab04354bda", 292441, "GPL-2.0-or-later OR LGPL-3.0-or-later", false],
    ["libpfm", "libpfm-4.14.1-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libpfm-4.14.1-2.fc45.x86_64.rpm", "5b35a8b4eb160b8551459cea06ff87c9f8dbb16f873bb55785988e06a295385d", 284586, "MIT", false],
    ["plasma-drkonqi", "plasma-drkonqi-6.8.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-drkonqi-6.8.3-1.fc45.x86_64.rpm", "5192e0eb3f7f27f1250ac42c465c3fb0e3de2331788946baf253457bc23392f0", 1012599, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.1-only AND LGPL-3.0-only AND LGPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)", false],
    ["python3-certifi", "python3-certifi-2026.01.04-3.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-certifi-2026.01.04-3.fc45.noarch.rpm", "3050fe041977d3eb415ff596a1e3d00ecd2e316de9a5cb80edca974655f7b706", 15442, "MPL-2.0", false],
    ["python3-idna", "python3-idna-3.18-2.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-idna-3.18-2.fc45.noarch.rpm", "cece41068e2c7ce6e2b1054b16ee1e99cbfdd9df6151c824944540f2cb70b890", 107001, "BSD-3-Clause", false],
    ["python3-psutil", "python3-psutil-7.2.2-10.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-psutil-7.2.2-10.fc45.x86_64.rpm", "0f6f5e4b7123bf4229153b763f8d5a10da69593d260f7133e69942649e14c784", 275995, "BSD-3-Clause", false],
    ["python3-pygdbmi", "python3-pygdbmi-0.11.0.0-14.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-pygdbmi-0.11.0.0-14.fc45.noarch.rpm", "fabfd8ef39c1ec9b50d98dfb81c6aa429df6d64ca6bf1aff0324227c3bb7030d", 52917, "MIT", false],
    ["python3-sentry-sdk", "python3-sentry-sdk-2.48.0-6.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-sentry-sdk-2.48.0-6.fc45.noarch.rpm", "3faf5bb99bb3cd61009f983bc88645a74b68c01e0745af1c0962447e9e5717b7", 959425, "MIT", false],
    ["python3-urllib3", "python3-urllib3-2.8.0-3.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/python3-urllib3-2.8.0-3.fc45.noarch.rpm", "66c188d2c3444bf2b4a60b37bb3ec33710032857cc3ce67794088bc2f8c52d6d", 319784, "MIT", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// No musl build: this recipe names no seeds in SEEDS_MUSL. Written by
// `cargo xtask base groups acorn`; do not edit.
const APK_PINNED_ON = "";
const APK_PINNED_BYTES = 0;
const APK_PINS = [];
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
