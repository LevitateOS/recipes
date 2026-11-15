// plasma: a Recipe group, installed into the system root (`recipe --system install plasma`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps).
// Generated: the two pin blocks, `version` and `network_max_bytes`, written by
// `cargo xtask base groups levitate` (glibc: Fedora RPMs) and
// `cargo xtask base groups acorn` (musl: Alpine APKs) from the seeds below. A
// package more than one group needs belongs to desktop-libs.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    network_max_bytes: 158334976,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc"],
    systems: ["levitate"],
    details: "KDE Plasma on Wayland: the workspace and panel, KWin with Xwayland for X11 programs, sound and screen settings, power management, the system information centre, GTK theming, the Breeze theme and icons, the desktop portal, the polkit agent, the wallet unlocked at login and the crash handler, with battery state, power profiles and mounting removable drives. LevitateOS's default desktop; removing it and installing another desktop is how desktops are changed.",
    homepage: "https://kde.org/plasma-desktop/",
    license: "GPL-2.0-or-later AND LGPL-2.1-or-later AND GPL-3.0-or-later",
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
    "plasma-desktop", "plasma-workspace", "kwin", "xorg-x11-server-Xwayland", "plasma-pa",
    "powerdevil", "kscreen", "kinfocenter", "kde-gtk-config", "breeze-gtk",
    "xdg-desktop-portal-kde", "polkit-kde", "kwalletmanager5", "pam-kwallet", "upower",
    "power-profiles-daemon", "udisks2", "sddm", "sddm-breeze", "sddm-wayland-plasma"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs", "audio", "fonts", "spelling"];

let ctx = #{
    name: "plasma",
    version: "2026.11.10",
    description: "The KDE Plasma desktop on Wayland",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-10): 184 packages, 157708485 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-10";
const RPM_PINNED_BYTES = 157708485;
// [name, file, URL, SHA-256, bytes, licence]
const RPM_PINS = [
    ["accountsservice", "accountsservice-26.27.3-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/accountsservice-26.27.3-2.fc45.x86_64.rpm", "759425bb99b5408edde1d64642bf356ac04933f3ff26999d45dd964a8d19972d", 149203, "GPL-3.0-or-later"],
    ["aha", "aha-0.5.1-17.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/aha-0.5.1-17.fc45.x86_64.rpm", "aace7c40ae4978af1819450e9cb2a89cb63bc83a64eb2105e5299b09c6d6bdc4", 39152, "MPL-1.1 OR LGPL-2.0-or-later"],
    ["appstream", "appstream-1.1.3-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/appstream-1.1.3-4.fc45.x86_64.rpm", "178e1befceaf937d5374c5d87964d69eb365c1393576576eaf9b6fdd16b888f6", 972639, "GPL-2.0-or-later AND LGPL-2.1-or-later"],
    ["appstream-qt", "appstream-qt-1.1.3-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/appstream-qt-1.1.3-4.fc45.x86_64.rpm", "0c2923f2733e93f3be6678282c7779ffc762a9969307962f3f58a9bc3a31d8a7", 116666, "GPL-2.0-or-later AND LGPL-2.1-or-later"],
    ["aurorae", "aurorae-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/a/aurorae-6.8.2-1.fc45.x86_64.rpm", "41458d419e056d0552bc9a2ea3a932435613fff2b79496b1ed34b46b3a7e5673", 223297, "GPL-2.0-or-later AND MIT AND CC0-1.0"],
    ["breeze-cursor-theme", "breeze-cursor-theme-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/b/breeze-cursor-theme-6.8.2-1.fc45.noarch.rpm", "ef122eb017e7be9945453a3a869c81c3b526cfb64d23482c5cb49ff8c7df339e", 1496887, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND MIT"],
    ["breeze-gtk", "breeze-gtk-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/b/breeze-gtk-6.8.2-1.fc45.noarch.rpm", "833736525b72d46534c17060eb5856fe7dfda7a88ccf70e355637c0fd21fd4be", 10101, "BSD-3-Clause AND CC0-1.0"],
    ["breeze-gtk-common", "breeze-gtk-common-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/b/breeze-gtk-common-6.8.2-1.fc45.noarch.rpm", "e4c5a64276db6a9bb88d2dda93fa22417ebc88c6c4018d5d8f52043477fa5a59", 321957, "BSD-3-Clause AND CC0-1.0"],
    ["breeze-gtk-gtk2", "breeze-gtk-gtk2-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/b/breeze-gtk-gtk2-6.8.2-1.fc45.noarch.rpm", "0b07439f21b893ea5e518569932b960c102acf87c9497f7560bf359b5b7b0e3e", 24152, "BSD-3-Clause AND CC0-1.0"],
    ["breeze-gtk-gtk3", "breeze-gtk-gtk3-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/b/breeze-gtk-gtk3-6.8.2-1.fc45.noarch.rpm", "8332ea9b05e6b207dd9cd7d33084be9bfac6d612def581c11dc714fea7974b50", 29830, "BSD-3-Clause AND CC0-1.0"],
    ["breeze-gtk-gtk4", "breeze-gtk-gtk4-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/b/breeze-gtk-gtk4-6.8.2-1.fc45.noarch.rpm", "084e2cbce09bea25dc0f46cb4abbb06cab351353a0cdda0f8f17d69b81c44f54", 27829, "BSD-3-Clause AND CC0-1.0"],
    ["clinfo", "clinfo-3.1.26.09.26-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/c/clinfo-3.1.26.09.26-1.fc45.x86_64.rpm", "7c24e61bff0d70a140af236dfff343c0ac8da72435e633625297a5ba691fe55c", 73264, "CC0-1.0"],
    ["cmake-filesystem", "cmake-filesystem-4.3.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/cmake-filesystem-4.3.0-5.fc45.x86_64.rpm", "4d4f5a8fac4af836b9c5b57a26f9a496ddb1adb70f7bbdf05bf3ba51cd086ceb", 15254, "BSD-3-Clause AND MIT-open-group AND Zlib AND Apache-2.0"],
    ["cxx-rust-cssparser", "cxx-rust-cssparser-1.1.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/cxx-rust-cssparser-1.1.0-1.fc45.x86_64.rpm", "8d337f576e8784bb0b2b85eaadfebbb2a584a607ded65fb3f42c2ef1602ee3d9", 734288, "BSD-2-Clause AND CC0-1.0 AND LGPL-2.1-only AND LGPL-3.0-only AND (Apache-2.0 OR MIT) and MIT AND MPL-2.0 AND (Unlicense OR MIT) AND Zlib"],
    ["ddcutil", "ddcutil-3.0.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/d/ddcutil-3.0.2-1.fc45.x86_64.rpm", "466d47b1d35da33b75c3063acfe08d4e4129f45f73dab45214b795e31ea1f1e1", 635981, "GPL-2.0-or-later"],
    ["desktop-backgrounds-compat", "desktop-backgrounds-compat-45.0.0-3.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/d/desktop-backgrounds-compat-45.0.0-3.fc45.noarch.rpm", "44257a91bab7e9228b10dbcec708c65e310293731142faa2b2ccab93e668049f", 9955, "LicenseRef-Fedora-Public-Domain AND GPL-1.0-or-later"],
    ["desktop-backgrounds-kde", "desktop-backgrounds-kde-45.0.0-3.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/d/desktop-backgrounds-kde-45.0.0-3.fc45.noarch.rpm", "b40e15b4775d1632405ae4e36267ea0f0ab163ea5df6e5451b7528eedc9a46ea", 8675, "LicenseRef-Fedora-Public-Domain AND GPL-1.0-or-later"],
    ["desktop-file-utils", "desktop-file-utils-0.28-8.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/d/desktop-file-utils-0.28-8.fc45.x86_64.rpm", "392abd20ca4b7ff8b6149afa240f8337ba1ec4de37cdde15af958375ef7dc98d", 72010, "GPL-2.0-or-later"],
    ["dmidecode", "dmidecode-3.7-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/d/dmidecode-3.7-2.fc45.x86_64.rpm", "4d22640486be9e005a09ef3b5c5398757b5546672df5dc33a654bb74e9bb3e58", 104419, "GPL-2.0-or-later"],
    ["egl-utils", "egl-utils-9.0.0-12.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/e/egl-utils-9.0.0-12.fc45.x86_64.rpm", "38eeb0385fa3103637ac417b646b796b3eab1810bb89d76e4d314136dbe5c104", 103968, "MIT"],
    ["emacs-filesystem", "emacs-filesystem-30.2-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/e/emacs-filesystem-30.2-3.fc45.x86_64.rpm", "3ce63114f9a5aef2ff054abc750cb484df0d3debbef7c97a34b05a976a96ce60", 8292, "CC0-1.0"],
    ["f45-backgrounds-base", "f45-backgrounds-base-45.0.4-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/f/f45-backgrounds-base-45.0.4-1.fc45.noarch.rpm", "d9b11e5e5a5052e92b140a88e02f7d02e7cb605ddf2839e4b25706857b9030ff", 10151862, "CC-BY-SA-4.0"],
    ["f45-backgrounds-kde", "f45-backgrounds-kde-45.0.4-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/f/f45-backgrounds-kde-45.0.4-1.fc45.noarch.rpm", "b9209b55a916ad2f2176c530738304c439ef53ad5db58f62566a984ed484fc9e", 17219, "CC-BY-SA-4.0"],
    ["fwupd", "fwupd-2.1.9-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/f/fwupd-2.1.9-1.fc45.x86_64.rpm", "abd664d8f3ac15df23c3ba6ddfa675f5868dd1adf32965a331286a8ce042e769", 3336556, "LGPL-2.1-or-later"],
    ["gobject-introspection", "gobject-introspection-1.86.0-11.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gobject-introspection-1.86.0-11.fc45.x86_64.rpm", "e47eb1b6312e5b9413b73b157bc042e54877fdb382802862f4f4c19adea8f82a", 125940, "GPL-2.0-or-later AND LGPL-2.0-or-later AND LGPL-2.1-or-later AND BSD-2-Clause"],
    ["gpsd-libs", "gpsd-libs-3.27.5-8.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/gpsd-libs-3.27.5-8.fc45.x86_64.rpm", "8cb6889d6ec0cba92a2f0862a1c5e72adb5a7712f37438dacc27b594c35fc989", 73834, "BSD-2-Clause"],
    ["gtk2", "gtk2-2.24.33-28.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gtk2-2.24.33-28.fc45.x86_64.rpm", "a1f1830a24caca77602d3218c7874d830f8c84e0ecddc2426e34e2a84bd0e691", 3595298, "LicenseRef-Callaway-LGPLv2+"],
    ["gtk2-engines", "gtk2-engines-2.20.2-35.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gtk2-engines-2.20.2-35.fc45.x86_64.rpm", "449122fef96a717d89a3c16daea10908289598b40a750df9285ac783db051aa0", 326716, "LGPL-2.1-or-later"],
    ["i2c-tools", "i2c-tools-4.4-7.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/i/i2c-tools-4.4-7.fc45.x86_64.rpm", "9a175c53ab95d5d67226f0d13b1d7260cbd221409555f52d9812dd58f2396a46", 73722, "GPL-2.0-or-later"],
    ["ibus-libs", "ibus-libs-1.5.35-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/i/ibus-libs-1.5.35-1.fc45.x86_64.rpm", "717127b0d145d2a2f0b0ed959fe18454be00db93fc62b9d2dc1af0b72eab1baa", 277457, "LGPL-2.1-or-later"],
    ["iio-sensor-proxy", "iio-sensor-proxy-3.9-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/i/iio-sensor-proxy-3.9-3.fc45.x86_64.rpm", "87016dc74214aa9c71ff9c1e6ab0a6b864db2b10ee6da3d0a8dcfcf9091e3c46", 67901, "GPL-3.0-or-later"],
    ["imath", "imath-3.1.12-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/i/imath-3.1.12-9.fc45.x86_64.rpm", "40731041a84feabab05b583bb58a7f6a73bd7d3f768f895fb086d72bb6f68500", 104059, "BSD-3-Clause"],
    ["kactivitymanagerd", "kactivitymanagerd-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kactivitymanagerd-6.8.2-1.fc45.x86_64.rpm", "982b91c641c8c9245047d511446ebb9cd218b186547e442de1bf88c655379b29", 294337, "CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kde-cli-tools", "kde-cli-tools-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kde-cli-tools-6.8.2-1.fc45.x86_64.rpm", "85635d8129dbf698963adcdf1ef223da3a0c6ef755bd6dbfd74668702e74a452", 898938, "Artistic-2.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kde-gtk-config", "kde-gtk-config-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kde-gtk-config-6.8.2-1.fc45.x86_64.rpm", "4df9e31aa1e7dd8932ffb0e348ee9ebe24a35a979ae616f53ff12518bfeadfd3", 139463, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only)"],
    ["kde-settings", "kde-settings-44.0-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kde-settings-44.0-1.fc45.noarch.rpm", "3ed699659c35c5dd137d5e154227a934b3491dda731531fdca7db686aeb73ce0", 43175, "MIT"],
    ["kde-settings-plasma", "kde-settings-plasma-44.0-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kde-settings-plasma-44.0-1.fc45.noarch.rpm", "81ed548234932f712944a250096a009259252691c30c0cac50b468fb03667cf9", 14570, "MIT"],
    ["kde-settings-sddm", "kde-settings-sddm-44.0-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kde-settings-sddm-44.0-1.fc45.noarch.rpm", "47f3e9f581e9795665828912696e96c81e50d301dbcdff3b15c50f7b210daef1", 9893, "MIT"],
    ["kdecoration", "kdecoration-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kdecoration-6.8.2-1.fc45.x86_64.rpm", "ef65b6b5b21ca91b1d6ea56b0359f90fc501d5c77af9e679eec926cc1deddec6", 131941, "LGPL-3.0-only AND LGPL-2.1-only AND CC0-1.0"],
    ["kdesu", "kdesu-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kdesu-6.8.2-1.fc45.x86_64.rpm", "070190b143b61a950d8ac753bfbe17c4381e7d69984f7ea7747e4eb7be130a19", 280518, "Artistic-2.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kdsoap-ws-discovery-client", "kdsoap-ws-discovery-client-0.4.0-7.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kdsoap-ws-discovery-client-0.4.0-7.fc45.x86_64.rpm", "6e072b3c6ca70eef6b55af69987ac08a26fcf277a78085754120a2ff39df042e", 79082, "GPL-3.0-or-later AND LicenseRef-OASIS AND LicenseRef-WS-Addressing AND LicenseRef-Discovery AND W3C"],
    ["kdsoap6", "kdsoap6-2.2.0-10.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kdsoap6-2.2.0-10.fc45.x86_64.rpm", "cf699818990cc89a2f7905e708fffebfc990bf46da8996af93dee5090dedcf36", 153200, "MIT"],
    ["kf6-baloo", "kf6-baloo-6.31.0-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kf6-baloo-6.31.0-3.fc45.x86_64.rpm", "00d37540ce91c2de818013002e082132e88938d44722f1888e2b8275a2e045fd", 417232, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND bzip2-1.0.6"],
    ["kf6-frameworkintegration", "kf6-frameworkintegration-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-frameworkintegration-6.31.0-1.fc45.x86_64.rpm", "f02bb46c3ca78535ddafdd90b58a436e4c51dca1439dd97f901420137c4615b6", 71108, "CC0-1.0 AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-3.0-only AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kf6-frameworkintegration-libs", "kf6-frameworkintegration-libs-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-frameworkintegration-libs-6.31.0-1.fc45.x86_64.rpm", "b7e9351c0c326b4b7257a63becff6f6e055c289f2afab5d9abf925e83d62ab13", 46881, "CC0-1.0 AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-3.0-only AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kf6-kdesu", "kf6-kdesu-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-kdesu-6.31.0-1.fc45.x86_64.rpm", "0dec607c6231e852665dfde185fe1228c908cfe7a055dc555b5dfa571953aaf7", 119498, "CC0-1.0 AND GPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-3.0-only AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kf6-kdnssd", "kf6-kdnssd-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-kdnssd-6.31.0-1.fc45.x86_64.rpm", "8e3f9a4141ca7cdbd06fd84575b4d64a1ea8f9a3261828ceb1dd509973aff9be", 135398, "BSD-3-Clause AND CC0-1.0 AND LGPL-2.0-or-later"],
    ["kf6-kholidays", "kf6-kholidays-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-kholidays-6.31.0-1.fc45.x86_64.rpm", "5293299557dd8766ebafd256c48f5a17d41a32bede4c510f69e2befd5547edb0", 377058, "BSD-2-Clause AND CC0-1.0 AND GPL-3.0-or-later AND LGPL-2.0-or-later WITH Bison-exception-2.2"],
    ["kf6-kidletime", "kf6-kidletime-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-kidletime-6.31.0-1.fc45.x86_64.rpm", "28a1065adf2229f92a7e01563e7f313a77194c12690bbe6b0e071b3e664b1bd3", 71774, "CC0-1.0 AND GPL-2.0-or-later AND LGPL-2.1-or-later AND MIT"],
    ["kf6-kimageformats", "kf6-kimageformats-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-kimageformats-6.31.0-1.fc45.x86_64.rpm", "379a4759cb45b2343fb403dde53d2e03d93e5f1b7ef12319ddc2cbf63b48fa1f", 809788, "LGPLv2+"],
    ["kf6-krunner", "kf6-krunner-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-krunner-6.31.0-1.fc45.x86_64.rpm", "b1547907689e5b7dfc427c2777208563acf6c967c864c1b1de412769e91b92fc", 167210, "BSD-2-Clause AND CC0-1.0 AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kf6-kunitconversion", "kf6-kunitconversion-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-kunitconversion-6.31.0-1.fc45.x86_64.rpm", "28e624c767a20f528de1380585790bf87bcff992c163d839ee26e4518d11d400", 1142102, "CC0-1.0 AND LGPL-2.0-or-later"],
    ["kf6-kwallet", "kf6-kwallet-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-kwallet-6.31.0-1.fc45.x86_64.rpm", "60315c2e20ad6a8f7efc45e6e9db084b740084617fff6f8baf11981a20d04d79", 577924, "BSD-3-Clause AND CC0-1.0 AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-or-later AND LGPL-3.0-or-later"],
    ["kf6-qqc2-desktop-style", "kf6-qqc2-desktop-style-6.31.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kf6-qqc2-desktop-style-6.31.0-1.fc45.x86_64.rpm", "7fde850978c2993e1ae4e910a7a5c023cc84edc214d38d286075f8908cd58caf", 727705, "CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-or-later AND LGPL-2.1-or-later AND LGPL-3.0-only AND LicenseRef-KFQF-Accepted-GPL"],
    ["kglobalacceld", "kglobalacceld-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kglobalacceld-6.8.2-1.fc45.x86_64.rpm", "43e8b1a96c3cbec262e17a17cddaf5ca6b8c6d2b1bb9cc3727289aca888384cc", 152707, "CC0-1.0 AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-3.0-only AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kinfocenter", "kinfocenter-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kinfocenter-6.8.2-1.fc45.x86_64.rpm", "7defd8ab32ee51a179c2450623b3754365660f23d2c9ac078b7082003e81e5ad", 1273403, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND FSFAP AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kio-extras", "kio-extras-26.08.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kio-extras-26.08.2-1.fc45.x86_64.rpm", "b51f8f5807169b29c8016661bc3f8fb63d2b2014682f25eb377e8d58953338da", 2655031, "GPL-2.0-or-later"],
    ["kio-fuse", "kio-fuse-5.1.1-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kio-fuse-5.1.1-4.fc45.x86_64.rpm", "746e1e4d8316f9a0a7eb0e41864847452691682c90940ab5ec3fd40f147a4404", 106947, "GPL-3.0-or-later"],
    ["kmenuedit", "kmenuedit-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kmenuedit-6.8.2-1.fc45.x86_64.rpm", "320d9eb341ffe8f52a76dc3ec1efcd3158feb0f93ed4d1a18c9320c86f255d31", 1145219, "CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later"],
    ["knighttime", "knighttime-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/knighttime-6.8.2-1.fc45.x86_64.rpm", "3f61f98df44502ab0fb9d0e555947c47de0bb05f9609d555dcded15def183d50", 104615, "GPL-3.0-only AND BSD-3-Clause AND MIT AND GPL-2.0-only AND LGPL-2.1-only AND CC0-1.0 AND LGPL-3.0-only"],
    ["kscreen", "kscreen-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kscreen-6.8.2-1.fc45.x86_64.rpm", "6ee4a23f6bb142e84a0f73b92090423846230643a6d00ca94853d04cb272dea8", 2148057, "CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-or-later AND (GPL-2.0-only OR GPL-3.0-only)"],
    ["kscreenlocker", "kscreenlocker-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kscreenlocker-6.8.2-1.fc45.x86_64.rpm", "3d004049d7893f919af25ff4a47ca25b20ac19922f756dbd92b167e2cd6a0304", 380165, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["kwalletmanager5", "kwalletmanager5-26.08.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/kwalletmanager5-26.08.2-1.fc45.x86_64.rpm", "47e1245839f0a4fa4e042abcebd4e6fd58bfcf7a07e6a5fe821bac3b8ad1cc4e", 1337133, "GPL-2.0-or-later"],
    ["kwayland", "kwayland-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kwayland-6.8.2-1.fc45.x86_64.rpm", "df3df0d6b3cb329831d2d894292231fb86c6c54a014ae2a57e6e187a84bde2bb", 250150, "BSD-3-Clause AND CC0-1.0 AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND MIT-CMU AND MIT"],
    ["kwin", "kwin-6.8.2-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kwin-6.8.2-3.fc45.x86_64.rpm", "db0bcd4cce7772040aeaaad274742dcd25c7c842038972a713fe0e3d656c1936", 536939, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND GPL-3.0-or-later AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["kwin-common", "kwin-common-6.8.2-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kwin-common-6.8.2-3.fc45.x86_64.rpm", "e4400c5ab06051cb450acf0eeb7942116276a12f13b0ecf3250135599eb7a6be", 3951441, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND GPL-3.0-or-later AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["kwin-libs", "kwin-libs-6.8.2-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kwin-libs-6.8.2-3.fc45.x86_64.rpm", "55bb8ac2a354ac3fd7e3787f4721d97020fdcd216045f4d8a7f3a0e501a7891c", 2961740, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND GPL-3.0-or-later AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["kwrited", "kwrited-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/kwrited-6.8.2-1.fc45.x86_64.rpm", "f3b5508ea50cc8bf354be97acb48fef196e4f422ecee5ccdc4dc84a3d4e34593", 42086, "CC0-1.0 AND GPL-2.0-or-later"],
    ["libXaw", "libXaw-1.0.16-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXaw-1.0.16-6.fc45.x86_64.rpm", "6947974d4fa5622523d00ba3c6dbc94796d5db453e735ba071ecfd451c62f8d6", 205059, "MIT-open-group AND X11 AND HPND AND HPND-sell-variant AND SMLNJ AND NTP"],
    ["libXdmcp", "libXdmcp-1.1.5-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXdmcp-1.1.5-6.fc45.x86_64.rpm", "420991f1bb704d48eee8f03887472f8cfe75e770f007e7e77fd76e8bbd08a269", 37781, "MIT-open-group"],
    ["libXfont2", "libXfont2-2.0.9-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXfont2-2.0.9-1.fc45.x86_64.rpm", "f2683c8dac74b4131aeec5b834fda449050a326f3dc121d04a4c0b4cb0a51d1f", 136998, "BSD-2-Clause AND BSD-4-Clause-UC AND HPND-sell-variant AND MIT-open-group AND SMLNJ AND X11"],
    ["libXmu", "libXmu-1.2.1-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXmu-1.2.1-6.fc45.x86_64.rpm", "648fc32e950a54974cd440dc7a444424c44ae606127fcd38cd380a5f50c1f766", 80971, "MIT-open-group AND SMLNJ AND X11 AND ISC"],
    ["libXpm", "libXpm-3.5.19-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXpm-3.5.19-4.fc45.x86_64.rpm", "072d23577275bf02cdb3b69394c6f0c057dc85f5a2aa4f428da08873006f567c", 71027, "MIT AND X11-distribute-modifications-variant"],
    ["libXxf86dga", "libXxf86dga-1.1.6-8.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXxf86dga-1.1.6-8.fc45.x86_64.rpm", "b06e693efbd648065babed09e6adeb4a9b0da2284a24560a28dc217af732acba", 21019, "MIT"],
    ["libatasmart", "libatasmart-0.19-33.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libatasmart-0.19-33.fc45.x86_64.rpm", "bd65f90d6d4ee7e9d6fdd620fd7204ef294f395ac1f7ec1d2fca28dc8d3a4cc4", 49061, "LGPL-2.1-or-later"],
    ["libavif", "libavif-1.3.0-7.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libavif-1.3.0-7.fc45.x86_64.rpm", "d6499066de2050f66369db8b1a9db52ba2d44fe41da306b1c0683559a67c7148", 127805, "BSD-2-Clause AND IJG AND Apache-2.0 AND BSD-3-Clause"],
    ["libblockdev", "libblockdev-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-3.5.0-5.fc45.x86_64.rpm", "b0840181582fd15dcddad80bb1afb307c822bf1a50b6df572c50b7cc231aac1f", 103620, "LGPL-2.1-or-later"],
    ["libblockdev-crypto", "libblockdev-crypto-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-crypto-3.5.0-5.fc45.x86_64.rpm", "3aa8c862a3bbe8e390bf5d43bef305576093d0d0e2c7ee4cd9b6d8bd9060e32d", 36470, "LGPL-2.1-or-later"],
    ["libblockdev-fs", "libblockdev-fs-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-fs-3.5.0-5.fc45.x86_64.rpm", "f9c104b2dbda28e2d4bb78ed55efda445ae593469f6078bd197d2d120264f7dd", 50128, "LGPL-2.1-or-later"],
    ["libblockdev-loop", "libblockdev-loop-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-loop-3.5.0-5.fc45.x86_64.rpm", "3ca0ee47fb24b181d383368e818b316eb212de2ff86751c5233ff51638f94cd5", 17966, "LGPL-2.1-or-later"],
    ["libblockdev-mdraid", "libblockdev-mdraid-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-mdraid-3.5.0-5.fc45.x86_64.rpm", "6f14f462fc8101f78c10ba7693faab50b54d789113af6619856070eb634f19d4", 23768, "LGPL-2.1-or-later"],
    ["libblockdev-nvme", "libblockdev-nvme-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-nvme-3.5.0-5.fc45.x86_64.rpm", "c7c7cb494ea33a9c80c98af7b29b02c25112d607fe1a7503c9d069e8f19697ad", 27944, "LGPL-2.1-or-later"],
    ["libblockdev-part", "libblockdev-part-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-part-3.5.0-5.fc45.x86_64.rpm", "e81994a0df59858ccf8c217418cd2cf9b990acd9e6a2e5a15ed6aa40776d8b53", 26024, "LGPL-2.1-or-later"],
    ["libblockdev-smart", "libblockdev-smart-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-smart-3.5.0-5.fc45.x86_64.rpm", "a78f4ff127a99c149b48c5116117aaa84a09ba9920fa99d9aad7e0bcb51e93f8", 19959, "LGPL-2.1-or-later"],
    ["libblockdev-swap", "libblockdev-swap-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-swap-3.5.0-5.fc45.x86_64.rpm", "a02488db3a760be5be8d256d824272451742a9720af51471d0f372de3383dffa", 18261, "LGPL-2.1-or-later"],
    ["libblockdev-utils", "libblockdev-utils-3.5.0-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblockdev-utils-3.5.0-5.fc45.x86_64.rpm", "f63e795ee96fd44b0f0b160512af478ef47a01d778314eaf147a7f53508013c8", 26918, "LGPL-2.1-or-later"],
    ["libbytesize", "libbytesize-2.12-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libbytesize-2.12-5.fc45.x86_64.rpm", "8b37b4155bf9710516a481f9e70fae100bfa7dae9f300bdf451111079cb8b115", 47132, "LGPL-2.1-or-later"],
    ["libddcutil", "libddcutil-3.0.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libddcutil-3.0.2-1.fc45.x86_64.rpm", "3129e032db37a6efa914d675e3790030e2fafb3087744b85d267935729656624", 505561, "GPL-2.0-or-later"],
    ["libdecor", "libdecor-0.2.5-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdecor-0.2.5-3.fc45.x86_64.rpm", "6e00725dcbb78b187e3e6ffd5e53cd0137df2ab04bbf9acf802c8692bf7b3328", 61334, "MIT"],
    ["libdeflate", "libdeflate-1.26-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdeflate-1.26-1.fc45.x86_64.rpm", "63753d4515d3f28f403c426f1d4830837e97eb8534ededb51af7bf110a663c79", 70124, "MIT"],
    ["libdisplay-info-tools", "libdisplay-info-tools-0.3.0-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdisplay-info-tools-0.3.0-2.fc45.x86_64.rpm", "840ebedea4e5290ffc660b881644b70d04c243a256f7e6511a023ca39e3a017c", 36150, "MIT"],
    ["libei", "libei-1.6.0-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libei-1.6.0-3.fc45.x86_64.rpm", "9ea59f639f8804e5f37ca92177fc6c44000b9ff24f8a9a8905346ad7756eb080", 58670, "MIT"],
    ["libeis", "libeis-1.6.0-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libeis-1.6.0-3.fc45.x86_64.rpm", "44ccf3c6f99af7f0aa9522fe2080164754644a74615612ea67e3b82ca8ac9e97", 59677, "MIT"],
    ["libfontenc", "libfontenc-1.1.8-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libfontenc-1.1.8-6.fc45.x86_64.rpm", "ea09b7fb5e63d9fa01f0a312b8c76b8f1e7c1e3a7051367cf0a3401d63e50db8", 32916, "MIT"],
    ["libfyaml", "libfyaml-0.8-10.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libfyaml-0.8-10.fc45.x86_64.rpm", "a849f3c02aaa929ae61fd6bfd3eea0e6d54a3de27097418e04f5abb1aa2e6fa5", 217502, "MIT and GPL-2.0-only and BSD-2-Clause"],
    ["libglvnd-gles", "libglvnd-gles-1.7.0-10.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libglvnd-gles-1.7.0-10.fc45.x86_64.rpm", "4b1d802457bcee155a812ab64ebdf254c23f8e1eb1074428dd07e531ddca972e", 29163, "MIT-feh AND MIT-Modern-Variant AND BSD-1-Clause AND BSD-3-Clause AND GPL-3.0-or-later WITH Autoconf-exception-macro"],
    ["libi2c", "libi2c-4.4-7.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libi2c-4.4-7.fc45.x86_64.rpm", "84be1db261d910bd7aa610092c8601ec25e478f444e5f59d237cdf3bccf44825", 22437, "LGPL-2.1-or-later"],
    ["libkscreen", "libkscreen-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libkscreen-6.8.2-1.fc45.x86_64.rpm", "fcfa9140b2a0a214b689c8d669b46ee030a0c8e2b07e6478287cf4be08e1e2a6", 305926, "GPL-2.0-or-later"],
    ["libkworkspace6", "libkworkspace6-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libkworkspace6-6.8.2-1.fc45.x86_64.rpm", "2ac3aab4bcbdb837df5a339c444676705adfb642d268474cb391185c63a46e5a", 136023, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND LGPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["libmtp", "libmtp-1.1.22-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libmtp-1.1.22-4.fc45.x86_64.rpm", "56c212a2788e524d45fb88bfce589b6a92807dfa6b7a92bc50acf83f65227e64", 161865, "LGPL-2.0-or-later AND LGPL-2.1-or-later AND LGPL-2.1-only AND FSFULLR AND LicenseRef-Fedora-UltraPermissive"],
    ["libnvme", "libnvme-1.16.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libnvme-1.16.2-1.fc45.x86_64.rpm", "d6e9a28bd9f3f38e6ce0bd1bfb65ee23890172b6f4b0cf0f76095b2ac3c83fb0", 125754, "LGPL-2.1-or-later"],
    ["liboeffis", "liboeffis-1.6.0-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/liboeffis-1.6.0-3.fc45.x86_64.rpm", "5cd79a801137b1ef6776711e4475d69c7e34de71a3a4b93ad0848414dc69b4ff", 22430, "MIT"],
    ["libqalculate", "libqalculate-5.11.0-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libqalculate-5.11.0-3.fc45.x86_64.rpm", "afd8b73337e1ad0a4a5530905fa1b46d5fdff39ad88b197272379db2b6b32083", 2721386, "GPL-2.0-or-later and LicenseRef-Fedora-Public-Domain and GFDL-1.1-or-later"],
    ["libreport-filesystem", "libreport-filesystem-2.17.15-14.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libreport-filesystem-2.17.15-14.fc45.noarch.rpm", "3a73612739a7e734626b0a090d3257841b9fd13e1a2d000c7763bbffc663fa99", 8817, "GPL-2.0-or-later"],
    ["libsecret", "libsecret-0.21.8.2-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libsecret-0.21.8.2-2.fc45.x86_64.rpm", "dac8f70040c76e14766db4206fb1636122de3d05c6f883b720f07d3c63353356", 184950, "LGPL-2.1-or-later AND Apache-2.0 AND (GPL-2.0-or-later OR TGPPL-1.0) AND LicenseRef-Fedora-Public-Domain AND GCR-docs"],
    ["libudisks2", "libudisks2-2.11.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libudisks2-2.11.2-1.fc45.x86_64.rpm", "c9c6cba35bf1ca059198cd1fda2df64bbdeaa069afdc86b4b966df88708b3534", 225800, "LGPL-2.0-or-later"],
    ["libunity-gtk3-parser", "libunity-gtk3-parser-0.0.0+17.04.20170403-25.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libunity-gtk3-parser-0.0.0+17.04.20170403-25.fc45.x86_64.rpm", "18998b0ab10b4da7258f244b30de113dd1f5be04d1019733531b95f8507273ce", 48526, "LGPL-3.0-only"],
    ["libva-utils", "libva-utils-2.24.0-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libva-utils-2.24.0-2.fc45.x86_64.rpm", "fce6c7fb97b383158b6c2f39cb12053233bb73398f24bcebfabf2860054463f2", 606581, "MIT AND BSD-3-Clause"],
    ["libwayland-server", "libwayland-server-1.26.0-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libwayland-server-1.26.0-3.fc45.x86_64.rpm", "c2affc80dae0d421872dfedd62cc137a9326ff70be552a8759675f299ebb0c27", 44985, "MIT"],
    ["libxcvt", "libxcvt-0.1.2-12.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxcvt-0.1.2-12.fc45.x86_64.rpm", "04c6e7faf4778f6fef005d488281c8abb7718e59751040367c72a146b8ab95b6", 13676, "MIT AND HPND-sell-variant"],
    ["libxkbfile", "libxkbfile-1.1.3-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxkbfile-1.1.3-6.fc45.x86_64.rpm", "26b2c9dc314dcf67184eba17f37563c7782df718dab517e5f0808032e284be62", 95430, "MIT-open-group AND HPND AND SMLNJ"],
    ["libxmlb", "libxmlb-0.3.29-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxmlb-0.3.29-1.fc45.x86_64.rpm", "bf7514fb4272fe0d0e551056e447dfeca0fb5c4d42dca39868c3c5d9c305d104", 122521, "LGPL-2.1-or-later"],
    ["libyuv", "libyuv-0-0.63.20260213git6067afd.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libyuv-0-0.63.20260213git6067afd.fc45.x86_64.rpm", "931624217fadfdc26d55bd239c0df4ee46f1b966e9dce7b5e23656144d8998de", 213993, "BSD-3-Clause"],
    ["mdadm", "mdadm-4.6-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/m/mdadm-4.6-2.fc45.x86_64.rpm", "bfdc8f8c696f80c374065de09c4eb6fe284bd683670ff84471188d38ed649d8b", 485868, "GPL-2.0-or-later"],
    ["nss-mdns", "nss-mdns-0.15.1-29.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/nss-mdns-0.15.1-29.fc45.x86_64.rpm", "e9364401751377d0002232cb04d40256dcde745cebd34231ade126e43296f458", 47027, "LGPL-2.1-or-later"],
    ["ocean-sound-theme", "ocean-sound-theme-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/o/ocean-sound-theme-6.8.2-1.fc45.noarch.rpm", "69b80394489fd75770fbdb80a6d16b01783e6b2528c567f37db114e53bcedf8f", 2065862, "CC0-1.0 AND BSD-2-Clause AND CC-BY-SA-4.0"],
    ["ocl-icd", "ocl-icd-2.3.5-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/o/ocl-icd-2.3.5-1.fc45.x86_64.rpm", "dbb0a2fae67d9f45e66dd5da64421109076e9d3038032fea64c20dc5bcdea892", 78034, "BSD-2-Clause"],
    ["openexr-libs", "openexr-libs-3.4.13-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/o/openexr-libs-3.4.13-2.fc45.x86_64.rpm", "d95dba24af163cc3d7ba65b4f6c5ee6595c803c5d0cba2afc739be6bd0e8fec0", 987409, "BSD-3-Clause WITH AdditionRef-OpenEXR-Additional-IP-Rights-Grant OR Apache-2.0"],
    ["pam-kwallet", "pam-kwallet-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pam-kwallet-6.8.2-1.fc45.x86_64.rpm", "c122a7c3ff000c3f3a2fefc112b3423cc9873e19368494db09d8f7cb35697d1d", 23906, "LGPL-2.0-or-later"],
    ["passim-libs", "passim-libs-0.1.12-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/passim-libs-0.1.12-1.fc45.x86_64.rpm", "421c994637971ac363a39492235121815ac26cd7f452435436801cf1d56d43b4", 33427, "LGPL-2.1-or-later"],
    ["pinentry", "pinentry-1.3.3-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pinentry-1.3.3-2.fc45.x86_64.rpm", "0f4771e1683f4e9974af529263ba79f3e40b0f16ab64ec39d537938f8cf92d27", 116336, "GPL-2.0-or-later"],
    ["pinentry-qt", "pinentry-qt-1.3.3-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pinentry-qt-1.3.3-2.fc45.x86_64.rpm", "c7dba3a9011e84096da8b6e9688e62ab2b9f14c1a4702679f921a487a0848f53", 92304, "GPL-2.0-or-later"],
    ["plasma-activities-stats", "plasma-activities-stats-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-activities-stats-6.8.2-1.fc45.x86_64.rpm", "6ba3aceb0d4332a884c1c0d30fa4a55849df49eef22dee98ab93787376b5590a", 126559, "CC0-1.0, GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["plasma-breeze", "plasma-breeze-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-breeze-6.8.2-1.fc45.x86_64.rpm", "0a1401d585070a0c38d35c82f406b6b1a0cd1c1adc94985a44f92b9903421edb", 302661, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND MIT"],
    ["plasma-breeze-common", "plasma-breeze-common-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-breeze-common-6.8.2-1.fc45.noarch.rpm", "ea5bbeb20d8edc957176ffabd2e1c1ec5b98a0d5df56ebcea15a411017dfbbfe", 39143362, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND MIT"],
    ["plasma-breeze-qt6", "plasma-breeze-qt6-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-breeze-qt6-6.8.2-1.fc45.x86_64.rpm", "e3e22790cae2ad1536065026b6f23f32a28f1ae84dfbcd828fca0f5792fac08d", 251009, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND MIT"],
    ["plasma-desktop", "plasma-desktop-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-desktop-6.8.2-1.fc45.x86_64.rpm", "101307e58d25b20545ca452303c41dedf88002ed7b970e94d55eef110df75d32", 15977610, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["plasma-integration", "plasma-integration-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-integration-6.8.2-1.fc45.x86_64.rpm", "ef3a1b8b69dbceaad3491193fbebe1436c480571237eb44fd461983cda6325c8", 204033, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-or-later AND LGPL-3.0-only AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["plasma-keyboard", "plasma-keyboard-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-keyboard-6.8.2-1.fc45.x86_64.rpm", "8fe60cc04f5089505fb1166a855b12a15e99d6a4521926b851181a3a75ff6380", 446917, "LGPL-2.1-only AND GPL-2.0-only AND CC0-1.0 AND LGPL-3.0-only AND GPL-3.0-or-later AND GPL-2.0-or-later AND GPL-3.0-only"],
    ["plasma-lookandfeel-fedora", "plasma-lookandfeel-fedora-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-lookandfeel-fedora-6.8.2-1.fc45.noarch.rpm", "4dfe6c3862cce4725840bcb5a56fccc43cab2485d06027649607910c90973797", 886108, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND LGPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["plasma-pa", "plasma-pa-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-pa-6.8.2-1.fc45.x86_64.rpm", "77301d3084e2bd9acd82f5b8037b672874dea0f3c6b1d6b3328d0f51691fc502", 674119, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-3.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["plasma-systemsettings", "plasma-systemsettings-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-systemsettings-6.8.2-1.fc45.x86_64.rpm", "1173072fcfb8f1b766dd77e1fcfa3d3b356ffee9fe9f312d01bc16fdb67ac423", 482721, "BSD-2-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.1-or-later AND (GPL-2.0-only OR GPL-3.0-only)"],
    ["plasma-union", "plasma-union-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-union-6.8.2-1.fc45.x86_64.rpm", "f97fdb7d366bbcce020f2fee82152c44911637a9c1df36ec6bccf48769661077", 1139866, "BSD-2-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-3.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-3.0-only AND MIT"],
    ["plasma-workspace", "plasma-workspace-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-workspace-6.8.2-1.fc45.x86_64.rpm", "ff7173267d61a44b5a417dca95c6578c9d8707ffd52e1e3019069f6d6e6cc6c6", 17405720, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND LGPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["plasma-workspace-common", "plasma-workspace-common-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-workspace-common-6.8.2-1.fc45.x86_64.rpm", "d85055df85b573e65fcd1ef502258c92b45cfe19376ac2143fca7a239750a305", 41686, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND LGPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["plasma-workspace-libs", "plasma-workspace-libs-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-workspace-libs-6.8.2-1.fc45.x86_64.rpm", "8d29c1fe4d39a9f266ea415951bc8e79c588590164738bc3fa1a91c37355d4e2", 4456141, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND LGPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["plasma5support", "plasma5support-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma5support-6.8.2-1.fc45.x86_64.rpm", "8397cb40e26a426eb40ec26653e36d0002a25fa8a08d4b6dcb3b1df91cc67ca8", 1546338, "CC0-1.0 AND GPL-2.0-or-later AND LGPL-2.0-or-later"],
    ["polkit-kde", "polkit-kde-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/polkit-kde-6.8.2-1.fc45.x86_64.rpm", "0f00e19989bd983904ea5d07af69959835ea2d08468922824a68733b8b2c9fd8", 121983, "GPL-2.0-or-later AND CC0-1.0"],
    ["power-profiles-daemon", "power-profiles-daemon-0.30-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/power-profiles-daemon-0.30-4.fc45.x86_64.rpm", "fe773ed6f1022588430d5f83ccb87c9bc9181d237126c0ccb64d687a2475473a", 81673, "GPL-3.0-or-later"],
    ["powerdevil", "powerdevil-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/powerdevil-6.8.2-1.fc45.x86_64.rpm", "b8063c2a1dab69b8fa77ced28a1f9036dde6eab1845166973106ca1b907ad9e8", 2051135, "BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["pulseaudio-libs-glib2", "pulseaudio-libs-glib2-17.0-11.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pulseaudio-libs-glib2-17.0-11.fc45.x86_64.rpm", "fcf0f8ba19163b23ab216e4f8cc6c474e6e8bfd20f9a0067597a5bb9e84da29b", 16882, "LGPL-2.1-or-later"],
    ["pulseaudio-qt-qt6", "pulseaudio-qt-qt6-1.8.1-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pulseaudio-qt-qt6-1.8.1-2.fc45.x86_64.rpm", "6ecfd898086858ab2e758a7aeda9410b68f342e4a1f604d3b2875bac273501bd", 145495, "CC0-1.0 AND LGPL-2.1-only AND LGPL-3.0-only"],
    ["pulseaudio-utils", "pulseaudio-utils-17.0-11.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pulseaudio-utils-17.0-11.fc45.x86_64.rpm", "ccf2bb33f16cf486d2e241c2daac8543eeafd347db655cdb0d3d92adab2efb2f", 94109, "LGPL-2.1-or-later"],
    ["qaccessibilityclient-qt6", "qaccessibilityclient-qt6-0.6.0-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/q/qaccessibilityclient-qt6-0.6.0-6.fc45.x86_64.rpm", "b4a01915c99b0d3b73194040fe8b0b5270016b2dc5e7c9ba3516ed20c7b35a6d", 119987, "CC0-1.0 AND LGPL-2.1-only AND LGPL-3.0-only AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["qca-qt6", "qca-qt6-2.3.12-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/q/qca-qt6-2.3.12-1.fc45.x86_64.rpm", "aca56237b485318e04f45fb8f8632ba2c0217d80f92692de39429cc9d5066b24", 567740, "LGPL-2.1-only"],
    ["qca-qt6-ossl", "qca-qt6-ossl-2.3.12-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/q/qca-qt6-ossl-2.3.12-1.fc45.x86_64.rpm", "55968ef76df20151a3ebb227606c425ff997bc53b9d2ee065344dc8079eb4af7", 138366, "LGPL-2.1-only"],
    ["qqc2-breeze-style", "qqc2-breeze-style-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/q/qqc2-breeze-style-6.8.2-1.fc45.x86_64.rpm", "c3e6d839ddf5ccc37464b44a32b951316b5be8da27b30853b8b16983188e8d35", 607606, "CC0-1.0 and GPL-2.0-or-later AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["qt6-qtlocation", "qt6-qtlocation-6.11.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/q/qt6-qtlocation-6.11.2-1.fc45.x86_64.rpm", "bf6a1fdbb0ba53e019c4dee0642087c22f3492ea557250702acd49daec311579", 781940, "LGPL-3.0-only OR GPL-3.0-only WITH Qt-GPL-exception-1.0"],
    ["qt6-qtpositioning", "qt6-qtpositioning-6.11.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/q/qt6-qtpositioning-6.11.2-1.fc45.x86_64.rpm", "aa25c946743ec27440f494149d2fa772f167732fe9daa3572fd7c05287f75616", 477205, "LGPL-3.0-only OR GPL-3.0-only WITH Qt-GPL-exception-1.0"],
    ["qt6-qtserialport", "qt6-qtserialport-6.11.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/q/qt6-qtserialport-6.11.2-1.fc45.x86_64.rpm", "56420eb72faa5c6d40623b44fc741de8873949c0eddca18ea0f6cf5c7d89aaeb", 82947, "LGPL-3.0-only OR GPL-3.0-only WITH Qt-GPL-exception-1.0"],
    ["qt6-qttools", "qt6-qttools-6.11.2-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/q/qt6-qttools-6.11.2-2.fc45.x86_64.rpm", "832c8830d4a88736d24c92aa02a1225f9fd18fcbdcdac00ee43bf1b5c2c74d7b", 241195, "LGPL-3.0-only OR GPL-3.0-only WITH Qt-GPL-exception-1.0"],
    ["qt6-qttools-common", "qt6-qttools-common-6.11.2-2.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/q/qt6-qttools-common-6.11.2-2.fc45.noarch.rpm", "1752dc84d5a0509d60fe1984fa0f970ed73242f217afd06c73507c2709c3814b", 11676, "LGPL-3.0-only OR GPL-3.0-only WITH Qt-GPL-exception-1.0"],
    ["qt6-qtvirtualkeyboard", "qt6-qtvirtualkeyboard-6.11.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/q/qt6-qtvirtualkeyboard-6.11.2-1.fc45.x86_64.rpm", "156386288036a3ddf128271a0c687ad90b4a8f165e3387ea5c9cb1138711919a", 2684739, "GPL-3.0-only WITH Qt-GPL-exception-1.0"],
    ["qt6-qtwayland", "qt6-qtwayland-6.11.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/q/qt6-qtwayland-6.11.2-1.fc45.x86_64.rpm", "ea7f133edfaa61c94c01882571b986ed6211acfa5c466cbc474a77491bbc3a17", 821412, "LGPL-3.0-only OR GPL-3.0-only WITH Qt-GPL-exception-1.0"],
    ["redhat-menus", "redhat-menus-12.0.2-42.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/r/redhat-menus-12.0.2-42.fc45.noarch.rpm", "a66a0b4d60df0c9b9a363b93041800627cbc5723d9b8ead93bc9cb4b286bb3ba", 159193, "GPL-1.0-or-later"],
    ["sddm", "sddm-0.21.0-16.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/sddm-0.21.0-16.fc45.x86_64.rpm", "4a76100fa59388236aae4b92696871feab3f225e399848c158def050b953445c", 634853, "GPL-2.0-or-later"],
    ["sddm-breeze", "sddm-breeze-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/s/sddm-breeze-6.8.2-1.fc45.noarch.rpm", "f5e964c3b71e391e378ac4756fcb2934be915e5f2ce8100e335857e30813a435", 1154233, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["sddm-wayland-plasma", "sddm-wayland-plasma-6.8.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/s/sddm-wayland-plasma-6.8.2-1.fc45.noarch.rpm", "fc606e63e702f1e98995726e7a5c6663a69fe02f77250b9af7c5515e0ca984ba", 13876, "BSD-2-Clause AND BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.0-only AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-2.1-or-later AND LGPL-3.0-only AND LGPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only) AND (LGPL-2.1-only OR LGPL-3.0-only) AND MIT"],
    ["setxkbmap", "setxkbmap-1.3.5-7.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/setxkbmap-1.3.5-7.fc45.x86_64.rpm", "b6cf24e3b57db57cccabd5e0c6eba674ab033d5fc096b538824d21b6468af1bb", 22952, "HPND"],
    ["signon", "signon-8.60^20240205.c8ad982-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/signon-8.60^20240205.c8ad982-6.fc45.x86_64.rpm", "8e9b2629c7e0640d9dfe356b4e6d4655946afcddc1b6d15854b14dee0d267f98", 336072, "LGPL-2.1-only"],
    ["signon-plugin-oauth2", "signon-plugin-oauth2-0.25^20231216.fab6988-8.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/signon-plugin-oauth2-0.25^20231216.fab6988-8.fc45.x86_64.rpm", "9263664df4bf5212e98b103e4b1d6110a7c33f0b390e6011173a3d45041f4fe3", 95607, "LGPL-2.1-or-later"],
    ["socat", "socat-1.8.1.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/s/socat-1.8.1.3-1.fc45.x86_64.rpm", "a559691d4688060d51c9b642fae6a17150b96689f4b30d28ee36b73b3fa56a6a", 405365, "GPL-2.0-only"],
    ["source-foundry-hack-fonts", "source-foundry-hack-fonts-3.003-8.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/source-foundry-hack-fonts-3.003-8.fc45.noarch.rpm", "f4eaa097b2c0f157a269f2b43cdf928acd2dbce08819fbbeb1f821ab281d8ffe", 409592, "MIT AND Bitstream-Vera"],
    ["udisks2", "udisks2-2.11.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/udisks2-2.11.2-1.fc45.x86_64.rpm", "d6f8a79ff9d783fc71bf4e89b1c478e18e09e321ac4012a14ba7023cec722c42", 579077, "GPL-2.0-or-later"],
    ["unity-gtk-module-common", "unity-gtk-module-common-0.0.0+17.04.20170403-25.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/unity-gtk-module-common-0.0.0+17.04.20170403-25.fc45.noarch.rpm", "a8ecee714bdb661d6d92c5486619182c27773a14309d04fade711fdd80eb24e8", 23144, "LGPL-3.0-only"],
    ["unity-gtk3-module", "unity-gtk3-module-0.0.0+17.04.20170403-25.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/unity-gtk3-module-0.0.0+17.04.20170403-25.fc45.x86_64.rpm", "c6439aa880d6a4e8ceada59be8ea4e8798e367b1e220e5443db4ea05c3c8d433", 19245, "LGPL-3.0-only"],
    ["upower", "upower-1.91.5-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/upower-1.91.5-1.fc45.x86_64.rpm", "9a12542effad810b9a485034eab54db13f920330928dc329debbbe0f7afb8dfc", 138199, "GPL-2.0-or-later"],
    ["upower-libs", "upower-libs-1.91.5-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/upower-libs-1.91.5-1.fc45.x86_64.rpm", "ae9362b12c34b1678e095724484d3fda0372b9f16a17e4b933b37bd9900fd625", 61631, "GPL-2.0-or-later"],
    ["volume_key-libs", "volume_key-libs-0.3.12-33.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/v/volume_key-libs-0.3.12-33.fc45.x86_64.rpm", "1fa555cfe7ac38f37c19744b93a1a56ea47a2a660c66d201ac35ecf3beb85353", 155254, "GPL-2.0-only AND (MPL-1.1 OR GPL-2.0-or-later OR LGPL-2.1-or-later)"],
    ["vulkan-tools", "vulkan-tools-1.4.350.0-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/v/vulkan-tools-1.4.350.0-2.fc45.x86_64.rpm", "042142949a49cf9160dc7d5be2afabf836d462643435a21937886b94cff933db", 438495, "Apache-2.0"],
    ["wayland-utils", "wayland-utils-1.3.0-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/w/wayland-utils-1.3.0-4.fc45.x86_64.rpm", "5dfd544ec85fe862d3fdf579c54ed0108adbc1f32952e1095ed0411be78ee4eb", 32698, "MIT"],
    ["xdg-desktop-portal-gtk", "xdg-desktop-portal-gtk-1.15.3-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xdg-desktop-portal-gtk-1.15.3-6.fc45.x86_64.rpm", "1f10819733547ed17dbe71b4b957bc618f5fa39974ed67043de806a826591cf0", 146820, "LGPL-2.0-or-later"],
    ["xdg-desktop-portal-kde", "xdg-desktop-portal-kde-6.8.2-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/x/xdg-desktop-portal-kde-6.8.2-1.fc45.x86_64.rpm", "6508b8a47cc9b37a51e62819cc096291652261af4b391545b9b7395eea05283e", 843747, "BSD-2-Clause AND CC0-1.0 AND GPL-2.0-or-later AND LGPL-2.0-or-later AND LGPL-2.1-only AND LGPL-3.0-only AND (LGPL-2.1-only OR LGPL-3.0-only)"],
    ["xdg-user-dirs", "xdg-user-dirs-0.20-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xdg-user-dirs-0.20-2.fc45.x86_64.rpm", "7589f2fda4fbeba051b35af7185793540be7fb257e02fd9f5907f7da03c1f5bb", 93176, "GPL-2.0-or-later AND MIT"],
    ["xdg-utils", "xdg-utils-1.2.1-6.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xdg-utils-1.2.1-6.fc45.noarch.rpm", "c5ff00a03300f05f15e037f398cced3616515310115d224fa5612fbcd1c99c0d", 81168, "MIT"],
    ["xdpyinfo", "xdpyinfo-1.4.0-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xdpyinfo-1.4.0-2.fc45.x86_64.rpm", "1ff45d068d5bcda6928a2b40be289df1739c9e2daf64350d50926d5ed1c2876c", 26711, "MIT"],
    ["xhost", "xhost-1.0.10-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xhost-1.0.10-3.fc45.x86_64.rpm", "58f0a242784b14fae80fe9b78f5664d8b9dbf90b67fdb0b659d57526873612ad", 20779, "MIT AND ICU"],
    ["xkbcomp", "xkbcomp-1.5.0-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xkbcomp-1.5.0-3.fc45.x86_64.rpm", "ca5e3563a5ba9240f4e63569b8e8c7004f381387c241f658f2c011a27b7de8a2", 106246, "MIT-open-group AND HPND-DEC"],
    ["xmessage", "xmessage-1.0.7-10.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xmessage-1.0.7-10.fc45.x86_64.rpm", "53f8005e481912df483c5d35a588447e8e88fd7af9724038429776cd1a67b886", 31525, "X11"],
    ["xmodmap", "xmodmap-1.0.12-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xmodmap-1.0.12-4.fc45.x86_64.rpm", "08e01940486218104ad06e167b58313a99dd5d81b774b1f20a49ea29e98a0ffa", 32978, "MIT AND MIT-open-group"],
    ["xorg-x11-server-Xwayland", "xorg-x11-server-Xwayland-24.1.14-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/x/xorg-x11-server-Xwayland-24.1.14-2.fc45.x86_64.rpm", "c4fc0c50802ac7cd53ac6b99f08b314b58e44cbdd2aea23c92d6a381e6b09368", 1114717, "MIT"],
    ["xorg-x11-xauth", "xorg-x11-xauth-1.1.5-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xorg-x11-xauth-1.1.5-6.fc45.x86_64.rpm", "038d4637d836033db3dbf1d60227f2eed1d839ed6dbbf130e607da7c2ecd3b89", 35881, "MIT-open-group"],
    ["xorg-x11-xinit", "xorg-x11-xinit-1.4.3-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xorg-x11-xinit-1.4.3-6.fc45.x86_64.rpm", "d58f4c842ee4a58f608ac70aa44a4ee04b478874384592d0278faad3ca6cfb5d", 61185, "X11-distribute-modifications-variant AND MIT-open-group"],
    ["xrdb", "xrdb-1.2.3-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xrdb-1.2.3-3.fc45.x86_64.rpm", "5946b6a28cab5e244cbc5f489da656a7a088d81b9d2303d517caa415b52a8a64", 30034, "HPND-DEC AND MIT-open-group"],
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
// of its scripts. Paths a system package does not own (per-machine and
// run-time data: var, run, tmp and the like) are left out; the system makes
// them at boot. Owners stay names, resolved in the root the group is written
// into, after the accounts it needs are made there: those in its own
// usr/lib/sysusers.d (Fedora packages ship them) and ACCOUNTS_* above.
fn build(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    if exists(ctx.record) { rm(ctx.record); }
    if exists(ctx.system) { rm(ctx.system); }
    mkdir(ctx.system);
    let done = 0;
    for pin in ctx.pins {
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
    progress(done, ctx.pins.len(), "packages");
    for dir in ["var", "run", "tmp", "boot", "home", "root", "proc", "sys", "dev", "lost+found"] {
        let path = join_path(ctx.system, dir);
        if exists(path) { rm(path); }
    }
    target_finalize(ctx.system, #{ owners: "apply", accounts: ctx.accounts });
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
