const RECIPE_API = 1;
// lib32: a Recipe group, installed into the system root (`recipe --system install lib32`)
// with a receipt, so it can be removed or replaced like any other recipe. It holds
// the 32-bit (i686) libraries that 32-bit programs and Steam's runtime load on
// LevitateOS's 64-bit Fedora userland, and the 64-bit builds of the same libraries
// that the system does not already have. Nothing in the OS images is 32-bit, so
// the i686 packages are in no lock: they are taken from Fedora 45's own
// repositories (the x86_64 repositories carry the i686 multilib builds).
//
// Hand-written: ABOUT, the seeds (PACKAGES.glibc for the 64-bit builds,
// PACKAGES.glibc_i686 for the 32-bit ones) and the groups it needs (deps).
// Generated: lib32.pins beside this file (the pinned packages and the group's
// version), written by `cargo xtask base groups levitate`. The 64-bit packages
// come from the locks like every group's; the i686 ones from Fedora's
// repositories, each at the version of its locked x86_64 twin (the two share
// their non-library files, which must be identical). When a twin has moved on,
// the generator says so and the locks need `cargo xtask base lock levitate`.
// AcornOS (musl) has no 32-bit glibc and gets no build: ABOUT.libc and
// ABOUT.systems say so, and no musl seeds exist.
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
//
// Recipe downloads the pins (src.packages, in pin order); build unpacks them
// itself, because the i686 packages are thinned to their 32-bit libraries
// before the 64-bit ones go in. Recipe finishes the system tree afterwards.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "kojipkgs.fedoraproject.org:443"],
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
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        build: "Unpacks the packages natively into one system tree, without running their scripts, keeping only the 32-bit libraries of the i686 packages.",
        install: "Writes the system tree into the system root, with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "lib32", description: "32-bit libraries for 32-bit programs and Steam" };   // version: lib32.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (glibc, Fedora 45): the 64-bit builds of the libraries
// below that the system lacks (F requires both builds of each). `base lock`
// locks them with the other groups' seeds.
// glibc_i686: the 32-bit builds, by package name: no lock holds an i686
// build, so the generator takes them from Fedora 45's repositories, each at
// the version of its locked x86_64 build. Letters are the sources above.
// musl: none; AcornOS has no 32-bit glibc.
const PACKAGES = #{
    glibc: ["libatomic", "libnsl", "openal-soft", "libXScrnSaver"],
    glibc_i686: [
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
        "nss", "NetworkManager-libnm",
    ],
};

let deps = ["desktop-libs"];

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

fn thin_i686(tree) {
    let usr = join_path(tree, "usr");
    keep_only(tree, ["usr"]);
    keep_only(usr, ["lib", "share"]);
    keep_only(join_path(usr, "share"), I686_KEEP_SHARE);
    keep_only(join_path(usr, "share/vulkan"), I686_KEEP_VULKAN);
    for dir in I686_SHARED_IN_LIB {
        let path = join_path(usr, "lib/" + dir);
        if exists(path) { rm(path); }
    }
}

// Unpacks every package into the system tree, natively, without running any
// of its scripts: first the i686 packages (a `.i686.rpm` file), thinned to
// their 32-bit libraries (thin_i686), then the x86_64/noarch packages whose
// var/ is not kept, then the var/ they left is deleted, then the packages
// whose var/ is kept as state seeds (`pin.keep_var`). Recipe then removes the paths a system
// package does not own and finishes the tree (owners resolved in the root it
// is written into, var/ as state seeds).
fn build(src, out) {
    let total = src.packages.len();
    let done = 0;
    for pass in ["i686", "plain", "seeds"] {
        for pin in src.packages {
            let i686 = pin.path.ends_with(".i686.rpm");
            if (pass == "i686") != i686 { continue; }
            if pass != "i686" && pin.keep_var != (pass == "seeds") { continue; }
            progress(done, total, "packages");
            target_extract_rpm(pin.path, out);
            done += 1;
        }
        if pass == "i686" { thin_i686(out); }
        let state = join_path(out, "var");
        if pass == "plain" && exists(state) { rm(state); }
    }
    progress(done, total, "packages");
}
