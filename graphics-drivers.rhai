// graphics-drivers: a Recipe group, installed into the system root (`recipe --system install graphics-drivers`)
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
    network_max_bytes: 33554432,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "drivers-codecs",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "Mesa's open drivers for OpenGL and Vulkan, its VA-API video decoding, and Intel's media driver.",
    homepage: "https://mesa3d.org",
    license: "MIT AND BSD-3-Clause",
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
    "mesa-vulkan-drivers", "libva-intel-media-driver"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "mesa-dri-gallium", "mesa-va-gallium", "intel-media-driver", "mesa-vulkan-intel",
    "mesa-vulkan-ati"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs"];

let ctx = #{
    name: "graphics-drivers",
    version: "2026.11.13",
    description: "Mesa's OpenGL, Vulkan and video decoding drivers",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-10): 3 packages, 32799292 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-10";
const RPM_PINNED_BYTES = 32799292;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["intel-gmmlib", "intel-gmmlib-22.10.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/i/intel-gmmlib-22.10.2-1.fc45.x86_64.rpm", "123828b6b1ce74813f2c6b1653a7232d07aab0734aadb35fb28853de4d44b00e", 209261, "MIT AND BSD-3-Clause", false],
    ["libva-intel-media-driver", "libva-intel-media-driver-26.3.5-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libva-intel-media-driver-26.3.5-1.fc45.x86_64.rpm", "6003f6eea5ca5fff7361714a733fc9965ffe80f585de93637308dbc17724a576", 3591941, "MIT and BSD", false],
    ["mesa-vulkan-drivers", "mesa-vulkan-drivers-26.2.6-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/m/mesa-vulkan-drivers-26.2.6-1.fc45.x86_64.rpm", "8b89ac6263e0c39162d68500d76f36bf1ba23c12aec45a51974f6f02aad65e4d", 28998090, "MIT AND BSD-3-Clause AND SGI-B-2.0", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-13): 7 packages, 26706466 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-13";
const APK_PINNED_BYTES = 26706466;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["intel-gmmlib", "intel-gmmlib-22.10.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/intel-gmmlib-22.10.1-r0.apk", "6b7d2f7ec0d28216c4f4a8f9a737bf5eb05cb835cf00ddb069344f194db6fe43", 299738, "MIT", false],
    ["intel-media-driver", "intel-media-driver-26.2.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/intel-media-driver-26.2.1-r0.apk", "af46dd5c13bdbab4e22831a3e5d6be706a9dd1d0f9dbcfa6ac09557ef101f8f4", 12253500, "BSD-3-Clause AND MIT", false],
    ["libdisplay-info", "libdisplay-info-0.3.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libdisplay-info-0.3.0-r0.apk", "f356bc2fd3ea269f58de6688a550503318216bba87899281c36dbb16285f873c", 79051, "MIT", false],
    ["mesa-dri-gallium", "mesa-dri-gallium-26.1.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/mesa-dri-gallium-26.1.6-r0.apk", "91a8c6d8186a0f855e545cd7d7fedeb6265e90b0d74fda2538652665941d1de5", 21894, "MIT AND SGI-B-2.0 AND BSL-1.0", false],
    ["mesa-va-gallium", "mesa-va-gallium-26.1.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/mesa-va-gallium-26.1.6-r0.apk", "553dbf9f323d1d8b30281f40e3d26df7230cbc1c8af32005a56a83ff281e2cf4", 1674, "MIT AND SGI-B-2.0 AND BSL-1.0", false],
    ["mesa-vulkan-ati", "mesa-vulkan-ati-26.1.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/mesa-vulkan-ati-26.1.6-r0.apk", "4d70c9ca8f38df444443db84fb4d20547b35143420fa9c90c58e7906825df27f", 4375409, "MIT AND SGI-B-2.0 AND BSL-1.0", false],
    ["mesa-vulkan-intel", "mesa-vulkan-intel-26.1.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/mesa-vulkan-intel-26.1.6-r0.apk", "8e30f65bdd8df951f165be81794b27289c272991b117048e502161263d82fe73", 9675200, "MIT AND SGI-B-2.0 AND BSL-1.0", false],
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
