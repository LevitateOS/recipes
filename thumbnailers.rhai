// thumbnailers: a Recipe group, installed into the system root (`recipe --system install thumbnailers`)
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
    network_max_bytes: 9437184,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "media",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "Thumbnails of images, documents and videos in the file manager.",
    homepage: "https://kde.org",
    license: "GPL-2.0-or-later",
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
    "kdegraphics-thumbnailers", "ffmpegthumbs"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "ffmpegthumbnailer"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs"];

let ctx = #{
    name: "thumbnailers",
    version: "2026.11.15",
    description: "File thumbnails",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-15): 3 packages, 185046 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-15";
const RPM_PINNED_BYTES = 185046;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["ffmpegthumbs", "ffmpegthumbs-26.08.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/f/ffmpegthumbs-26.08.3-1.fc45.x86_64.rpm", "1a651126ef1a22d153dee33b8ce500eca152aa753020ef86bb045bea3eaf416b", 53771, "GPL-2.0-or-later", false],
    ["kdegraphics-thumbnailers", "kdegraphics-thumbnailers-26.08.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kdegraphics-thumbnailers-26.08.3-1.fc45.x86_64.rpm", "520599508b8c0bcd5c3f785445bb856860951f44514b9a1eb76cd355f70a22fa", 78726, "GPL-2.0-or-later", false],
    ["libkdcraw", "libkdcraw-26.08.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libkdcraw-26.08.3-1.fc45.x86_64.rpm", "508d811e73b9f56c624309f34e2bc871b353b45b708baf813b4d035f4cb7f7dd", 52549, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-or-later", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-15): 22 packages, 8656062 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-15";
const APK_PINNED_BYTES = 8656062;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["cjson", "cjson-1.7.19-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/cjson-1.7.19-r1.apk", "b1aca971a5ba46e42169311ef7bcfa96eac40d39207b22dbd3af8d4f3103d1d8", 12866, "MIT", false],
    ["ffmpeg-libavfilter", "ffmpeg-libavfilter-8.1.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/ffmpeg-libavfilter-8.1.3-r0.apk", "8d9d2d27fc7938cd111c8086202d486b4ab1eacaca51427265bd898276535755", 2595295, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["ffmpeg-libavformat", "ffmpeg-libavformat-8.1.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/ffmpeg-libavformat-8.1.3-r0.apk", "1caff4921405cf58423c368c47268309d772e0b9b9203f9c46fad7eea9096911", 1506381, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["ffmpeg-libswscale", "ffmpeg-libswscale-8.1.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/ffmpeg-libswscale-8.1.3-r0.apk", "ae2ef558edd6105bf6e4a30c34320de525e2fdf045c234fbd3d903bb1a50688c", 723880, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["ffmpegthumbnailer", "ffmpegthumbnailer-2.2.4-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/ffmpegthumbnailer-2.2.4-r0.apk", "aecc4c323c340dc2ea32347c29489e13de0a011bbe871144842a4b7e96b79df8", 86167, "GPL-2.0-or-later", false],
    ["glslang-libs", "glslang-libs-1.4.341.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/glslang-libs-1.4.341.0-r0.apk", "a2c7450ac81c486d333c3a40072912a6a1dac9cc8a26136f48c7f1ae35d27257", 779435, "BSD-3-Clause AND BSD-2-Clause AND MIT AND Apache-2.0 AND GPL-3.0-or-later", false],
    ["libdovi", "libdovi-3.3.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libdovi-3.3.2-r0.apk", "3e1405d1da7bde37ae5672fc7e12b8bbf36357dd25b62ec6863a23535693e4fb", 214926, "MIT", false],
    ["libopenmpt", "libopenmpt-0.8.10-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libopenmpt-0.8.10-r0.apk", "77b18055ea24127458c647b8a9aa9480bdeb4dd2b8daf9fdc87a9ef18fcd41a8", 659311, "BSD-3-Clause", false],
    ["libplacebo", "libplacebo-7.360.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libplacebo-7.360.1-r0.apk", "fbd0f174d5e56b22b6bd7b335519b7eb7a32bf25e2c66baec38e8d57d40f541a", 464485, "LGPL-2.1-or-later", false],
    ["librist", "librist-0.2.15-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/librist-0.2.15-r0.apk", "11d25fc6691b34002c8d3b65c8a0587660c3cbc5d843424c80196583edf8b80d", 72240, "BSD-2-Clause", false],
    ["libsodium", "libsodium-1.0.22-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libsodium-1.0.22-r0.apk", "9104e01a043d92f1f646e5750a6ba9d8a030f4d87f6c5690e8a015f0d9a4ab73", 199175, "ISC", false],
    ["libssh", "libssh-0.12.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libssh-0.12.2-r0.apk", "ad36fea448d82f3ed08fcd8eefeabb60f56ef94d1c8c66e1282443521fe72d01", 206002, "LGPL-2.1-or-later BSD-2-Clause", false],
    ["libzmq", "libzmq-4.3.5-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libzmq-4.3.5-r2.apk", "6bdc93b3ca98fea14a1fb29c6874fc8c460096d03b956f92632cbad58cdf444d", 261408, "MPL-2.0", false],
    ["lilv-libs", "lilv-libs-0.24.26-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lilv-libs-0.24.26-r1.apk", "f3b94634be78ac1f559d2931c3a5cf1980d1721cf21dae79068c861dc9a907f7", 35855, "ISC", false],
    ["mbedtls3", "mbedtls3-3.6.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/mbedtls3-3.6.7-r0.apk", "d4ac9dec9efd61bb7cc72929eaf944279439068b0b07c7d2167bfab98dce9273", 413074, "Apache-2.0 OR GPL-2.0-or-later", false],
    ["serd-libs", "serd-libs-0.32.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/serd-libs-0.32.8-r0.apk", "b26dd784ba24cb00acec0b850989dedd95ce47ca35abdb6c62e65b8fa612dae3", 30370, "ISC", false],
    ["shaderc", "shaderc-2026.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/shaderc-2026.1-r0.apk", "8ffad05b20d790ea5b09f0d103376daea80941fffc020d698712179beab558dc", 90769, "Apache-2.0", false],
    ["sord-libs", "sord-libs-0.16.22-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sord-libs-0.16.22-r0.apk", "2ab4e710b606ac2514ab4a886dbe3b6191e493c6c71f9db61788531b6fb9380a", 11982, "ISC", false],
    ["sratom", "sratom-0.6.20-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sratom-0.6.20-r0.apk", "cf27a7eead059a191f6a511a2287fadaf83981386b02cb2049f3cb491b4f68aa", 12309, "ISC", false],
    ["vidstab", "vidstab-1.1.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/vidstab-1.1.1-r0.apk", "810859baf5ba90b6012941a321025009fd2f45aaa45141ad682f57967e04fdec", 33373, "GPL-2.0-or-later", false],
    ["zimg", "zimg-3.0.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/zimg-3.0.6-r0.apk", "e3ca9fe60ce24910956c2372ab92550daa41b9d8e8fb72ec9fbf108c6d83671b", 225722, "WTFPL", false],
    ["zix-libs", "zix-libs-0.8.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/zix-libs-0.8.0-r0.apk", "3467af7fcaad89aeef62ed9d21a5e5b837465c02e685f4c006e939cdbfa382d9", 21037, "ISC", false],
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
