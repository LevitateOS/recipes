// lib32: a Recipe group, installed into the system root (`recipe --system install lib32`)
// with a receipt, so it can be removed or replaced like any other recipe. It holds
// the 32-bit (i686) libraries that 32-bit programs and Steam's runtime load on
// LevitateOS's 64-bit Fedora userland, and the 64-bit builds of the same libraries
// that the system does not already have. Nothing in the OS images is 32-bit, so
// the i686 packages are in no lock: they are taken from Fedora 45's own
// repositories (the x86_64 repositories carry the i686 multilib builds).
//
// Hand-written: ABOUT, the seeds (SEEDS_GLIBC for the 64-bit builds, SEEDS_I686
// for the 32-bit ones) and the groups it needs (deps). Generated: the two pin
// blocks, `version` and `network_max_bytes`, written by
// `cargo xtask base groups levitate`. The 64-bit packages come from the locks
// like every group's; the i686 ones from Fedora's repositories, each at the
// version of its locked x86_64 twin (the two share their non-library files,
// which must be identical). When a twin has moved on, the generator says so and
// the locks need `cargo xtask base lock levitate`. AcornOS (musl) has no 32-bit
// glibc and gets no build: ABOUT.libc and ABOUT.systems say so, and no musl
// seeds exist.
//
// Where each library comes from (2026-11-15):
// - F: Fedora's own Steam package, RPM Fusion nonfree `steam` 1.0.0.87-4
//   (https://github.com/rpmfusion/steam/blob/master/steam.spec): its
//   `Requires: NAME(x86-32)` lines, and their 64-bit counterparts.
// - V: Valve's own Debian control file in the Steam launcher 1.0.0.87
//   (steam-launcher/debian/control, `steam-libs-i386`: Depends and Recommends),
//   with Debian names mapped to Fedora's.
// - W: the Wayland client library 32-bit SDL and games load (asked for
//   explicitly; SDL3 needs it too).
// What these libraries need beyond them (LLVM for Mesa, NSPR, libffi, ...) the
// generator adds from the packages' own requires.
const RECIPE_API = 3;
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443"],
    network_max_bytes: 1048576,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "library",
    libc: ["glibc"],
    systems: ["levitateos"],
    details: "The 32-bit (i686) libraries 32-bit programs and Steam's runtime load on LevitateOS: the 32-bit C library and its loader, the C++ and GCC runtimes, Mesa's OpenGL, EGL and Vulkan drivers with the GL dispatch and Vulkan loader, VA-API and VDPAU, X11 and Wayland client libraries, PipeWire, PulseAudio and ALSA clients, OpenAL, SDL3, NSS and NetworkManager's client library, all from Fedora 45 at the versions of the system's own 64-bit builds. It also brings the 64-bit builds of the few of these libraries the system lacks. 32-bit programs and directories only: the 64-bit system already has the configuration, data and commands these packages share with their 64-bit builds, so those parts are left out. NVIDIA's proprietary driver is not here; its 32-bit libraries come with that driver.",
    homepage: "https://fedoraproject.org/wiki/Multilib",
    license: "LGPL-2.1-or-later AND GPL-2.0-or-later AND MIT AND BSD-3-Clause AND MPL-2.0",
    steps: #{
        acquire: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        build: "Unpacks the packages natively into one system tree, without running their scripts, keeping only the 32-bit libraries of the i686 packages.",
        install: "Publishes the system tree for Recipe to write into the system root, with a receipt.",
    },
    keeps: [],
};

// What this group installs, by name; the generator adds what they need.
// LevitateOS (glibc, Fedora 45): the 64-bit builds of the libraries below
// that the system lacks (F requires both builds of each). `base lock` locks
// them with the other groups' seeds.
const SEEDS_GLIBC = [
    "libatomic", "libnsl", "openal-soft", "libXScrnSaver"
];
// AcornOS (musl): no 32-bit glibc there.
const SEEDS_MUSL = [];
// The 32-bit builds, by package name: no lock holds an i686 build, so the
// generator takes them from Fedora 45's repositories, each at the version of
// its locked x86_64 build. Letters are the sources above.
const SEEDS_I686 = [
    // C library and loader, compiler runtimes (F glibc libatomic libnsl; V libc6 libgcc-s1 libstdc++6 libcrypt1)
    "glibc", "libgcc", "libstdc++", "libatomic", "libxcrypt", "libnsl",
    // System libraries (F bzip2-libs; V libudev1 libgpg-error0)
    "bzip2-libs", "systemd-libs", "libgpg-error",
    // OpenGL, EGL, GBM and the DRI drivers (F libglvnd-glx mesa-libGL mesa-libEGL mesa-dri-drivers libdrm; V libgl1 libegl1 libgbm1 libgl1-mesa-dri)
    "libglvnd-glx", "libglvnd-egl", "mesa-libGL", "mesa-libEGL", "mesa-libgbm", "mesa-dri-drivers", "libdrm",
    // Vulkan: Mesa's drivers and the loader (F mesa-vulkan-drivers vulkan-loader; V mesa-vulkan-drivers)
    "mesa-vulkan-drivers", "vulkan-loader",
    // Video decoding (F libva libvdpau; V libva2. V's va-driver-all has no
    // Fedora 45 i686 package of its own: mesa-va-drivers does not exist there,
    // as on x86_64, where no lock has it either)
    "libva", "libvdpau",
    // X11 and Wayland clients (F libXext libXinerama libXtst libICE; V libx11-6 libxcb1 libxcb-dri3-0 libxss1 libxkbcommon-x11-0; W)
    "libX11", "libxcb", "libXext", "libXinerama", "libXtst", "libICE", "libXScrnSaver", "libxkbcommon-x11",
    "libwayland-client",
    // Fonts (F fontconfig; V libfontconfig1)
    "fontconfig",
    // Sound: PipeWire, PulseAudio and ALSA clients, OpenAL, SDL3 (F pipewire-libs pulseaudio-libs openal-soft SDL3; V libasound2-plugins, here PipeWire's ALSA plug-in)
    "pipewire-libs", "pulseaudio-libs", "alsa-lib", "pipewire-alsa", "openal-soft", "SDL3",
    // Network: NSS and NetworkManager's client library (F nss NetworkManager-libnm; V libnss3 libnm0)
    "nss", "NetworkManager-libnm"
];
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs"];

let ctx = #{
    name: "lib32",
    version: "2026.11.10",
    description: "32-bit libraries for 32-bit programs and Steam",
};

// BEGIN GENERATED PINS glibc
// Not generated yet: run `cargo xtask base groups levitate`.
const RPM_PINNED_ON = "";
const RPM_PINNED_BYTES = 0;
const RPM_PINS = [];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// No musl build: this recipe names no seeds in SEEDS_MUSL. Written by
// `cargo xtask base groups acorn`; do not edit.
const APK_PINNED_ON = "";
const APK_PINNED_BYTES = 0;
const APK_PINS = [];
// END GENERATED PINS musl

// The rest is the same in every group recipe, except build(), which keeps
// only the 32-bit libraries of the i686 packages (see thin_i686).
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
ctx.no_build = ctx.name + " has pins for glibc (Fedora RPMs, LevitateOS) only: 32-bit glibc libraries are " +
    "for a glibc system. This system's C library is " + ctx.libc + ". On a glibc system, " +
    "`cargo xtask base groups levitate` writes the pins from SEEDS_GLIBC and SEEDS_I686.";
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

// An i686 package carries its 32-bit libraries under usr/lib and, beside
// them, the same configuration, data, documentation and commands as its
// x86_64 build. The 64-bit system already has those (from the base, another
// group or this one's own x86_64 packages), and Recipe refuses a file the
// base owns or another receipt owns differently, as RPM's multilib rules
// would let the 64-bit file win. So from the i686 packages the tree keeps
// usr/lib (less the parts of it that are not per-architecture) and the
// Vulkan driver manifests, which are named per architecture
// (usr/share/vulkan/icd.d/*.i686.json).
const I686_KEEP_SHARE = ["vulkan"];
const I686_KEEP_VULKAN = ["icd.d"];
const I686_SHARED_IN_LIB = [
    ".build-id", "udev", "systemd", "sysusers.d", "tmpfiles.d", "environment.d", "modprobe.d",
    "modules-load.d", "sysctl.d", "binfmt.d", "rpm", "locale", "firmware", "fontconfig", "kernel",
    "dracut", "os-release", "debug"
];

fn keep_only(dir, keep) {
    if !is_dir(dir) { return; }
    for path in glob_list(join_path(dir, "*")) {
        if !(basename(path) in keep) { rm(path); }
    }
    for path in glob_list(join_path(dir, ".*")) {
        let name = basename(path);
        if name != "." && name != ".." && !(name in keep) { rm(path); }
    }
}

fn thin_i686(ctx) {
    let usr = join_path(ctx.system, "usr");
    keep_only(ctx.system, ["usr"]);
    keep_only(usr, ["lib", "share"]);
    keep_only(join_path(usr, "share"), I686_KEEP_SHARE);
    keep_only(join_path(usr, "share/vulkan"), I686_KEEP_VULKAN);
    for dir in I686_SHARED_IN_LIB {
        let path = join_path(usr, "lib/" + dir);
        if exists(path) { rm(path); }
    }
}

// Unpacks every package into one system tree, natively, without running any
// of its scripts: first the i686 packages, thinned to their 32-bit
// libraries (thin_i686), then the others. Paths a system package does not
// own (run-time data: run, tmp and the like) are left out. Under var/, only
// what a package needs and nothing at boot makes (pin[6]) is kept, as state
// seeds: created where missing, never owned or removed. Owners stay names,
// resolved in the root the group is written into.
fn build(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    if exists(ctx.record) { rm(ctx.record); }
    if exists(ctx.system) { rm(ctx.system); }
    mkdir(ctx.system);
    let done = 0;
    // i686 packages, then x86_64/noarch packages whose var/ is not kept, then
    // the var/ they left, then the packages whose var/ is kept.
    for pass in ["i686", "plain", "seeds"] {
        for pin in ctx.pins {
            let i686 = pin[1].ends_with(".i686.rpm");
            if (pass == "i686") != i686 { continue; }
            if pass != "i686" && pin[6] != (pass == "seeds") { continue; }
            progress(done, ctx.pins.len(), "packages");
            let archive = archive_of(ctx, pin);
            verify_sha256(archive, pin[3]);
            target_extract_rpm(archive, ctx.system);
            done += 1;
        }
        if pass == "i686" { thin_i686(ctx); }
        let state = join_path(ctx.system, "var");
        if pass == "plain" && exists(state) { rm(state); }
    }
    progress(done, ctx.pins.len(), "packages");
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
// This group's configuration (hand-written).
// ---------------------------------------------------------------------------

// This group adds no configuration of its own.
fn configure(ctx) { }
