// spelling: a Recipe group, installed into the system root (`recipe --system install spelling`)
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
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "Hunspell and its English dictionaries, for spell checking in the programs that use it.",
    homepage: "https://hunspell.github.io",
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
const SEEDS_GLIBC = [
    "hunspell"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "hunspell", "hunspell-en"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = [];

let ctx = #{
    name: "spelling",
    version: "2026.11.13",
    description: "English spelling dictionaries",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-10): 3 packages, 658702 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-10";
const RPM_PINNED_BYTES = 658702;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["hunspell", "hunspell-1.7.6-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/h/hunspell-1.7.6-1.fc45.x86_64.rpm", "d0aef462490b0f533872e1c4906b108c026e5b6d8443a38f39272f110a324972", 475372, "LGPL-2.1-or-later OR GPL-2.0-or-later OR MPL-1.1", false],
    ["hunspell-en-US", "hunspell-en-US-0.20260225-3.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/h/hunspell-en-US-0.20260225-3.fc45.noarch.rpm", "efb6564e75afab50bc1615565e2add0647516a46e67c4fd07f0276303d5a62ea", 175270, "LGPL-2.1-or-later AND LGPL-2.1-only AND BSD-3-Clause-Modification", false],
    ["hunspell-filesystem", "hunspell-filesystem-1.7.6-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/h/hunspell-filesystem-1.7.6-1.fc45.x86_64.rpm", "7882079824d8775dc603aca10081390fc7ee5225579c82b50e97c5b75a54b6e0", 8060, "LGPL-2.1-or-later OR GPL-2.0-or-later OR MPL-1.1", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-13): 25 packages, 1362448 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-13";
const APK_PINNED_BYTES = 1362448;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["hunspell", "hunspell-1.7.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-1.7.3-r0.apk", "bd98c4e5f93c07e491396dcd8b8a78840272f3064a7383659b8dbe207ecd48c0", 84238, "GPL-2.0-or-later OR LGPL-2.1-or-later OR MPL-1.1", false],
    ["hunspell-en", "hunspell-en-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-2020.12.07-r4.apk", "7469bf74b34bdb13d5005bb1fe63668ba16bb0ed1347a4d70d832c390acda62e", 1365, "custom", false],
    ["hunspell-en-ag", "hunspell-en-ag-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-ag-2020.12.07-r4.apk", "3fc00dcecf42682eaa3a1f7dca9ae8f402e9c3477ceeb24588941b3d88972334", 1673, "custom", false],
    ["hunspell-en-au", "hunspell-en-au-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-au-2020.12.07-r4.apk", "aecef7fe7197e7d5e9c13b2f863a120e99552e5f9f29501a3a296c46e4eb6745", 194708, "custom", false],
    ["hunspell-en-bs", "hunspell-en-bs-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-bs-2020.12.07-r4.apk", "9631e046d773d28fac992353d493b21c6ba9c28cccca8a5efa4fc2eadf876807", 1670, "custom", false],
    ["hunspell-en-bw", "hunspell-en-bw-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-bw-2020.12.07-r4.apk", "d7e0f6de818b10c019511c679b11534bc979a8dfc38c5ace5d556a56e39ac235", 1673, "custom", false],
    ["hunspell-en-bz", "hunspell-en-bz-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-bz-2020.12.07-r4.apk", "fdf1c8a37adbcdf0917f78f8596cae03a090fc80be2fa7124d1e607c01808b6a", 1673, "custom", false],
    ["hunspell-en-ca", "hunspell-en-ca-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-ca-2020.12.07-r4.apk", "e012aa6b33f1dc5c838a8326581e4643cc69d933fd3bb1935c45b3807185e1e9", 193804, "custom", false],
    ["hunspell-en-dk", "hunspell-en-dk-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-dk-2020.12.07-r4.apk", "5bfc28bd842e0efd5e48b824045c5a7b8fc4df94a00b37de52c5572d07f33a86", 1678, "custom", false],
    ["hunspell-en-gb", "hunspell-en-gb-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-gb-2020.12.07-r4.apk", "07a6ae9f23e4dc1273da24e6e0e47d2275e8b437f3543fb4225434b7911ba0b3", 311672, "custom", false],
    ["hunspell-en-gh", "hunspell-en-gh-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-gh-2020.12.07-r4.apk", "3caf0f181156994233dbb6eba0e05a0acddcb1cd83d27a2b1d956c0f328375b9", 1674, "custom", false],
    ["hunspell-en-hk", "hunspell-en-hk-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-hk-2020.12.07-r4.apk", "0edb758cdc3a82a12404956dc7fc99a57e8e3c888cd3f91400d34ca54e855fa9", 1675, "custom", false],
    ["hunspell-en-ie", "hunspell-en-ie-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-ie-2020.12.07-r4.apk", "4fc39ad86e3c70f388750118cce33bc916408bb147d7a707c0b51a7bc774687f", 1672, "custom", false],
    ["hunspell-en-in", "hunspell-en-in-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-in-2020.12.07-r4.apk", "71da9963c377a2e39daa7a6074705a967417b45ad6530c6d594e4851e7c4239b", 1677, "custom", false],
    ["hunspell-en-jm", "hunspell-en-jm-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-jm-2020.12.07-r4.apk", "e43239679113bc09803b093f885d5f662f0ff639a03ac487054ce53451e2ca7a", 1678, "custom", false],
    ["hunspell-en-na", "hunspell-en-na-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-na-2020.12.07-r4.apk", "e44d42cb5bd2abdf0fac26f082667bcc8956f77f3fbd3585f44b37506d9d0ad9", 1673, "custom", false],
    ["hunspell-en-ng", "hunspell-en-ng-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-ng-2020.12.07-r4.apk", "85f8f435fe79e9068adcb421c1d84e5b9762519aca27f82c7d1f3f35fa2edee2", 1669, "custom", false],
    ["hunspell-en-nz", "hunspell-en-nz-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-nz-2020.12.07-r4.apk", "7a9da838de9e2a9e703ea1568ed74ceb511f9092a2ade3713ff6982079febf74", 1676, "custom", false],
    ["hunspell-en-ph", "hunspell-en-ph-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-ph-2020.12.07-r4.apk", "db44406fe0c9475d1f825331befd808d752bc44936dd4c59f8d463a22e433a76", 1670, "custom", false],
    ["hunspell-en-sg", "hunspell-en-sg-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-sg-2020.12.07-r4.apk", "f91f18cdf2d8f63e59344e781839039412d76839dbc1a5792f89520e0d57918e", 1674, "custom", false],
    ["hunspell-en-tt", "hunspell-en-tt-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-tt-2020.12.07-r4.apk", "a1c7e683f3388257bb7f9cc40d27ed1c57cbc67fd9f6bee881f1dfa44badd307", 1669, "custom", false],
    ["hunspell-en-us", "hunspell-en-us-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-us-2020.12.07-r4.apk", "70184eb80a7aadacdd4f0c6127b46404632d66e6e4ab89c82ffdba7ea4f0d5d1", 193914, "custom", false],
    ["hunspell-en-za", "hunspell-en-za-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-za-2020.12.07-r4.apk", "a15eee71065cc37fa2b9d4b373a7d3cc645378888f190caddac83d17550e4487", 1677, "custom", false],
    ["hunspell-en-zw", "hunspell-en-zw-2020.12.07-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/hunspell-en-zw-2020.12.07-r4.apk", "2c1b759b0caaa210c314c495882c249e944f644980d611eec1483de98fe49d92", 1679, "custom", false],
    ["libhunspell", "libhunspell-1.7.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libhunspell-1.7.3-r0.apk", "2063f6fdac221ff1ed97e5914c75f6551d462c6034b501782ae9f4d1d2a1e58e", 352617, "GPL-2.0-or-later OR LGPL-2.1-or-later OR MPL-1.1", false],
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
