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
    network_max_bytes: 128974848,
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
    version: "2026.11.15",
    description: "32-bit libraries for 32-bit programs and Steam",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-15): 123 packages, 128140239 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-15";
const RPM_PINNED_BYTES = 128140239;
// 118 of them are i686 builds (SEEDS_I686), which no lock holds: those Fedora
// 45's release and updates repositories held when this was written, each
// at the version of its locked x86_64 twin.
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["NetworkManager-libnm.i686", "NetworkManager-libnm-1.58.1-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/NetworkManager-libnm-1.58.1-3.fc45.i686.rpm", "84e1f27617e01bb56894cb46b9c2fa0143c612b9f400983c8410d7ed1d7ee608", 2320688, "LGPL-2.1-or-later", false],
    ["SDL3.i686", "SDL3-3.4.20-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/s/SDL3-3.4.20-1.fc45.i686.rpm", "1fcbf94152b42dd71f9fed1578ac2870c86c3f865cffcfe1e3fd1a64878a8c8b", 1363615, "Zlib AND MIT AND Apache-2.0 AND (Apache-2.0 OR MIT)", false],
    ["abseil-cpp.i686", "abseil-cpp-20260526.0-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/abseil-cpp-20260526.0-3.fc45.i686.rpm", "98a85ddd1e5aed5faeace8d30259f51c76cfff49e68044d30b5cc57f999b7aa1", 902638, "Apache-2.0 AND LicenseRef-Fedora-Public-Domain", false],
    ["alsa-lib.i686", "alsa-lib-1.2.16.1-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/alsa-lib-1.2.16.1-2.fc45.i686.rpm", "e420cef9169122cf5d85f945700dd6500aba1e0cb37573597190b38491b7942d", 617411, "LGPL-2.1-or-later", false],
    ["avahi-libs.i686", "avahi-libs-0.9~rc2-9.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/avahi-libs-0.9~rc2-9.fc45.i686.rpm", "9be751fd74717eb0eab00ccc6b1805555549117920456e3f8e635c32172a2681", 79814, "LGPL-2.1-or-later AND LGPL-2.0-or-later AND BSD-2-Clause-Views AND MIT", false],
    ["bluez-libs.i686", "bluez-libs-5.88-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/b/bluez-libs-5.88-1.fc45.i686.rpm", "99c3e8e010978f339a259b4d9fd6678ed4d74a5d10d6ed5e111d56b6a2cd6259", 91516, "GPL-2.0-or-later", false],
    ["bzip2-libs.i686", "bzip2-libs-1.0.8-24.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/b/bzip2-libs-1.0.8-24.fc45.i686.rpm", "18a1caff06c84ae407615a7f98f2e7111d038895c6be6c29b6c417ce7457042e", 43899, "BSD-4-Clause", false],
    ["dbus-libs.i686", "dbus-libs-1.16.4-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/d/dbus-libs-1.16.4-2.fc45.i686.rpm", "8d3e87cb03f1f6a0c33388030f05d984e471081b649fecca72dc081e1bf11651", 171840, "(AFL-2.1 OR GPL-2.0-or-later) AND GPL-2.0-or-later", false],
    ["elfutils-libelf.i686", "elfutils-libelf-0.197-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/e/elfutils-libelf-0.197-1.fc45.i686.rpm", "c90ec7bc59c5da64283a010719a709d4a5f53c4e2f67f12627e4885b79792107", 277542, "GPL-2.0-or-later OR LGPL-3.0-or-later", false],
    ["expat.i686", "expat-2.9.0-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/e/expat-2.9.0-1.fc45.i686.rpm", "f38f383b136c709da6d04676d3922a4025130f9c9622986eac070079596b97b7", 145827, "MIT", false],
    ["fdk-aac-free.i686", "fdk-aac-free-2.0.3-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/fdk-aac-free-2.0.3-3.fc45.i686.rpm", "a60e31fd4d4c3b4eddd7703e028113322ac751e2ae55c259253ea0d16792e005", 349846, "FDK-AAC", false],
    ["fftw-libs-single.i686", "fftw-libs-single-3.3.10-18.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/fftw-libs-single-3.3.10-18.fc45.i686.rpm", "f674ba3d056c3edcc861a464b1ad029a04ad51a54390c7ba27d35859a06acd39", 610354, "GPL-2.0-or-later AND MIT AND BSD-2-Clause", false],
    ["flac-libs.i686", "flac-libs-1.5.0-9.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/flac-libs-1.5.0-9.fc45.i686.rpm", "09bd2d72f4c2cb57de47f0a83386a51720c2b829aead7177c4c0855d655f1ef5", 245681, "BSD-3-Clause AND GPL-2.0-or-later AND GFDL-1.3-or-later", false],
    ["fmt", "fmt-12.1.0-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/fmt-12.1.0-3.fc45.x86_64.rpm", "5cec777876d0f73651be6a382e239016a74ccfcba41d067dc8b2787ba8c8dd57", 113129, "MIT", false],
    ["fmt.i686", "fmt-12.1.0-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/fmt-12.1.0-3.fc45.i686.rpm", "8aca39c4da11329eb87d127eccb7ba5eb3904bd7c2c4d690b8d3bc3db10689b8", 116289, "MIT", false],
    ["fontconfig.i686", "fontconfig-2.18.3-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/fontconfig-2.18.3-2.fc45.i686.rpm", "2c8e1e69b3efbb1d1e5f72a3b0e71d22f7e93c3f0e27fa5eb1bdb483c360e452", 396133, "HPND AND LicenseRef-Fedora-Public-Domain AND Unicode-DFS-2016", false],
    ["freetype.i686", "freetype-2.14.3-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/f/freetype-2.14.3-3.fc45.i686.rpm", "573f184caa403e704511bcd6dfe48eb7fc7dae9923c302eb724e907ed50c74dd", 465943, "(FTL OR GPL-2.0-or-later) AND BSD-3-Clause AND MIT AND MIT-Modern-Variant AND LicenseRef-Fedora-Public-Domain AND Zlib", false],
    ["glib2.i686", "glib2-2.90.1-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/glib2-2.90.1-1.fc45.i686.rpm", "f691270769f466ff0d52e8bc1c5d9f600de2da0621a9d03f6acac53c19dc03cd", 3464594, "LGPL-2.1-or-later", false],
    ["glibc.i686", "glibc-2.44-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/glibc-2.44-2.fc45.i686.rpm", "75f89429fe1d89d72cc4e44fcdc701e489ee699f44a733760308fd59d472a3e7", 2394268, "LGPL-2.1-or-later AND SunPro AND LGPL-2.1-or-later WITH GCC-exception-2.0 AND BSD-3-Clause AND GPL-2.0-or-later AND LGPL-2.1-or-later WITH GNU-compiler-exception AND GPL-2.0-only AND ISC AND LicenseRef-Fedora-Public-Domain AND HPND AND CMU-Mach AND LGPL-2.0-or-later AND Unicode-3.0 AND GFDL-1.1-or-later AND GPL-1.0-or-later AND FSFUL AND MIT AND Inner-Net-2.0 AND X11 AND GPL-2.0-or-later WITH GCC-exception-2.0 AND GFDL-1.3-only AND GFDL-1.1-only AND GPL-3.0-or-later AND GPL-3.0-or-later WITH Autoconf-exception-generic-3.0 AND GPL-3.0-or-later WITH Texinfo-exception", false],
    ["gmp.i686", "gmp-6.3.0-6.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gmp-6.3.0-6.fc45.i686.rpm", "c1f9e2927df3cf7db5d95d6097eb4c8f3d0c24cf2e6d27174bddd64d8baf8d2e", 322179, "(LGPL-3.0-or-later OR GPL-2.0-or-later OR (LGPL-3.0-or-later AND GPL-2.0-or-later)) AND GFDL-1.3-invariants-or-later", false],
    ["gnutls.i686", "gnutls-3.8.13-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gnutls-3.8.13-3.fc45.i686.rpm", "941c2d81c5743d95eb72f3f7abd8cae079127795d07f1eed6a7197bbd1d6171c", 1479630, "GPL-3.0-or-later AND LGPL-2.1-or-later", false],
    ["graphite2.i686", "graphite2-1.3.14-22.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/graphite2-1.3.14-22.fc45.i686.rpm", "3b1ccc4ae8c15258c0897ae7b8149f397d10e555939398894da05e2dafd992c5", 97052, "LGPL-2.1-or-later OR MPL-2.0 OR GPL-2.0-or-later", false],
    ["gsm.i686", "gsm-1.0.24-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gsm-1.0.24-3.fc45.i686.rpm", "5ff2e3d4a15bbdc80ff748dd74dac46f0533eead34ff76abbfa8ab98cc21fd05", 37166, "tu-berlin-2.0", false],
    ["harfbuzz.i686", "harfbuzz-15.0.0-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/h/harfbuzz-15.0.0-2.fc45.i686.rpm", "829d1f0fa06df7177b2ae6ad47cc508e6945a2b2130d57b4ceb2ce44705e9ac9", 1419116, "MIT-Modern-Variant", false],
    ["jbigkit-libs.i686", "jbigkit-libs-2.1-34.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/j/jbigkit-libs-2.1-34.fc45.i686.rpm", "71413adb9812b38534078862e7e7a59d9c28a63f31724aca2d87ac5b7d2df007", 55531, "GPL-2.0-or-later", false],
    ["lame-libs.i686", "lame-libs-4.0-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/lame-libs-4.0-1.fc45.i686.rpm", "273549fb36bac5c6706096b2619a6960006526adfb378798cfcae15c42f11ee4", 289363, "LGPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["libICE.i686", "libICE-1.1.2-5.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libICE-1.1.2-5.fc45.i686.rpm", "8203cb03110c72108fafdb2dc76d534027a2a705460f22cc726a1fc47a851684", 83676, "MIT-open-group", false],
    ["libX11-xcb.i686", "libX11-xcb-1.8.13-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libX11-xcb-1.8.13-3.fc45.i686.rpm", "4a041e66e9049df7efeaedeb68c96e1f1771bd920027047ab945ff77b4e989e1", 10978, "MIT AND X11", false],
    ["libX11.i686", "libX11-1.8.13-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libX11-1.8.13-3.fc45.i686.rpm", "61297b577e9df3d94ae1ce26dcf8eb2a88468f9d4f9321262b05f425da39f53f", 718926, "MIT AND X11", false],
    ["libXScrnSaver", "libXScrnSaver-1.2.5-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXScrnSaver-1.2.5-2.fc45.x86_64.rpm", "d44beb03c706b5327a622527860cc30d2fb6657df178fff3bf9a76459e5907ee", 25708, "X11", false],
    ["libXScrnSaver.i686", "libXScrnSaver-1.2.5-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXScrnSaver-1.2.5-2.fc45.i686.rpm", "0a74490dba0fc3388e6bbbc39ae42a3598ff5fd3185bf2e69dd033eca04d25fd", 26229, "X11", false],
    ["libXau.i686", "libXau-1.0.12-5.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXau-1.0.12-5.fc45.i686.rpm", "29c0a9303abbfcc12ee8433aa99852e1b99b7f051988ab109f61ed1b7b84a249", 34685, "MIT-open-group", false],
    ["libXext.i686", "libXext-1.3.6-6.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXext-1.3.6-6.fc45.i686.rpm", "d8310f2fb9f4eae605273d57f7ccf6da9c2e69f1a60e8bc04b6d4b358eba96bd", 44607, "MIT-open-group AND X11 AND HPND AND HPND-sell-variant AND SMLNJ AND MIT AND ISC AND HPND-doc AND HPND-doc-sell", false],
    ["libXfixes.i686", "libXfixes-6.0.1-8.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXfixes-6.0.1-8.fc45.i686.rpm", "2c701dc1fbff4a1f701f960a5d93904896201d47842093bcda4005f1dc2486b3", 20331, "MIT AND HPND-sell-variant", false],
    ["libXi.i686", "libXi-1.8.4-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libXi-1.8.4-1.fc45.i686.rpm", "bbfc4444d4ba6119254c32ce2e7379a1060ece612b87261931b0bcd7b5228771", 44917, "MIT-open-group AND SMLNJ AND MIT", false],
    ["libXinerama.i686", "libXinerama-1.1.5-11.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXinerama-1.1.5-11.fc45.i686.rpm", "2d5bb56b721130eca4153f3e1dee921d55b347625bdc9af2fdeb9964935f89a8", 14734, "MIT AND MIT-open-group AND X11", false],
    ["libXtst.i686", "libXtst-1.2.5-5.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXtst-1.2.5-5.fc45.i686.rpm", "5c51c500ac021927b8ea67f473447fcfd261e5158a76051f6fb39d24238d1bfa", 22087, "MIT-open-group AND HPND-sell-variant AND X11 AND HPND-doc AND HPND-doc-sell", false],
    ["libXxf86vm.i686", "libXxf86vm-1.1.6-5.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXxf86vm-1.1.6-5.fc45.i686.rpm", "88a43c218555bada1f45bc2e0d2368776d625409bbce566f83b8b890e7eead7c", 19457, "X11-distribute-modifications-variant", false],
    ["libasyncns.i686", "libasyncns-0.8-35.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libasyncns-0.8-35.fc45.i686.rpm", "92e24f01a5074a0f219925507ea04ffce9aca664d4e55c56129749e087cb2ef5", 31210, "LGPL-2.1-or-later", false],
    ["libatomic", "libatomic-16.2.1-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libatomic-16.2.1-3.fc45.x86_64.rpm", "64d2ee40ee5adebde915d36e9d4a17f1ddb93a638e52b38ff060235191fd3155", 60332, "GPL-3.0-or-later AND LGPL-3.0-or-later AND (GPL-3.0-or-later WITH GCC-exception-3.1) AND (GPL-3.0-or-later WITH Texinfo-exception) AND (LGPL-2.1-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GNU-compiler-exception) AND BSL-1.0 AND GFDL-1.3-or-later AND Linux-man-pages-copyleft-2-para AND SunPro AND BSD-1-Clause AND BSD-2-Clause AND BSD-2-Clause-Views AND BSD-3-Clause AND BSD-4-Clause AND BSD-Source-Code AND Zlib AND MIT AND Apache-2.0 AND (Apache-2.0 WITH LLVM-Exception) AND ZPL-2.1 AND ISC AND LicenseRef-Fedora-Public-Domain AND HP-1986 AND curl AND Martin-Birgmeier AND HPND-Markus-Kuhn AND dtoa AND SMLNJ AND AMD-newlib AND OAR AND HPND-merchantability-variant AND HPND-Intel", false],
    ["libatomic.i686", "libatomic-16.2.1-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libatomic-16.2.1-3.fc45.i686.rpm", "9e002c288e7285f000ad8e89b602977bd2a1f113a367aaedd29f6d234f9a9df0", 57521, "GPL-3.0-or-later AND LGPL-3.0-or-later AND (GPL-3.0-or-later WITH GCC-exception-3.1) AND (GPL-3.0-or-later WITH Texinfo-exception) AND (LGPL-2.1-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GNU-compiler-exception) AND BSL-1.0 AND GFDL-1.3-or-later AND Linux-man-pages-copyleft-2-para AND SunPro AND BSD-1-Clause AND BSD-2-Clause AND BSD-2-Clause-Views AND BSD-3-Clause AND BSD-4-Clause AND BSD-Source-Code AND Zlib AND MIT AND Apache-2.0 AND (Apache-2.0 WITH LLVM-Exception) AND ZPL-2.1 AND ISC AND LicenseRef-Fedora-Public-Domain AND HP-1986 AND curl AND Martin-Birgmeier AND HPND-Markus-Kuhn AND dtoa AND SMLNJ AND AMD-newlib AND OAR AND HPND-merchantability-variant AND HPND-Intel", false],
    ["libblkid.i686", "libblkid-2.42.4-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblkid-2.42.4-1.fc45.i686.rpm", "4d006e2cf65f2c45f60f06a3cf580ac50fe9638a402c3518ccb4a1347f2477b1", 150161, "LGPL-2.1-or-later", false],
    ["libbrotli.i686", "libbrotli-1.2.1-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libbrotli-1.2.1-1.fc45.i686.rpm", "2576e441fe3dd20a72e81ad1e45524c9ea0307cbac0ae4d0d793e382094ad1f5", 347498, "MIT", false],
    ["libdisplay-info.i686", "libdisplay-info-0.3.0-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdisplay-info-0.3.0-2.fc45.i686.rpm", "d53ee7de09a8e905f57adec4a1f056ed69d7e1db7846716920a93e0024930fab", 91457, "MIT", false],
    ["libdrm.i686", "libdrm-2.4.134-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdrm-2.4.134-2.fc45.i686.rpm", "7c703f196b1d4977192c1d31580a597635f60ee01f6c853e67a3131d1ea65b0d", 184473, "MIT", false],
    ["libebur128.i686", "libebur128-1.2.6-16.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libebur128-1.2.6-16.fc45.i686.rpm", "1983d01228225a1614929755299b76f3d15d7d584b7a4705485434f5ee96cc39", 27006, "MIT", false],
    ["libedit.i686", "libedit-3.1-60.20260512cvs.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libedit-3.1-60.20260512cvs.fc45.i686.rpm", "e05600678cae13e3d35b9195059d373c67d1474547212a386dc788b285ee8fbd", 117843, "BSD-3-Clause AND BSD-2-Clause AND ISC", false],
    ["libevent.i686", "libevent-2.1.13-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libevent-2.1.13-1.fc45.i686.rpm", "f85298565426c5b3382a8e8c8bb079a2431c73de6174fdb2a18495f411b99b34", 313424, "BSD-3-Clause AND ISC AND LicenseRef-Fedora-Public-Domain", false],
    ["libffi.i686", "libffi-3.5.2-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libffi-3.5.2-3.fc45.i686.rpm", "8e804f9610a4b0a3370c0676c551b39e1af9651ae6d34f4d31c31428e1f0a86a", 40492, "MIT AND CC-PDDC AND (GPL-3.0-or-later WITH Texinfo-exception)", false],
    ["libgcc.i686", "libgcc-16.2.1-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libgcc-16.2.1-3.fc45.i686.rpm", "44d7adbb3ac3508ad3b7f57207f95642c235262806f0a7d0d7b212855959b6d6", 159183, "GPL-3.0-or-later AND LGPL-3.0-or-later AND (GPL-3.0-or-later WITH GCC-exception-3.1) AND (GPL-3.0-or-later WITH Texinfo-exception) AND (LGPL-2.1-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GNU-compiler-exception) AND BSL-1.0 AND GFDL-1.3-or-later AND Linux-man-pages-copyleft-2-para AND SunPro AND BSD-1-Clause AND BSD-2-Clause AND BSD-2-Clause-Views AND BSD-3-Clause AND BSD-4-Clause AND BSD-Source-Code AND Zlib AND MIT AND Apache-2.0 AND (Apache-2.0 WITH LLVM-Exception) AND ZPL-2.1 AND ISC AND LicenseRef-Fedora-Public-Domain AND HP-1986 AND curl AND Martin-Birgmeier AND HPND-Markus-Kuhn AND dtoa AND SMLNJ AND AMD-newlib AND OAR AND HPND-merchantability-variant AND HPND-Intel", false],
    ["libglvnd-egl.i686", "libglvnd-egl-1.7.0-10.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libglvnd-egl-1.7.0-10.fc45.i686.rpm", "867690f4b3164030d7fa61ee747df8fa31aba412610581cd3b523056007a70da", 38302, "MIT-feh AND MIT-Modern-Variant AND BSD-1-Clause AND BSD-3-Clause AND GPL-3.0-or-later WITH Autoconf-exception-macro", false],
    ["libglvnd-glx.i686", "libglvnd-glx-1.7.0-10.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libglvnd-glx-1.7.0-10.fc45.i686.rpm", "42979031d4ceb01c7f1ead6c89b1dba1882383469e4c7dc062f58a456c2b8ddb", 135424, "MIT-feh AND MIT-Modern-Variant AND BSD-1-Clause AND BSD-3-Clause AND GPL-3.0-or-later WITH Autoconf-exception-macro", false],
    ["libglvnd.i686", "libglvnd-1.7.0-10.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libglvnd-1.7.0-10.fc45.i686.rpm", "48ab4bccdcfb223a12d1985e486bbc49299f29f83dc808451a71e368bdb492b9", 116325, "MIT-feh AND MIT-Modern-Variant AND BSD-1-Clause AND BSD-3-Clause AND GPL-3.0-or-later WITH Autoconf-exception-macro", false],
    ["libgomp.i686", "libgomp-16.2.1-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libgomp-16.2.1-3.fc45.i686.rpm", "b5a65c38b550633ab82223deb939bdccc5b57f5c7b5b13142822fdf421fd78b1", 413755, "GPL-3.0-or-later AND LGPL-3.0-or-later AND (GPL-3.0-or-later WITH GCC-exception-3.1) AND (GPL-3.0-or-later WITH Texinfo-exception) AND (LGPL-2.1-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GNU-compiler-exception) AND BSL-1.0 AND GFDL-1.3-or-later AND Linux-man-pages-copyleft-2-para AND SunPro AND BSD-1-Clause AND BSD-2-Clause AND BSD-2-Clause-Views AND BSD-3-Clause AND BSD-4-Clause AND BSD-Source-Code AND Zlib AND MIT AND Apache-2.0 AND (Apache-2.0 WITH LLVM-Exception) AND ZPL-2.1 AND ISC AND LicenseRef-Fedora-Public-Domain AND HP-1986 AND curl AND Martin-Birgmeier AND HPND-Markus-Kuhn AND dtoa AND SMLNJ AND AMD-newlib AND OAR AND HPND-merchantability-variant AND HPND-Intel", false],
    ["libgpg-error.i686", "libgpg-error-1.61-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libgpg-error-1.61-2.fc45.i686.rpm", "758369dd2e056f475e056d7c2a13b5d1d2fb522a8b69f6e75ea5aba357155a0a", 262781, "LGPL-2.1-or-later AND (BSD-3-Clause OR LGPL-2.1-or-later) AND FSFULLR AND GPL-2.0-or-later", false],
    ["libidn2.i686", "libidn2-2.3.8-4.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libidn2-2.3.8-4.fc45.i686.rpm", "b898e295cccb3405eaa0a2f97c53c82c3dea18f7c5ccdf2f8f308420562a0a05", 180688, "(GPL-2.0-or-later OR LGPL-3.0-or-later) AND GPL-3.0-or-later", false],
    ["libjpeg-turbo.i686", "libjpeg-turbo-3.1.4.1-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libjpeg-turbo-3.1.4.1-2.fc45.i686.rpm", "2f5b427e121577b882e1c9a705ced36f75a7e05e0a8f24c6fd050aea17ec82a4", 280427, "Zlib AND BSD-3-Clause AND MIT AND IJG", false],
    ["liblc3.i686", "liblc3-1.1.3-9.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/liblc3-1.1.3-9.fc45.i686.rpm", "531e1ad3269cee16ae34d7b7c0a4724e7526aeaf862c09c2657bb3eac9c94302", 109695, "Apache-2.0", false],
    ["libldac.i686", "libldac-2.0.2.6-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libldac-2.0.2.6-1.fc45.i686.rpm", "b2b2cfe51d442ebec9a5da3d95bb3511d3bdbc18f466cee5cc34dc501e0b7e29", 44825, "Apache-2.0", false],
    ["liblerc.i686", "liblerc-4.3.0-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/liblerc-4.3.0-1.fc45.i686.rpm", "5dc93b3e1e300aad0d53144f01d9c61a82ecaa08c05f672128b1e77ae226fd7b", 248070, "Apache-2.0", false],
    ["libmount.i686", "libmount-2.42.4-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libmount-2.42.4-1.fc45.i686.rpm", "a3b8479cdc814c3cf2503020ede4fd946bd37d6d23c83f4b285a56be193a05b6", 192188, "LGPL-2.1-or-later", false],
    ["libnsl", "libnsl-2.44-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libnsl-2.44-2.fc45.x86_64.rpm", "a9ef7bda818dee2c519f6d4ab85924a2c86ff4854b6da83b5472f38d7f748528", 170965, "LGPL-2.1-or-later AND SunPro AND LGPL-2.1-or-later WITH GCC-exception-2.0 AND BSD-3-Clause AND GPL-2.0-or-later AND LGPL-2.1-or-later WITH GNU-compiler-exception AND GPL-2.0-only AND ISC AND LicenseRef-Fedora-Public-Domain AND HPND AND CMU-Mach AND LGPL-2.0-or-later AND Unicode-3.0 AND GFDL-1.1-or-later AND GPL-1.0-or-later AND FSFUL AND MIT AND Inner-Net-2.0 AND X11 AND GPL-2.0-or-later WITH GCC-exception-2.0 AND GFDL-1.3-only AND GFDL-1.1-only AND GPL-3.0-or-later AND GPL-3.0-or-later WITH Autoconf-exception-generic-3.0 AND GPL-3.0-or-later WITH Texinfo-exception", false],
    ["libnsl.i686", "libnsl-2.44-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libnsl-2.44-2.fc45.i686.rpm", "570981be2e213639d3415ae18b47416569e3bc2f60df8d9082aed35a5424c5cf", 173929, "LGPL-2.1-or-later AND SunPro AND LGPL-2.1-or-later WITH GCC-exception-2.0 AND BSD-3-Clause AND GPL-2.0-or-later AND LGPL-2.1-or-later WITH GNU-compiler-exception AND GPL-2.0-only AND ISC AND LicenseRef-Fedora-Public-Domain AND HPND AND CMU-Mach AND LGPL-2.0-or-later AND Unicode-3.0 AND GFDL-1.1-or-later AND GPL-1.0-or-later AND FSFUL AND MIT AND Inner-Net-2.0 AND X11 AND GPL-2.0-or-later WITH GCC-exception-2.0 AND GFDL-1.3-only AND GFDL-1.1-only AND GPL-3.0-or-later AND GPL-3.0-or-later WITH Autoconf-exception-generic-3.0 AND GPL-3.0-or-later WITH Texinfo-exception", false],
    ["libogg.i686", "libogg-1.3.6-4.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libogg-1.3.6-4.fc45.i686.rpm", "e0a376ab623e1a004ae563b9b93d37d9ea9e8281bed9ebba781586812b8db7fd", 35689, "BSD-3-Clause", false],
    ["libpciaccess.i686", "libpciaccess-0.16-18.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libpciaccess-0.16-18.fc45.i686.rpm", "2069ed681e7e70b07de4491d0af23d9d643636275c71eb7e9f362a0fd05abf25", 30499, "HPND AND MIT", false],
    ["libpng.i686", "libpng-1.6.59-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libpng-1.6.59-1.fc45.i686.rpm", "82248dc12b119371d849c6b13d220e0f5bc0bc899cc50ea85771e30f6b59b9e0", 140177, "zlib", false],
    ["libsbc.i686", "libsbc-2.2-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libsbc-2.2-1.fc45.i686.rpm", "9075c26c84da6207a9836a0acf6a065c50d9b6b0e60607fa8f56dd9559ccf9a6", 47110, "GPL-2.0-only AND LGPL-2.1-or-later", false],
    ["libselinux.i686", "libselinux-3.11-5.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libselinux-3.11-5.fc45.i686.rpm", "23d73be5cf58957a4126d447c8246bb628577b797b6006af46597bf97928510c", 110962, "LicenseRef-Fedora-Public-Domain", false],
    ["libsepol.i686", "libsepol-3.11-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libsepol-3.11-2.fc45.i686.rpm", "ef94589b8c8999367debd700799ec9b91eff7f56e5fa102d0f535ef23faea921", 382125, "LGPL-2.1-or-later", false],
    ["libsndfile.i686", "libsndfile-1.2.2-12.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libsndfile-1.2.2-12.fc45.i686.rpm", "ae30b3feb216000c70993b83eeee85a6c78b68eeab35f0f9cec8ff952f010a99", 253714, "LGPL-2.1-or-later AND GPL-2.0-or-later AND BSD-3-Clause", false],
    ["libstdc++.i686", "libstdc++-16.2.1-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libstdc++-16.2.1-3.fc45.i686.rpm", "5d56711d89380d6542e31f0f98e07a10c8614c4f31a1403cd0234f6e0c86d366", 1115494, "GPL-3.0-or-later AND LGPL-3.0-or-later AND (GPL-3.0-or-later WITH GCC-exception-3.1) AND (GPL-3.0-or-later WITH Texinfo-exception) AND (LGPL-2.1-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GCC-exception-2.0) AND (GPL-2.0-or-later WITH GNU-compiler-exception) AND BSL-1.0 AND GFDL-1.3-or-later AND Linux-man-pages-copyleft-2-para AND SunPro AND BSD-1-Clause AND BSD-2-Clause AND BSD-2-Clause-Views AND BSD-3-Clause AND BSD-4-Clause AND BSD-Source-Code AND Zlib AND MIT AND Apache-2.0 AND (Apache-2.0 WITH LLVM-Exception) AND ZPL-2.1 AND ISC AND LicenseRef-Fedora-Public-Domain AND HP-1986 AND curl AND Martin-Birgmeier AND HPND-Markus-Kuhn AND dtoa AND SMLNJ AND AMD-newlib AND OAR AND HPND-merchantability-variant AND HPND-Intel", false],
    ["libtasn1.i686", "libtasn1-4.21.0-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libtasn1-4.21.0-2.fc45.i686.rpm", "653fd46c48978340676bc501f775d8be4d4e552094d55a101dd638ae7f674369", 79217, "GPL-3.0-or-later AND LGPL-2.1-or-later", false],
    ["libtiff.i686", "libtiff-4.7.2-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libtiff-4.7.2-3.fc45.i686.rpm", "7a4f61e39967857221e04105aec175b3d12a2399d7c7cca14ef50453caed8bf5", 257203, "libtiff", false],
    ["libunistring.i686", "libunistring-1.1-12.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libunistring-1.1-12.fc45.i686.rpm", "1bdbe897c0c018466728206d1ded806b09c60f53cf2381ef507eaa85429aeadf", 566981, "GPL-2.0-or-later OR LGPL-3.0-or-later", false],
    ["libusb1.i686", "libusb1-1.0.30-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libusb1-1.0.30-2.fc45.i686.rpm", "3a6200d28d2dbb3f4fcdf40fbcff57a48ac57540ed4889a79f37179fb2875925", 88963, "LGPL-2.1-or-later", false],
    ["libuuid.i686", "libuuid-2.42.4-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libuuid-2.42.4-1.fc45.i686.rpm", "379f03f3c80ab90dbd21659d18c50336d9658686293be04120d8cca76369a0fe", 30498, "BSD-3-Clause", false],
    ["libva.i686", "libva-2.24.1-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libva-2.24.1-2.fc45.i686.rpm", "ee7d64f1fa6f3328b6a73537f91de51e6295eb0ae987026b907b03dd75869c97", 133258, "MIT AND HPND-sell-variant AND ICU", false],
    ["libvdpau.i686", "libvdpau-1.5-12.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libvdpau-1.5-12.fc45.i686.rpm", "72a303c31362071f29523898532d6026606c50fdd097b38d7dbdd53cbe4c0ac0", 17124, "MIT", false],
    ["libvorbis.i686", "libvorbis-1.3.7-21.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libvorbis-1.3.7-21.fc45.i686.rpm", "7653bece28862f6cabe380aa8404f46b82ad3922d452442ce8f9d63c15e7d019", 198987, "BSD-3-Clause", false],
    ["libwayland-client.i686", "libwayland-client-1.26.0-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libwayland-client-1.26.0-3.fc45.i686.rpm", "b3bd2a1dcc725563b255365727a7296cbbd1f4d010d39d47716f2a76989b9487", 36884, "MIT", false],
    ["libwebp.i686", "libwebp-1.6.0-4.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libwebp-1.6.0-4.fc45.i686.rpm", "dc117a0bff80c0d59b6d95949df8926c79d746afd70a16b61ca1b0ee7dcf1492", 347664, "Apache-2.0 AND BSD-3-Clause WITH Google-Patent-WebM AND BSD-3-Clause AND FSFULLRWD", false],
    ["libxcb.i686", "libxcb-1.17.0-8.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxcb-1.17.0-8.fc45.i686.rpm", "c95ebba3ed24383ace79ab02891c526caa3580110c75a42b54f2bd9074e8c5ec", 261915, "X11", false],
    ["libxcrypt.i686", "libxcrypt-4.5.2-4.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxcrypt-4.5.2-4.fc45.i686.rpm", "d83a139448c77a34575b0becd033845d8517cd1e4910559c080314f6c1eb210f", 135881, "LGPL-2.1-or-later AND BSD-3-Clause AND BSD-2-Clause AND BSD-2-Clause-FreeBSD AND 0BSD AND CC0-1.0 AND LicenseRef-Fedora-Public-Domain", false],
    ["libxkbcommon-x11.i686", "libxkbcommon-x11-1.13.1-4.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxkbcommon-x11-1.13.1-4.fc45.i686.rpm", "b3a4a48cdb1cd8e349ee4ebc3dd3b4a282a0ac888172ea63a03dac4204ef54fc", 23583, "MIT AND X11 AND MIT-CMU", false],
    ["libxkbcommon.i686", "libxkbcommon-1.13.1-4.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxkbcommon-1.13.1-4.fc45.i686.rpm", "958956016aa06c1b7007ebc18591e66e12e34d8922be285c2961964dd3db07c1", 195746, "MIT AND X11 AND MIT-CMU", false],
    ["libxml2.i686", "libxml2-2.15.4-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxml2-2.15.4-1.fc45.i686.rpm", "b9b39e422fb4bb9b3fdd5a4904f37107bcf32a3f69eaac54d8b930bf0e8ea88f", 723400, "MIT AND ISC-Veillard AND W3C", false],
    ["libxshmfence.i686", "libxshmfence-1.3.2-9.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxshmfence-1.3.2-9.fc45.i686.rpm", "292d8e98c4ca6847b58918508381002b10ba7b2504c01ff16793176294f5f7bc", 13494, "HPND-sell-variant", false],
    ["libzstd.i686", "libzstd-1.5.7-6.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libzstd-1.5.7-6.fc45.i686.rpm", "20b1ee8afd31501750ad729f023458e111b208125304600ba434abacf5c74bb1", 372911, "BSD-3-Clause OR GPL-2.0-only", false],
    ["llvm-filesystem.i686", "llvm-filesystem-23.1.5-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/llvm-filesystem-23.1.5-2.fc45.i686.rpm", "d32021762586618f92c8b8dff9fafeafb365b2c58bc54efc66676a6fc574ce30", 7583, "Apache-2.0 WITH LLVM-exception OR NCSA", false],
    ["llvm-libs.i686", "llvm-libs-23.1.5-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/llvm-libs-23.1.5-2.fc45.i686.rpm", "64c282239178f896e1ef3949f5c3305d751fdb9a6dffbd84ab3e2bcfc8de0f43", 36557987, "Apache-2.0 WITH LLVM-exception OR NCSA", false],
    ["lm_sensors-libs.i686", "lm_sensors-libs-3.6.0-25.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/lm_sensors-libs-3.6.0-25.fc45.i686.rpm", "16d2df7ea78f934d0aa4c0360f53694da4969395e5db46bacadcd1baf803844d", 42561, "LGPL-2.1-or-later", false],
    ["mesa-dri-drivers.i686", "mesa-dri-drivers-26.2.6-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/m/mesa-dri-drivers-26.2.6-1.fc45.i686.rpm", "796daee00aad74c908d6458d041e8bfe334e0f02b66f6642e59579b8304e6660", 15160572, "MIT AND BSD-3-Clause AND SGI-B-2.0", false],
    ["mesa-filesystem.i686", "mesa-filesystem-26.2.6-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/m/mesa-filesystem-26.2.6-1.fc45.i686.rpm", "4596e4caba2048f09b56a35299476a95f3b07782c19a96457885994297cde5e3", 15239, "MIT AND BSD-3-Clause AND SGI-B-2.0", false],
    ["mesa-libEGL.i686", "mesa-libEGL-26.2.6-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/m/mesa-libEGL-26.2.6-1.fc45.i686.rpm", "2a7e1caeb2c42803164d31bc13e8e21e162e248f45a4eb4b2ddcc3a2220fd7ee", 152293, "MIT AND BSD-3-Clause AND SGI-B-2.0", false],
    ["mesa-libGL.i686", "mesa-libGL-26.2.6-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/m/mesa-libGL-26.2.6-1.fc45.i686.rpm", "c7ac1ebc62c4ba406935f6457c2a1396e256456df115916af2fae1e0178f9352", 149091, "MIT AND BSD-3-Clause AND SGI-B-2.0", false],
    ["mesa-libgbm.i686", "mesa-libgbm-26.2.6-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/m/mesa-libgbm-26.2.6-1.fc45.i686.rpm", "ada624c54ccdcd2e3c7a030228f0ebd4a2c703a19525da74db9a38e0f31beda5", 21945, "MIT AND BSD-3-Clause AND SGI-B-2.0", false],
    ["mesa-vulkan-drivers.i686", "mesa-vulkan-drivers-26.2.6-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/m/mesa-vulkan-drivers-26.2.6-1.fc45.i686.rpm", "c16899b0726e3b5eee5d901fc0db32ae3ed5c863255d8d1374f7de492b636bae", 30253837, "MIT AND BSD-3-Clause AND SGI-B-2.0", false],
    ["mpg123-libs.i686", "mpg123-libs-1.33.6-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/m/mpg123-libs-1.33.6-3.fc45.i686.rpm", "a87a6a346b891fe46cc34b7693838359a3582bcb21dcbc76e880c69b8d22d442", 375894, "GPL-2.0-or-later", false],
    ["ncurses-libs.i686", "ncurses-libs-6.6-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/ncurses-libs-6.6-3.fc45.i686.rpm", "6da64a68765ded01eb77e35f68eef7fb90d640a1d6c27efd9789a5a1873b0431", 371042, "MIT-open-group", false],
    ["nettle.i686", "nettle-4.0-5.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/nettle-4.0-5.fc45.i686.rpm", "ed4b4dcdeecee557871ab5932063d2947f4c2f209087d54808d92bd703f83b4d", 456950, "LGPL-3.0-or-later OR GPL-2.0-or-later", false],
    ["nspr.i686", "nspr-4.39.0-10.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nspr-4.39.0-10.fc45.i686.rpm", "d62a03ac33f4757b1b5c4dc7c6870eca41b2117ced8034141e81c9d1116f50aa", 159609, "MPL-2.0", false],
    ["nss-softokn-freebl.i686", "nss-softokn-freebl-3.133.0-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nss-softokn-freebl-3.133.0-1.fc45.i686.rpm", "3c8002ab511e310cee74ffe74ba14f9c7906c970fec32e89a53e236021304c9a", 442794, "MPL-2.0", false],
    ["nss-softokn.i686", "nss-softokn-3.133.0-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nss-softokn-3.133.0-1.fc45.i686.rpm", "cc0e689bb3e80a096c41e6db927c5443cf0551aa6e62433d930f392e19bee5ac", 495652, "MPL-2.0", false],
    ["nss-util.i686", "nss-util-3.133.0-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nss-util-3.133.0-1.fc45.i686.rpm", "28df02fb8436a13ccd4b15fa1c2b613ae860d82a778f2f29304b88b710284316", 98897, "MPL-2.0", false],
    ["nss.i686", "nss-3.133.0-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nss-3.133.0-1.fc45.i686.rpm", "00b70f09d48907c8cefc2f4c3375e9eb6533df757117e2ed8297de0a805900b2", 829253, "MPL-2.0", false],
    ["openal-soft", "openal-soft-1.24.2-10.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/o/openal-soft-1.24.2-10.fc45.x86_64.rpm", "1c52a06d5bd02d37ddff42d0e5c553c8d78f47ad4abcd15686b072927409d1d9", 684256, "LGPL-2.0-or-later AND BSD-3-Clause AND GPL-2.0-or-later AND Apache-2.0 AND (LGPL-2.0-or-later AND BSD-3-Clause) AND (MIT WITH fmt-exception) AND NCL AND MIT AND LicenseRef-Fedora-Public-Domain", false],
    ["openal-soft.i686", "openal-soft-1.24.2-10.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/o/openal-soft-1.24.2-10.fc45.i686.rpm", "1dca64ed67b0b66c9678711e1cf240d9fe2a4231a512be790037cb19bd856c21", 716381, "LGPL-2.0-or-later AND BSD-3-Clause AND GPL-2.0-or-later AND Apache-2.0 AND (LGPL-2.0-or-later AND BSD-3-Clause) AND (MIT WITH fmt-exception) AND NCL AND MIT AND LicenseRef-Fedora-Public-Domain", false],
    ["openssl-libs.i686", "openssl-libs-4.0.3-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/o/openssl-libs-4.0.3-1.fc45.i686.rpm", "fae8d86f0f53d549302d4ca05f78716c62f2386cb24ca5c37a898e8c7ad6c0c3", 2451633, "Apache-2.0", false],
    ["opus.i686", "opus-1.6-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/o/opus-1.6-3.fc45.i686.rpm", "af8e13d5d6a4bc05b16d1bb5602a66653e996550040aff9437ecd68a2b0d66f1", 264630, "BSD-3-Clause AND BSD-2-Clause", false],
    ["p11-kit.i686", "p11-kit-0.26.5-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/p11-kit-0.26.5-1.fc45.i686.rpm", "23eed9ae640f32396fe80c3f9c9ccad2aebc411f05b14529d4dfd9cf025d849a", 574862, "BSD-3-Clause", false],
    ["pcre2.i686", "pcre2-10.49-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pcre2-10.49-1.fc45.i686.rpm", "ce580f62f6ed789cae36300bbb2c830b448a2f9b90bef5d3906bcdcd3f96912a", 278740, "BSD-3-Clause AND FSFULLR AND X11 AND GPL-2.0-or-later AND FSFAP AND FSFUL AND GPL-3.0-or-later", false],
    ["pipewire-alsa.i686", "pipewire-alsa-1.6.11-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pipewire-alsa-1.6.11-1.fc45.i686.rpm", "f0dce3254c075821afd3d03eddf795fc20e29b9c103d0b1768810942259eb8a7", 66974, "MIT", false],
    ["pipewire-libs.i686", "pipewire-libs-1.6.11-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pipewire-libs-1.6.11-1.fc45.i686.rpm", "af6c7eb0d67c64eb1949260f6646e8a43fa345e2d9da98cdcd79b31d091557a2", 2837700, "MIT AND GPL-2.0-or-later AND BSD-2-Clause AND LGPL-2.0-or-later", false],
    ["pulseaudio-libs.i686", "pulseaudio-libs-17.0-11.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pulseaudio-libs-17.0-11.fc45.i686.rpm", "26e07c28dc161b4265735753d8ed369f355d538591912487997f17bd4bcebffb", 732869, "LGPL-2.1-or-later", false],
    ["readline.i686", "readline-8.3-6.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/r/readline-8.3-6.fc45.i686.rpm", "bf554caf11eb1950422591881ffa17e1b2b5d5752147ef00acc0f1e2bd88211b", 240478, "GPL-3.0-or-later AND GPL-2.0-or-later AND GFDL-1.3-no-invariants-or-later", false],
    ["spandsp.i686", "spandsp-0.0.6-23.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/spandsp-0.0.6-23.fc45.i686.rpm", "b89be49344b3b51f63fba2458f78e2dab2edc4864db77566c658e5ba4df1625d", 357634, "LGPL-2.1-only AND GPL-2.0-only", false],
    ["spirv-tools-libs.i686", "spirv-tools-libs-2026.2-3.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/spirv-tools-libs-2026.2-3.fc45.i686.rpm", "a1c1dba5bddfd6f70d1223ecf1fd89171f78875bbf156df11f7b61b0c42452ff", 2067413, "Apache-2.0", false],
    ["sqlite-libs.i686", "sqlite-libs-3.53.4-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/sqlite-libs-3.53.4-1.fc45.i686.rpm", "cbeb283d3b2c74ccc35eb07b834146db815eb8cbd0bf093362fd4339549140c1", 873686, "blessing", false],
    ["systemd-libs.i686", "systemd-libs-262.1-1.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/s/systemd-libs-262.1-1.fc45.i686.rpm", "3b9f2e9c6661425cb39b2d311db1101730452dc604df220c877350fa5cb37d68", 1020497, "LGPL-2.1-or-later AND MIT", false],
    ["vulkan-loader.i686", "vulkan-loader-1.4.350.0-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/v/vulkan-loader-1.4.350.0-2.fc45.i686.rpm", "03ed43b251d0264064e1a6034d7a769d326e134e0416d12d6593c600d8f9870e", 183209, "Apache-2.0", false],
    ["webrtc-audio-processing.i686", "webrtc-audio-processing-2.1-11.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/w/webrtc-audio-processing-2.1-11.fc45.i686.rpm", "7a3231585b67b1bc45abe8f56d2ec77c25fe64f0c29ce6cc557b290a5dde905a", 482339, "BSD-3-Clause", false],
    ["xz-libs.i686", "xz-libs-5.8.3-2.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xz-libs-5.8.3-2.fc45.i686.rpm", "e2e6593ec748973602669f2d6b38e8d839af0e1bea62198ed081fa5c08dbb2c6", 129951, "0BSD", false],
    ["zlib-ng-compat.i686", "zlib-ng-compat-2.3.3-6.fc45.i686.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/z/zlib-ng-compat-2.3.3-6.fc45.i686.rpm", "42223f9327809ea2ff28856319cabdc32b9506007bd71404c0411eefd028dc9d", 100936, "Zlib", false],
];
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
