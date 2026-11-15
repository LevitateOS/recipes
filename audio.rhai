// audio: a Recipe group, installed into the system root (`recipe --system install audio`)
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
    kind: "system",
    category: "media",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "PipeWire with WirePlumber as its session manager, and the PulseAudio and ALSA routes into it, so every program's sound plays.",
    homepage: "https://pipewire.org",
    license: "MIT AND LGPL-2.1-or-later",
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
    "pipewire", "pipewire-pulseaudio", "pipewire-alsa", "wireplumber"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "pipewire", "pipewire-pulse", "pipewire-alsa", "wireplumber"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [
    "g pipewire -"
];
let deps = ["desktop-libs"];

let ctx = #{
    name: "audio",
    version: "2026.11.15",
    description: "Sound: PipeWire and WirePlumber",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-15): 7 packages, 1309551 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-15";
const RPM_PINNED_BYTES = 1309551;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["pipewire", "pipewire-1.6.11-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pipewire-1.6.11-1.fc45.x86_64.rpm", "8d730d83a255acf8eb75a01eb4ab055be1a5d008c04aaf02bcff8c2acb57ddfc", 144993, "MIT", false],
    ["pipewire-alsa", "pipewire-alsa-1.6.11-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pipewire-alsa-1.6.11-1.fc45.x86_64.rpm", "31f2af216f90c04a7e7a2f87d5e8346597005c3aad6e7dc13c2b65bf36cf70b9", 65737, "MIT", false],
    ["pipewire-pulseaudio", "pipewire-pulseaudio-1.6.11-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pipewire-pulseaudio-1.6.11-1.fc45.x86_64.rpm", "970e0cdbc8d58a21a7c73ffde02b410b04d4cd20b09f10314046ed112297e2ca", 230387, "MIT", false],
    ["polkit", "polkit-127-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/polkit-127-5.fc45.x86_64.rpm", "c4a3f94ce1f1af0dcd1ebefe53e80e8ea70d007c5441a04dbfd3b589051bd6a1", 176338, "LGPL-2.0-or-later", false],
    ["rtkit", "rtkit-0.14-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/r/rtkit-0.14-2.fc45.x86_64.rpm", "fcf36d37a7b5f25d121d1ccf336fda293e12e1963b7eee660d35f14297224700", 59209, "GPL-3.0-or-later AND MIT", false],
    ["wireplumber", "wireplumber-0.5.19-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/w/wireplumber-0.5.19-1.fc45.x86_64.rpm", "f17e4dca2e0d864ca7852af2b1228ed5ebb0f62dcd96b854a1fc6bf8fe9b8ed9", 147746, "MIT", false],
    ["wireplumber-libs", "wireplumber-libs-0.5.19-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/w/wireplumber-libs-0.5.19-1.fc45.x86_64.rpm", "a72958a301be2424211a9b5a093e095a8be8aeb0757a76e8760e6f968f4747f1", 485141, "MIT", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-15): 23 packages, 3583892 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-15";
const APK_PINNED_BYTES = 3583892;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["alsa-ucm-conf", "alsa-ucm-conf-1.2.16.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/alsa-ucm-conf-1.2.16.1-r0.apk", "8b2cb4ec5e93d353c2b5687cf9064fceea6d3e02e4c89fe0522b81a4f4bb77da", 163785, "BSD-3-Clause", false],
    ["alsa-utils", "alsa-utils-1.2.15.2-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/alsa-utils-1.2.15.2-r1.apk", "783af2329ff281217460948e2f5ceed73ec20bc43fb5e7a8fd4d10b989a4fd90", 1221389, "GPL-2.0-or-later", true],
    ["alsa-utils-openrc", "alsa-utils-openrc-1.2.15.2-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/alsa-utils-openrc-1.2.15.2-r1.apk", "ca8a78b5a1c6a7fe439c93167430f84c1d393d962c3b5ae874ecc649af402ae9", 3096, "GPL-2.0-or-later", false],
    ["alsa-utils-udev", "alsa-utils-udev-1.2.15.2-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/alsa-utils-udev-1.2.15.2-r1.apk", "ec79b6d12be2bb089c2339784acc42d7d7777a11cf4ededce8dda4d1b5531983", 2254, "GPL-2.0-or-later", false],
    ["dialog", "dialog-1.3.20260107-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/dialog-1.3.20260107-r1.apk", "0a8e9c27e39eb0e5e7588c682a8c4b7da4a308a8004a1ece121d4632983a1cd5", 97327, "LGPL-2.1-only", false],
    ["fftw-single-libs", "fftw-single-libs-3.3.11-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/fftw-single-libs-3.3.11-r0.apk", "5982c6ef720e7cabfad3d56c7ab1b024db53be79e40f03d48e6e5ddbf5f2dc3a", 880814, "GPL-2.0-or-later", false],
    ["libformw", "libformw-6.6_p20260516-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libformw-6.6_p20260516-r0.apk", "3a1d3bf08911655e3c7674931887a78867d57065e8156c95d21f6fdf8ee37d1d", 27416, "X11", false],
    ["libmenuw", "libmenuw-6.6_p20260516-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libmenuw-6.6_p20260516-r0.apk", "6a73daf427999bc74516fb0a4b1a6b11096f67817d10a067ab00e7f5e517e7c4", 13852, "X11", false],
    ["lua5.4-libs", "lua5.4-libs-5.4.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/lua5.4-libs-5.4.8-r0.apk", "3a77aaf5c0d396e62faf67f5d5d190a06b3960c50ed8d531dad68557db638aa8", 104189, "MIT", false],
    ["pipewire", "pipewire-1.6.8-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pipewire-1.6.8-r4.apk", "9471ff8d149650a17d3242c5a789a4b3e38b838bd246a7048f93bdbe1429d19f", 93058, "MIT", false],
    ["pipewire-alsa", "pipewire-alsa-1.6.8-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pipewire-alsa-1.6.8-r4.apk", "0c023f08a73d99f65c4d9d5578f7c4c88bcf7cf8ca478ac48ca9192da88f3c2c", 64466, "MIT", false],
    ["pipewire-openrc", "pipewire-openrc-1.6.8-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pipewire-openrc-1.6.8-r4.apk", "3d7a5f1d68c81683dc522055fb5ce11bb16f1c1560ac75814dce57b23d8bb28f", 1825, "MIT", false],
    ["pipewire-pulse", "pipewire-pulse-1.6.8-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pipewire-pulse-1.6.8-r4.apk", "d48518b5cf4475d9d98c38d23186347ecf5575f786751608c9bb0c3966b1939c", 260248, "MIT", false],
    ["pipewire-pulse-openrc", "pipewire-pulse-openrc-1.6.8-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pipewire-pulse-openrc-1.6.8-r4.apk", "226895c3e2891531b81e743ea341990a041d0d6a59e1bf624637ab8a5ab8278d", 1812, "MIT", false],
    ["pipewire-udev", "pipewire-udev-1.6.8-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pipewire-udev-1.6.8-r4.apk", "3ecb52b701bd65b95dd803b04c7dfceeb086adf7f0c7fcc40c9b7bcaa9b7b86b", 4875, "MIT", false],
    ["pulseaudio-alsa", "pulseaudio-alsa-17.0-r7.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pulseaudio-alsa-17.0-r7.apk", "362ef5d416e0fd00cec7cb69c2c489b4bd18626b4301c4475e74f84adf1f1ac8", 132458, "LGPL-2.1-or-later", false],
    ["pulseaudio-bash-completion", "pulseaudio-bash-completion-17.0-r7.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pulseaudio-bash-completion-17.0-r7.apk", "45c1ba74fc07db3205c9231cd3695e51388b6154270043e8d6fee254ddae76e7", 4531, "LGPL-2.1-or-later", false],
    ["pulseaudio-openrc", "pulseaudio-openrc-17.0-r7.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pulseaudio-openrc-17.0-r7.apk", "cc658ac712e73895dd417a2125603eeb36f1c7fc9be9cad1e06a811498149cc0", 2957, "LGPL-2.1-or-later", false],
    ["pulseaudio-utils", "pulseaudio-utils-17.0-r7.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pulseaudio-utils-17.0-r7.apk", "6b9418636c0454fd26b680a2e361cc8581b5e38a940fe14a23e97b8267510924", 61384, "LGPL-2.1-or-later", false],
    ["pulseaudio-wireplumber", "pulseaudio-wireplumber-17.0-r7.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pulseaudio-wireplumber-17.0-r7.apk", "c81119dea8ae3013b3932a5c748d974bc97f8137cb1c0257f985749efe71b5fe", 1761, "LGPL-2.1-or-later", false],
    ["wireplumber", "wireplumber-0.5.15-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/wireplumber-0.5.15-r0.apk", "142aa91ad00a3c353882645acc12ec1320ec3bc59f06ec76f19fcaae2e096859", 267388, "LGPL-2.1-or-later", false],
    ["wireplumber-libs", "wireplumber-libs-0.5.15-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/wireplumber-libs-0.5.15-r0.apk", "922c8526dc3c0b6192de633e19afa924fe4a944b6e62dc3de6813fdc74cfd632", 171200, "LGPL-2.1-or-later", false],
    ["wireplumber-openrc", "wireplumber-openrc-0.5.15-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/wireplumber-openrc-0.5.15-r0.apk", "d6e10f8e35f9f4630f0db4ce0308f67e77862477f543d8c2874388c743500451", 1807, "LGPL-2.1-or-later", false],
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

// PipeWire and WirePlumber start with each user's session: on systemd as the
// user units their presets enable for every user (`systemctl --global
// enable`); OpenRC has no user services, and PipeWire starts from its XDG
// autostart entry.
fn configure(ctx) {
    if ctx.format != "rpm" { return; }
    let units = "/usr/lib/systemd/user/";
    for unit in ["pipewire.socket", "pipewire-pulse.socket", "wireplumber.service"] { tree_text(ctx, units.sub_string(1) + unit); }
    put_link(ctx, "etc/systemd/user/sockets.target.wants/pipewire.socket", units + "pipewire.socket");
    put_link(ctx, "etc/systemd/user/sockets.target.wants/pipewire-pulse.socket", units + "pipewire-pulse.socket");
    put_link(ctx, "etc/systemd/user/pipewire.service.wants/wireplumber.service", units + "wireplumber.service");
    put_link(ctx, "etc/systemd/user/pipewire-session-manager.service", units + "wireplumber.service");
}
