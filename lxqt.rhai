// lxqt: a Recipe group, installed into the system root (`recipe --system install lxqt`)
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
    network_max_bytes: 76546048,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["musl"],
    systems: ["acornos"],
    details: "LXQt on X11 (XLibre): the session, panel, runner, settings, notifications, power management, the polkit agent and Openbox, with the picom compositor, gvfs for removable drives, phones, cameras and network shares, the desktop portals, keyboard and monitor settings, notify-send and the Adwaita cursor theme. AcornOS's default desktop; removing it and installing another desktop is how desktops are changed.",
    homepage: "https://lxqt-project.org",
    license: "LGPL-2.1-or-later AND GPL-2.0-or-later AND GPL-3.0-or-later",
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
    "lxqt-desktop", "picom", "gvfs", "gvfs-mtp", "gvfs-gphoto2", "gvfs-smb", "gvfs-nfs", "udisks2",
    "xdg-desktop-portal", "xdg-desktop-portal-lxqt", "setxkbmap", "xrandr", "dbus-x11",
    "adwaita-icon-theme", "breeze-icons"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs", "xlibre", "qterminal", "pcmanfm-qt", "lxqt-archiver"];

let ctx = #{
    name: "lxqt",
    version: "2026.11.13",
    description: "The LXQt desktop on X11",
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
// 2026-11-13): 117 packages, 76044770 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-13";
const APK_PINNED_BYTES = 76044770;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["adwaita-icon-theme", "adwaita-icon-theme-50.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/adwaita-icon-theme-50.0-r1.apk", "cdda5d059fdf6adae4d7e8fdc863ddf082eeb3a665a1ace3dc3740fe6f607f1e", 1895483, "LGPL-3.0-or-later OR CC-BY-SA-3.0", false],
    ["breeze-icons", "breeze-icons-6.26.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/breeze-icons-6.26.0-r0.apk", "c96e40c9b02a5baa397441407568d358fdc1d4d885a1750dddc8689e5632d697", 25209366, "LGPL-3.0-or-later", false],
    ["cryptsetup-libs", "cryptsetup-libs-2.8.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/cryptsetup-libs-2.8.6-r0.apk", "4e2803c61f4459800ff9b9b335138a9dfca6aeae2d2ea09d2fe97f8b06c30780", 224562, "GPL-2.0-or-later WITH cryptsetup-OpenSSL-exception", false],
    ["dbus-x11", "dbus-x11-1.16.2-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/dbus-x11-1.16.2-r2.apk", "e840cc3fa78f2c4885294b793a209db2cdc6979e4ef5e4fc1399358b9a5cfca4", 11418, "AFL-2.1 OR GPL-2.0-or-later", false],
    ["device-mapper", "device-mapper-2.03.35-r3.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/device-mapper-2.03.35-r3.apk", "2e3ff8563cd980ff89ae710ed395ef93b57ccafb7173564db927539d772a4d10", 44748, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["device-mapper-libs", "device-mapper-libs-2.03.35-r3.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/device-mapper-libs-2.03.35-r3.apk", "ba6522d2e88296a44b71a7038043552256feb14564a1886030102a262843abac", 138220, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["device-mapper-udev", "device-mapper-udev-2.03.35-r3.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/device-mapper-udev-2.03.35-r3.apk", "7df22e5071dd4be2548422f456c51adcb989a16d653c81c40ce0a6f01fa7fb73", 6009, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["fuse-common", "fuse-common-3.18.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/fuse-common-3.18.3-r0.apk", "88b89ca275fbeed7fd5b91f38d35077684e53f2c22676f40718fede8a7c89f73", 1649, "GPL-2.0-only AND LGPL-2.1-only", false],
    ["fuse-openrc", "fuse-openrc-3.18.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/fuse-openrc-3.18.3-r0.apk", "e9b27df46c9beed2482d8bf32e17f53d10fca2207cbfeb97cad55cbcf1b49d7f", 1975, "GPL-2.0-only AND LGPL-2.1-only", false],
    ["fuse3", "fuse3-3.18.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/fuse3-3.18.3-r0.apk", "75c11b645c916959c38d87e8418ef20dd1d8f49468fbdf78a3fc0f14b72f4d15", 19620, "GPL-2.0-only AND LGPL-2.1-only", false],
    ["fuse3-libs", "fuse3-libs-3.18.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/fuse3-libs-3.18.3-r0.apk", "5455c41da8abb45ece2c7bf74cb9a9f5758d9ba17118cb85a2bc5ebef159bcfa", 74302, "GPL-2.0-only AND LGPL-2.1-only", false],
    ["fuse3-udev", "fuse3-udev-3.18.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/fuse3-udev-3.18.3-r0.apk", "ae2c7465def9c2668b272b2b7d4ada94645f426fd0a9f0cfe71167f2a32c538d", 1700, "GPL-2.0-only AND LGPL-2.1-only", false],
    ["giflib", "giflib-5.2.2-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/giflib-5.2.2-r2.apk", "b9e569173af3a34a4756d9834fab7212863bd3b74f870ea9ed217caaf6faa695", 15592, "MIT", false],
    ["gnome-online-accounts", "gnome-online-accounts-3.58.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gnome-online-accounts-3.58.1-r0.apk", "1dd816089117b6f05f2079f6a1d7e70f181c10748c54128cabe5c8bf2ab063c5", 285621, "GPL-2.0-or-later", false],
    ["gvfs", "gvfs-1.60.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gvfs-1.60.1-r0.apk", "df70758a8ddc80bff63e682706ec573e93cb7f6337f491bc9b8b6097864584a5", 503705, "LGPL-2.0-or-later", false],
    ["gvfs-gphoto2", "gvfs-gphoto2-1.60.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gvfs-gphoto2-1.60.1-r0.apk", "6b226091959eabe54931e36055ab17b31c542ce5759534a847e7b18423eeea38", 49779, "LGPL-2.0-or-later", false],
    ["gvfs-mtp", "gvfs-mtp-1.60.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gvfs-mtp-1.60.1-r0.apk", "03edaf0359f4bbc1f880060553483d1ecb8e5e786f2e2787d45c98fbd481bca5", 25552, "LGPL-2.0-or-later", false],
    ["gvfs-nfs", "gvfs-nfs-1.60.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gvfs-nfs-1.60.1-r0.apk", "0cdf41d50a5c2b6a50ab22d595def7b7504103e81453c935a003adb3705c1bec", 18453, "LGPL-2.0-or-later", false],
    ["gvfs-openrc", "gvfs-openrc-1.60.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gvfs-openrc-1.60.1-r0.apk", "1f613d1bfd885e14c0b3c9a796ab7ea0b5cdd1438b7aaff409576354d7da8f5b", 1721, "LGPL-2.0-or-later", false],
    ["gvfs-smb", "gvfs-smb-1.60.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gvfs-smb-1.60.1-r0.apk", "e76e551bbdea9efd1a7cc7b8a31415f259405c01827e40da6b14fb369be6be08", 31431, "LGPL-2.0-or-later", false],
    ["imlib2", "imlib2-1.12.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/imlib2-1.12.6-r0.apk", "fd55f7cc7a1d8f54982b99dd1de11a259cfafea6b1385ab4a4a00b00acf30d0c", 561632, "Imlib2", false],
    ["keyutils-libs", "keyutils-libs-1.6.3-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/keyutils-libs-1.6.3-r4.apk", "855c94e6bd750fcd2ca34df29ae3602bc93bb0b4512b56d8f4ecca06919ed1b8", 7635, "GPL-2.0-or-later AND LGPL-2.0-or-later", false],
    ["kidletime", "kidletime-6.26.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/kidletime-6.26.0-r0.apk", "fd1216a2fd89c5ea6e6de5faa5469fcb5a39ced61c21102815a55e9b19cf134b", 65517, "LGPL-2.0-only", false],
    ["krb5-conf", "krb5-conf-1.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/krb5-conf-1.0-r2.apk", "28b8e361a1583c04e98c261c3eb05ca7f0c0e80a9984a7c1b3cbfd7b60c86f37", 1745, "MIT", false],
    ["krb5-libs", "krb5-libs-1.22.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/krb5-libs-1.22.3-r0.apk", "fad5b46a953e6a37a1bb61a84538fa08ecb6a07816f439eb06f2735aebfcbfbf", 767104, "MIT", false],
    ["ldb", "ldb-4.23.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/ldb-4.23.8-r0.apk", "f4033e23e49259eca0acfe0334ac126809cd8b0b379e2ecb629e52e888209149", 160834, "GPL-3.0-or-later AND LGPL-3.0-or-later", false],
    ["libatasmart", "libatasmart-0.19-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libatasmart-0.19-r4.apk", "9dc9acb3fe6ab4f1d5fe3409a72d19bf5f0a92637470764a20fa87903f146674", 25805, "LGPL-2.1-or-later", false],
    ["libauth-samba", "libauth-samba-4.23.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libauth-samba-4.23.8-r0.apk", "d2ec365521bd61746b481f4ead5fdb383bfb5c43e0fd02e58c60a02552f10e36", 64776, "GPL-3.0-or-later AND LGPL-3.0-or-later", false],
    ["libblockdev", "libblockdev-3.4.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libblockdev-3.4.0-r1.apk", "7dee334a088e9d9da561bd28a4e8136fcfe4f4bfd942ca5b9f5a0d780983b6f4", 306115, "LGPL-2.1-or-later", false],
    ["libbytesize", "libbytesize-2.12-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libbytesize-2.12-r1.apk", "3e88ab0ad890b7be7daa719e62ff68dfa1e58a0eecd152a654b8d30c45f67402", 9872, "LGPL-2.1-or-later", false],
    ["libconfig", "libconfig-1.8.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libconfig-1.8.2-r0.apk", "5c8179e99eda0728952c58ca21d362f0477af203a72f0e3b6d7bf5ae88b7f51a", 22278, "LGPL-2.1-or-later", false],
    ["libdbusmenu-lxqt", "libdbusmenu-lxqt-0.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libdbusmenu-lxqt-0.4.0-r0.apk", "51165dd78544e46302086c08e67e9e4bf4bf7337b24f6b221844739cc6008ef7", 80289, "LGPL-2.1-or-later", false],
    ["libev", "libev-4.33-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libev-4.33-r1.apk", "c2391d4608217a50ac03139a13910e315163825cd4d3b1f464d682e1a0b78a01", 23247, "BSD-2-Clause OR GPL-2.0-or-later", false],
    ["libheif", "libheif-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-1.23.7-r0.apk", "e57e22bc2d04e8b9a0d3008b1baf631aa244b8be2b27da31dfc91772ff428950", 800555, "LGPL-3.0-or-later", false],
    ["libheif-aom", "libheif-aom-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-aom-1.23.7-r0.apk", "f067d5c1dbe07c440bdb2e522766d9db1fbd2c6c745cd2c7cd49290b827abb64", 24934, "LGPL-3.0-or-later", false],
    ["libheif-dav1d", "libheif-dav1d-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-dav1d-1.23.7-r0.apk", "ac0f44f6344452d21e6993ba25a968541840a702129762031c90ef57be066ad1", 8660, "LGPL-3.0-or-later", false],
    ["libheif-ffmpeg", "libheif-ffmpeg-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-ffmpeg-1.23.7-r0.apk", "68cdd53a44b110f7422c5f1aea0e5484e072a6ed2b8e5648e7cca2365f483907", 14321, "LGPL-3.0-or-later", false],
    ["libheif-jpeg", "libheif-jpeg-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-jpeg-1.23.7-r0.apk", "a1bdfb8c1f017ebc038ec8f512a87f2ee9fe54d3156fa1d9f81063731d785aa5", 11377, "LGPL-3.0-or-later", false],
    ["libheif-libde265", "libheif-libde265-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-libde265-1.23.7-r0.apk", "8289a2cc31e98848724bdc4b14e0fa19fcb9ad6fd6ded85bafb2eef3e88032e2", 7338, "LGPL-3.0-or-later", false],
    ["libheif-openh264", "libheif-openh264-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-openh264-1.23.7-r0.apk", "f9756ac61947e4192e52f296c38c8c3a9d1a8f8605ff4b6762cb8f3ca2d533af", 9952, "LGPL-3.0-or-later", false],
    ["libheif-openjpeg", "libheif-openjpeg-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-openjpeg-1.23.7-r0.apk", "8f4166885022a4255c5ee0f821d7fb5ecf3c3204a5ee6d2a0df0f1951c45d05b", 14229, "LGPL-3.0-or-later", false],
    ["libheif-rav1e", "libheif-rav1e-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-rav1e-1.23.7-r0.apk", "ca0ad590e7f706f210b25b3209946400168fb591c78e63daca5d61c814da2b27", 12990, "LGPL-3.0-or-later", false],
    ["libheif-svtenc", "libheif-svtenc-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-svtenc-1.23.7-r0.apk", "7909a61e6268a9d6f4ea6afa6e463c06f31f91d4267c5f4ec7a95552509cc358", 12502, "LGPL-3.0-or-later", false],
    ["libheif-x264", "libheif-x264-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-x264-1.23.7-r0.apk", "36e03b6f94df8e62c73b30a93ac1dec6f5600ad8c141e3fa2bdf247de68e8e67", 16999, "LGPL-3.0-or-later", false],
    ["libheif-x265", "libheif-x265-1.23.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libheif-x265-1.23.7-r0.apk", "a3880538056b3e77f717e4ff8e09531d946697a2a07537613a4553d17af3258c", 21765, "LGPL-3.0-or-later", false],
    ["libid3tag", "libid3tag-0.16.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libid3tag-0.16.3-r0.apk", "ce406d44edcf4b79612c857426001e240bbed55f0f1a84e84a96336f459f67f5", 28658, "GPL-2.0-or-later", false],
    ["libimobiledevice", "libimobiledevice-1.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libimobiledevice-1.4.0-r0.apk", "5278abdb15c04aea5dc43a486cdb49fdaf1bd52a00b48c55ed1cc7719d7f227f", 124534, "LGPL-2.1-or-later", false],
    ["libimobiledevice-glue", "libimobiledevice-glue-1.3.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libimobiledevice-glue-1.3.2-r0.apk", "53a0871f03a95917a4162a39a65048aff114751c6126c2f3c07a5b57af1589b4", 28521, "LGPL-2.1-or-later", false],
    ["libkscreen", "libkscreen-6.6.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libkscreen-6.6.6-r0.apk", "b35e71e9ccf0bb1047bbaa49f9cb17bd545c3ffabc33a5b5133e06bbeefd44a1", 434230, "LGPL-2.1-or-later AND GPL-2.0-or-later AND (GPL-2.0-only OR GPL-3.0-only)", false],
    ["libmtp", "libmtp-1.1.22-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libmtp-1.1.22-r1.apk", "df53345660f2bbd57dc42722014212a3fb9887f8144f50db044a7d1508eaeb1b", 153424, "LGPL-2.0-or-later", false],
    ["libmtp-udev", "libmtp-udev-1.1.22-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libmtp-udev-1.1.22-r1.apk", "7ef26f462f14b2bc601e62b0ddd28c2fe2bdb30d6a8496929e390aedb62c0e4b", 21890, "LGPL-2.0-or-later", false],
    ["libnfs", "libnfs-5.0.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libnfs-5.0.3-r0.apk", "7afcc3200b98f7e7a62320bd5eb8040de3414c38adfa1aef83c948a8e60ddc23", 115598, "LGPL-2.1-or-later", false],
    ["libnvme", "libnvme-1.16.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libnvme-1.16.2-r0.apk", "eb814f96bc7cf1c16a6fdccad6c5d8cbd6eb8fd57b59a4cebcf566302679cc83", 68426, "LGPL-2.1-or-later", false],
    ["libplist", "libplist-2.7.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libplist-2.7.0-r1.apk", "b553848a6e47d9f69d895c493bf8ee1048a30a67ec6856f6103a6f3addeab10f", 44692, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["libsmbclient", "libsmbclient-4.23.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libsmbclient-4.23.8-r0.apk", "7ac10e1712e20c55773e5ef5dff19ac7d3ec40d0575b01d6b32da15d9babb36e", 62246, "GPL-3.0-or-later AND LGPL-3.0-or-later", false],
    ["libstatgrab", "libstatgrab-0.92.1-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libstatgrab-0.92.1-r1.apk", "3adcb347441d8481d7b47ff2deb824c7ef10e0da156331f5cd1d41eaba7ae2ab", 44178, "LGPL-2.0-or-later", false],
    ["libsysstat", "libsysstat-1.1.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libsysstat-1.1.0-r2.apk", "7f918975c4627813a96d66980bc82acef7bcb2de4353b89cea6b59dac7463fd0", 30036, "LGPL-2.1-or-later", false],
    ["libusbmuxd", "libusbmuxd-2.1.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libusbmuxd-2.1.1-r0.apk", "154358a76d778124035922067bd7939c92f80e8fee4403ce46e1b569864eacea", 14207, "LGPL-2.1-or-later", false],
    ["libverto", "libverto-0.3.2-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libverto-0.3.2-r2.apk", "c20d2d8db18fe088c14cf00efa3780c81ff13f0663525df85d25ad44d415cdf5", 9283, "MIT", false],
    ["libwbclient", "libwbclient-4.23.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libwbclient-4.23.8-r0.apk", "854fd838444375fe6b87ba06cfa097315de0dcaaac7354b20eab670ec651428b", 29661, "GPL-3.0-or-later AND LGPL-3.0-or-later", false],
    ["libxau-dev", "libxau-dev-1.0.12-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libxau-dev-1.0.12-r0.apk", "3c5923a390aa2140fd1bc40d06fa744e9a300d95649ffb2da6a306f477aeecf3", 3797, "MIT", false],
    ["libxcb-dev", "libxcb-dev-1.17.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libxcb-dev-1.17.0-r2.apk", "6658de0d8836c0e60744edf4e315bf006cd18d24f0539e58b3f70e2eae0b93c7", 193968, "MIT", false],
    ["libxdmcp-dev", "libxdmcp-dev-1.1.5-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libxdmcp-dev-1.1.5-r1.apk", "fe5105753cd02434813aa2ff0502024340ad6094dc858b42f6a88c6e2f13f1e4", 12040, "MIT", false],
    ["lm-sensors-libs", "lm-sensors-libs-3.6.0-r5.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/lm-sensors-libs-3.6.0-r5.apk", "6d0bf5b4e84232132afd4088ef749a84bf1bbdbca559604107e5695f9fc7c810", 20999, "LGPL-2.1-or-later AND GPL-2.0-or-later", false],
    ["lmdb", "lmdb-0.9.35-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/lmdb-0.9.35-r0.apk", "90aba5a62cd665329ccc6521f051351b4dd6486fda6f360d02fc7eac0320027a", 49670, "OLDAP-2.8", false],
    ["lxqt-about", "lxqt-about-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-about-2.4.0-r0.apk", "cbd7233daabbc9ab1b9656c935cf2366c7ef62bf311e625b84414dcbe7397f39", 59218, "LGPL-2.0-or-later", false],
    ["lxqt-admin", "lxqt-admin-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-admin-2.4.0-r0.apk", "4ef733a803d52eddda71a20250e1757aab0c13da77ceb095356f16b72bce5fdf", 86039, "LGPL-2.0-or-later", false],
    ["lxqt-config", "lxqt-config-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-config-2.4.0-r0.apk", "1bb71d70b13380ce4816454043dd9268002bdaf54633490a90e5bd0e9e9fbb5b", 834589, "LGPL-2.0-or-later", false],
    ["lxqt-desktop", "lxqt-desktop-2.3.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-desktop-2.3.0-r0.apk", "1a35b026b3c9a4235069fe86e0979daa4c886a9e27a9d9a9831cc395eaa1f700", 1482, "GPL-3.0-or-later", false],
    ["lxqt-globalkeys", "lxqt-globalkeys-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-globalkeys-2.4.0-r0.apk", "f8d5eb9f2305e19466e4c05d701a98cc090a0424096b5c5de6e52e37d25e887f", 345995, "LGPL-2.0-or-later", false],
    ["lxqt-notificationd", "lxqt-notificationd-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-notificationd-2.4.0-r0.apk", "517212a391c253a220f6f72ac4671b6fa21efb4aad7a76a71615edcf87c6f6c2", 123302, "LGPL-2.0-or-later", false],
    ["lxqt-openssh-askpass", "lxqt-openssh-askpass-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-openssh-askpass-2.4.0-r0.apk", "b2f3e80d749881ffec1e42b8e1de769abccb04a7fe733845163d55709960bc5f", 8907, "LGPL-2.0-or-later", false],
    ["lxqt-panel", "lxqt-panel-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-panel-2.4.0-r0.apk", "3e4e7f76d267bba05f01f8336d7b86dae9aa4eb5593f6fdee36865b1bfc51b71", 1315711, "LGPL-2.0-or-later", false],
    ["lxqt-policykit", "lxqt-policykit-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-policykit-2.4.0-r0.apk", "378a0a7004f8429840ab628918d7a5594560f65ecdcbb06329c8a922d2dc9360", 20166, "LGPL-2.0-or-later", false],
    ["lxqt-powermanagement", "lxqt-powermanagement-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-powermanagement-2.4.0-r0.apk", "d258b314b9c20dd45b07d460d60305db24b5c7e9a16681f2b6bc3a3c910970a2", 193740, "LGPL-2.0-or-later", false],
    ["lxqt-qtplugin", "lxqt-qtplugin-2.4.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-qtplugin-2.4.0-r1.apk", "29cdc8bee553289075819ecad1ea792fbab39043868ec04673dada46329e30f2", 50890, "LGPL-2.0-or-later", false],
    ["lxqt-runner", "lxqt-runner-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-runner-2.4.0-r0.apk", "41455385f961aa2cc58393f70a79f2d62be81581b51cad7091dd81d36debe69f", 235618, "LGPL-2.0-or-later", false],
    ["lxqt-session", "lxqt-session-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-session-2.4.0-r0.apk", "895b9d9313308c3f85b9a196fd5565a6d6a06fca42422fb9c6d80fc6ff749b0f", 223465, "LGPL-2.0-or-later", false],
    ["lxqt-sudo", "lxqt-sudo-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-sudo-2.4.0-r0.apk", "37caaafdd20a565d9d869128c721dbd04c666f726f41b9dac28b61579de8d5cc", 24248, "LGPL-2.0-or-later", false],
    ["lxqt-themes", "lxqt-themes-2.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/lxqt-themes-2.4.0-r0.apk", "311e6d83692bf3fcaf52dbc2402a8ccd0b60a90669ad2f587316f16c303b84d4", 27421975, "LGPL-2.0-or-later", false],
    ["msgraph", "msgraph-0.3.4-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/msgraph-0.3.4-r0.apk", "0507e6b316a81f93b0c468903a59302a513001b7c182f2e40fbc7daa240a4e56", 41183, "LGPL-3.0-or-later", false],
    ["muparser", "muparser-2.3.4-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/muparser-2.3.4-r1.apk", "33ad17349010363f65e8c9da9614bc600526e38628f83651f8720ca72c970954", 200592, "BSD-2-Clause", false],
    ["ndctl-libs", "ndctl-libs-80-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/ndctl-libs-80-r1.apk", "0a7c9ee5706a6d85b0dda34ed69470d3ae70ecf4b207d10375cee8885ef282d7", 111544, "GPL-2.0-only AND LGPL-2.1-only", false],
    ["openbox", "openbox-3.6.1-r8.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/openbox-3.6.1-r8.apk", "e641f941b0118fc14421c0ac9eb5666ca591b08ebac7f7efe89596aa5c5f61cc", 184230, "GPL-2.0-or-later", false],
    ["openbox-libs", "openbox-libs-3.6.1-r8.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/openbox-libs-3.6.1-r8.apk", "c5545b5e50fe916320fd370b2a5c3bc8f34a42c4ff5787b536015470be30698d", 61728, "GPL-2.0-or-later", false],
    ["parted", "parted-3.7-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/parted-3.7-r0.apk", "d9a78e55ee652efef4ecdbeb5b55332f7724a86dad9673e5b64ff802106825c7", 224988, "GPL-3.0-or-later", false],
    ["picom", "picom-13-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/picom-13-r0.apk", "a2b77017dfaded16f9a7efbbe5d6ddc8a6ae009c658d0c57be3a6d1a05648b64", 239038, "MIT AND MPL-2.0", false],
    ["pixman-dev", "pixman-dev-0.46.4-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/pixman-dev-0.46.4-r0.apk", "2edda1c89519506bf5072552eb74aca859980aa3047aa7c53a6205d077ba7575", 12158, "MIT", false],
    ["pm-utils", "pm-utils-1.4.1-r5.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/pm-utils-1.4.1-r5.apk", "7ef6a109f393c11381d8b05d4b607ed172322b8cf9119e430b9f9a686d4f9046", 33010, "GPL-2.0-only", false],
    ["polkit-qt6", "polkit-qt6-0.201.1-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/polkit-qt6-0.201.1-r1.apk", "b71dd794b0d60b6965bd9ddc72d38deacc786c8c6cad7d7e07eac4c073ff4f9b", 83570, "LGPL-2.1-only", false],
    ["popt", "popt-1.19-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/popt-1.19-r4.apk", "b9963bde5e192348f291e7c16f033435debc6f171365ee5483a22afeffaa3f46", 21154, "MIT", false],
    ["qt6-qtwayland", "qt6-qtwayland-6.11.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/qt6-qtwayland-6.11.1-r0.apk", "1e28d146293ecd4193a5df51332f06841363d8fec6a5dda4107101563d6ed6fb", 872377, "LGPL-2.1-only AND LGPL-3.0-only AND GPL-3.0-only AND Qt-GPL-exception-1.0", false],
    ["rest1", "rest1-0.9.1-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/rest1-0.9.1-r1.apk", "ed91d10a271f1bb62209d05dae0b7fb70446079e8bb80cc332f0802457af3586", 50166, "LGPL-2.0-or-later", false],
    ["samba-client-libs", "samba-client-libs-4.23.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/samba-client-libs-4.23.8-r0.apk", "9d7c9500dff02a89652027d947f70efd1ad38d182b1524d4e4e29b0f99f4865c", 385792, "GPL-3.0-or-later AND LGPL-3.0-or-later", false],
    ["samba-libs", "samba-libs-4.23.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/samba-libs-4.23.8-r0.apk", "657f6560515bbbe703461bcd83219a1f5f9996e259ca5701a6a3e323e01c4461", 6102224, "GPL-3.0-or-later AND LGPL-3.0-or-later", false],
    ["samba-util-libs", "samba-util-libs-4.23.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/samba-util-libs-4.23.8-r0.apk", "b940b60e07a2119fe91a941ec70a5eeccfe669aaaf7e4fbc307a2af8df7b0c49", 364292, "GPL-3.0-or-later AND LGPL-3.0-or-later", false],
    ["setxkbmap", "setxkbmap-1.3.5-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/setxkbmap-1.3.5-r0.apk", "435315fb1950be93493f5e95b61cf8617903ebc864e64fd2f06e0ebd30fc0446", 9762, "MIT", false],
    ["solid-libs", "solid-libs-6.26.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/solid-libs-6.26.0-r0.apk", "bddd68a016e1abaf5f425a7083e4e1e2bd045b01791347aefbf945e4c9c1294e", 443626, "LGPL-2.1-only OR LGPL-3.0-only", false],
    ["talloc", "talloc-2.4.4-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/talloc-2.4.4-r1.apk", "56004bfdd152fed426328f8a0870cad3e4e4fc99f3bbeb8c56c2e54d63c762d2", 18217, "LGPL-3.0-or-later", false],
    ["tevent", "tevent-0.17.1-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/tevent-0.17.1-r1.apk", "f92633775d11a22dc55517dff9671deff28687e83588234d1c1f21d1aead1cce", 33004, "LGPL-3.0-or-later", false],
    ["udisks2", "udisks2-2.11.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/udisks2-2.11.0-r2.apk", "92882f1c4ded9f9f76dd200db2365611ef4003742ab8c396fc3a1aeeeae31c1c", 653915, "GPL-2.0-or-later", true],
    ["udisks2-bash-completion", "udisks2-bash-completion-2.11.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/udisks2-bash-completion-2.11.0-r2.apk", "ab42b0304cd7534c088b7e7e5d87c66f18f87c63942156adacb547bfb3e9d3c3", 2028, "GPL-2.0-or-later", false],
    ["udisks2-libs", "udisks2-libs-2.11.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/udisks2-libs-2.11.0-r2.apk", "52a7c2e1ec1e38f723127bfcf336331c5bf6809d3dd35910cd4c95d0ea743b72", 228026, "GPL-2.0-or-later", false],
    ["udisks2-openrc", "udisks2-openrc-2.11.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/udisks2-openrc-2.11.0-r2.apk", "320013783a87c220cc777b183a8e39cc8cde19f017f5a5034b352f8d6b34ac7e", 1714, "GPL-2.0-or-later", false],
    ["volume_key", "volume_key-0.3.12-r9.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/volume_key-0.3.12-r9.apk", "d8b38e3b14894e306efe4d1fa60a879f35e291884d14d91216f20e28f3b73df6", 153212, "GPL-2.0-or-later", false],
    ["wayland-libs-server", "wayland-libs-server-1.25.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/wayland-libs-server-1.25.0-r0.apk", "044d9f2386d312ae6431599b733e2f8118325b5936844f7b4174e9140fa33d16", 30577, "MIT", false],
    ["xcb-proto", "xcb-proto-1.17.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/xcb-proto-1.17.0-r1.apk", "4cfcc8a35ed2d8528661efe1a530f4e2447eac72901df19776ae0a4ea9b4a80e", 119714, "MIT", false],
    ["xcb-proto-pyc", "xcb-proto-pyc-1.17.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/xcb-proto-pyc-1.17.0-r1.apk", "cf93d32d9ef93e33a9c004549f570992726449fe383dacc88596edc4db86562f", 84231, "MIT", false],
    ["xdg-desktop-portal", "xdg-desktop-portal-1.21.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xdg-desktop-portal-1.21.2-r0.apk", "669b87672be7367447f3d620ab67878c48bf3fc82e217640b32a159bbdf13bc4", 333138, "LGPL-2.1-or-later", false],
    ["xdg-desktop-portal-lxqt", "xdg-desktop-portal-lxqt-1.4.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xdg-desktop-portal-lxqt-1.4.0-r0.apk", "9bc1b9032d384670e4e40e03b4a9765c42ef34fced5e987af1168f0de78e2a85", 54022, "LGPL-2.1-or-later", false],
    ["xdg-desktop-portal-openrc", "xdg-desktop-portal-openrc-1.21.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xdg-desktop-portal-openrc-1.21.2-r0.apk", "5c35a867f0facdd81c6fd330f4fa553a2a0105f2feae20624997b5a37ff0c1a7", 1846, "LGPL-2.1-or-later", false],
    ["xdg-document-portal", "xdg-document-portal-1.21.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xdg-document-portal-1.21.2-r0.apk", "5c5b76725f7832fd99ae1ddf8793af3f594ce297b7b94795a97e8c7f23464c42", 76372, "LGPL-2.1-or-later", false],
    ["xdg-document-portal-openrc", "xdg-document-portal-openrc-1.21.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xdg-document-portal-openrc-1.21.2-r0.apk", "a9dfbfb03ae397cd1a7601761a6769d7b533599a73617e6727a367c8fa07616e", 1787, "LGPL-2.1-or-later", false],
    ["xdg-user-dirs", "xdg-user-dirs-0.20-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xdg-user-dirs-0.20-r0.apk", "88dc8038fbf8b8d02d25ce75e77d152cda6d74a85e1d596f8a57c988ab72613e", 11773, "MIT AND GPL-2.0-only", false],
    ["xorgproto", "xorgproto-2025.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/xorgproto-2025.1-r0.apk", "8e43324c60aa227a1a335aef357dc2c0c26afcc536952f992b4a32293d230d76", 335462, "BSD-2-Clause AND MIT AND X11", false],
    ["xrandr", "xrandr-1.5.4-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xrandr-1.5.4-r0.apk", "4f8d9302be2d7587b3b6c1f1fa967d618dc2aeee8b9081875f2d1cc1d4959b8d", 26438, "MIT", false],
    ["xscreensaver", "xscreensaver-6.15-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/xscreensaver-6.15-r0.apk", "6e2e65d1f4d87c739bc28b64c0956a61a68f425d1931d8997d9fc1d3d5991b22", 389080, "GPL-2.0-or-later GPL-3.0-or-later 0BSD MIT", false],
];
// END GENERATED PINS musl

// BEGIN GENERATED OS FACTS glibc
// Written by `cargo xtask base groups levitate` from distro/variants/levitate/distro.toml
// (identity, profile, look); do not edit.
const RPM_OS = #{
    id: "levitateos",
    name: "LevitateOS",
    home_url: "https://levitateos.org",
    desktop: "plasma",
    appearance: "dark",
    light: #{
        surface: "#DDE2D2",
        surface_raised: "#E8ECDF",
        surface_sunken: "#CFD6C3",
        text: "#14221A",
        text_secondary: "#465047",
        text_muted: "#5C6459",
        rule: "#AEB8A4",
        hairline: "#C6CDB9",
        accent: "#214438",
        highlight: "#644532",
        band: "#214438",
        on_band: "#F2EEE4",
        ok: "#2F6B3F",
        warn: "#7F5200",
        bad: "#B22F27",
    },
    dark: #{
        surface: "#14221A",
        surface_raised: "#1D2D24",
        surface_sunken: "#0D1711",
        text: "#F2EEE4",
        text_secondary: "#BAC5B7",
        text_muted: "#9AA89D",
        rule: "#3A4B40",
        hairline: "#2A3B31",
        accent: "#C7D9BA",
        highlight: "#E4CBA6",
        band: "#214438",
        on_band: "#F2EEE4",
        ok: "#A9CF9A",
        warn: "#F0B866",
        bad: "#F0A497",
    },
};
// END GENERATED OS FACTS glibc

// BEGIN GENERATED OS FACTS musl
// Written by `cargo xtask base groups acorn` from distro/variants/acorn/distro.toml
// (identity, profile, look); do not edit.
const APK_OS = #{
    id: "acornos",
    name: "AcornOS",
    home_url: "",
    desktop: "lxqt",
    appearance: "dark",
    light: #{
        surface: "#E6DFCF",
        surface_raised: "#EFE9DB",
        surface_sunken: "#D9D1BE",
        text: "#241A12",
        text_secondary: "#54483C",
        text_muted: "#6B5D4F",
        rule: "#C2B8A2",
        hairline: "#D0C7B3",
        accent: "#644532",
        highlight: "#214438",
        band: "#644532",
        on_band: "#F2EEE4",
        ok: "#2F6B3F",
        warn: "#7F5200",
        bad: "#B22F27",
    },
    dark: #{
        surface: "#1F1711",
        surface_raised: "#2B2019",
        surface_sunken: "#150F0A",
        text: "#F2EEE4",
        text_secondary: "#CDBFAE",
        text_muted: "#A89886",
        rule: "#4D3D30",
        hairline: "#382B21",
        accent: "#E4CBA6",
        highlight: "#C7D9BA",
        band: "#644532",
        on_band: "#F2EEE4",
        ok: "#A9CF9A",
        warn: "#F0B866",
        bad: "#F0A497",
    },
};
// END GENERATED OS FACTS musl

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

// ---------------------------------------------------------------------------
// The look, as the OS builder computed it (installed-system.rhai): the colour
// schemes and settings derived from the OS's palettes (ctx.os, the generated
// OS facts). Kept the same as the builder's functions.
// ---------------------------------------------------------------------------

// Mode `mode`'s palette: role -> "#RRGGBB".
fn palette(os, mode) {
    let p = os[mode];
    if type_of(p) != "map" { throw "the OS facts have no " + mode + " palette"; }
    p
}
// The palette roles (distro_contract::Palette).
fn palette_roles() {
    ["surface", "surface_raised", "surface_sunken", "text", "text_secondary", "text_muted", "rule", "hairline",
     "accent", "highlight", "band", "on_band", "ok", "warn", "bad"]
}
// "#RRGGBB" as [r, g, b].
fn rgb(hex) { [parse_int(hex.sub_string(1, 2), 16), parse_int(hex.sub_string(3, 2), 16), parse_int(hex.sub_string(5, 2), 16)] }

// A palette's colours as [r, g, b] (0-255).
fn rgb_palette(p) {
    let out = #{};
    for role in palette_roles() {
        out[role] = rgb(p[role]);
    }
    out
}
// `a` moved towards `b` by `t` (0.0 to 1.0); both [r, g, b].
fn mix(a, b, t) {
    let out = [];
    for i in 0..3 { out.push((a[i].to_float() * (1.0 - t) + b[i].to_float() * t).round().to_int()); }
    out
}
// "r,g,b", as KDE and Konsole write a colour.
fn kde(c) { "" + c[0] + "," + c[1] + "," + c[2] }
// Whether a colour is dark (relative luminance under one half).
fn is_dark(c) {
    (0.2126 * c[0].to_float() + 0.7152 * c[1].to_float() + 0.0722 * c[2].to_float()) / 255.0 < 0.5
}
// The palette (as [r, g, b]) whose accent and status colours read on `bg`:
// the dark mode's on a dark background, the light mode's on a light one.
fn palette_on(os, bg) {
    let mode = if is_dark(bg) { "dark" } else { "light" };
    rgb_palette(palette(os, mode))
}
// The icon theme of the mode (Breeze on both desktops).
fn icon_theme(mode) { if mode == "dark" { "breeze-dark" } else { "breeze" } }
// The colour schemes' name for mode `mode`: the OS's name and the mode
// ("LevitateOSLight"), the name of a KDE colour scheme and of a terminal scheme.
fn scheme_name(os, mode) {
    let name = os.name.replace(" ", "");
    name + (if mode == "dark" { "Dark" } else { "Light" })
}

// `text` (an INI file) with `key` in `section` set to `value`: the line
// replaced where the key is there, added at the end of the section where it
// is not, and the section added at the end where the file lacks it.
fn ini_set(text, section, key, value) {
    if text.ends_with("\n") { text = text.sub_string(0, text.len() - 1); }
    let out = "";
    let current = "";
    let seen = false;
    let done = false;
    for line in text.split("\n") {
        let t = trim(line);
        if t.starts_with("[") && t.ends_with("]") {
            if current == section && !done { out += key + "=" + value + "\n"; done = true; }
            current = t.sub_string(1, t.len() - 2);
            if current == section { seen = true; }
        } else if current == section && t.starts_with(key + "=") {
            if !done { out += key + "=" + value + "\n"; done = true; }
            continue;
        }
        out += line + "\n";
    }
    if !done {
        if !seen { out += "\n[" + section + "]\n"; }
        out += key + "=" + value + "\n";
    }
    out
}

// One group of a KDE colour scheme: backgrounds `bg` and `alt`, text `fg`,
// `inactive` text, the `active`, link and focus colour `active`, `visited`
// links, and `status`'s ok, warn and bad as positive, neutral and negative.
fn kde_group(name, bg, alt, fg, inactive, active, visited, status) {
    let t = "[" + name + "]\n";
    t += "BackgroundAlternate=" + kde(alt) + "\nBackgroundNormal=" + kde(bg) + "\n";
    t += "DecorationFocus=" + kde(active) + "\nDecorationHover=" + kde(active) + "\n";
    t += "ForegroundActive=" + kde(active) + "\nForegroundInactive=" + kde(inactive) + "\n";
    t += "ForegroundLink=" + kde(active) + "\nForegroundNegative=" + kde(status.bad) + "\n";
    t += "ForegroundNeutral=" + kde(status.warn) + "\nForegroundNormal=" + kde(fg) + "\n";
    t += "ForegroundPositive=" + kde(status.ok) + "\nForegroundVisited=" + kde(visited) + "\n\n";
    t
}
// The colour groups of mode `mode`'s KDE colour scheme, from its palette:
// window surface, views raised with sunken alternate rows, the accent for
// selection (with surface text), focus, hover and links, the highlight for
// visited links, ok/warn/bad for positive/neutral/negative, and the band
// (with on_band text) for headers, title bars and the complementary areas
// (login and lock screens, OSDs). The effects are Breeze's.
fn kde_colour_groups(os, mode) {
    let p = rgb_palette(palette(os, mode));
    let s = palette_on(os, p.accent);
    let b = palette_on(os, p.band);
    let t = "[ColorEffects:Disabled]\nColor=56,56,56\nColorAmount=0\nColorEffect=0\nContrastAmount=0.65\nContrastEffect=1\nIntensityAmount=0.1\nIntensityEffect=2\n\n";
    t += "[ColorEffects:Inactive]\nChangeSelectionColor=true\nColor=112,111,110\nColorAmount=0.025\nColorEffect=2\nContrastAmount=0.1\nContrastEffect=2\nEnable=false\nIntensityAmount=0\nIntensityEffect=0\n\n";
    t += kde_group("Colors:Button", p.surface_raised, mix(p.surface_raised, p.accent, 0.25), p.text, p.text_muted, p.accent, p.highlight, p);
    t += kde_group("Colors:Complementary", p.band, mix(p.band, p.on_band, 0.1), p.on_band, mix(p.on_band, p.band, 0.35), b.accent, b.highlight, b);
    t += kde_group("Colors:Header", p.band, mix(p.band, p.on_band, 0.1), p.on_band, mix(p.on_band, p.band, 0.35), b.accent, b.highlight, b);
    t += kde_group("Colors:Header][Inactive", p.surface, p.surface_sunken, p.text, p.text_muted, p.accent, p.highlight, p);
    t += kde_group("Colors:Selection", p.accent, mix(p.accent, p.surface, 0.5), p.surface, mix(p.surface, p.accent, 0.3), p.surface, p.surface, s);
    t += kde_group("Colors:Tooltip", p.surface_raised, p.surface, p.text, p.text_muted, p.accent, p.highlight, p);
    t += kde_group("Colors:View", p.surface_raised, p.surface_sunken, p.text, p.text_muted, p.accent, p.highlight, p);
    t += kde_group("Colors:Window", p.surface, p.surface_sunken, p.text, p.text_muted, p.accent, p.highlight, p);
    t += "[WM]\nactiveBackground=" + kde(p.band) + "\nactiveBlend=" + kde(p.band) + "\nactiveForeground=" + kde(p.on_band) + "\n";
    t += "inactiveBackground=" + kde(p.surface_sunken) + "\ninactiveBlend=" + kde(p.surface_sunken) + "\ninactiveForeground=" + kde(p.text_muted) + "\n\n";
    t
}
// Mode `mode`'s whole KDE colour scheme file.
fn kde_colour_scheme(os, mode) {
    let t = kde_colour_groups(os, mode);
    t += "[General]\nColorScheme=" + scheme_name(os, mode) + "\nName=" + os.name + (if mode == "dark" { " Dark" } else { " Light" }) + "\nshadeSortColumn=true\n\n";
    t += "[KDE]\ncontrast=4\n";
    t
}

// The terminal's blue, magenta and cyan for mode `mode` (the same on both
// distros): the look palette has no such hues, and its accent and highlight
// sit too close to green and yellow to tell apart in `ls`, diffs and
// compiler output.
fn terminal_hues(mode) {
    if mode == "dark" { #{ blue: "#9BB8D9", magenta: "#D4A5C9", cyan: "#9ACFC4" } }
    else { #{ blue: "#2A5C8A", magenta: "#7A3F6E", cyan: "#1F6F6B" } }
}

// Mode `mode`'s terminal colour scheme (Konsole's and QTermWidget's format):
// the palette's surface behind its text, and a 16-colour set at least 3:1 on
// that surface: black the text on light (on dark, the muted text dimmed
// towards the surface, which still reads), bright black the muted text,
// white the secondary text and bright white the text; red, green, yellow
// bad, ok, warn; blue, magenta, cyan terminal_hues. Bright colours lean
// towards the text, faint ones towards the surface.
fn terminal_scheme(os, mode) {
    let p = rgb_palette(palette(os, mode));
    let hues = terminal_hues(mode);
    let blue = rgb(hues.blue);
    let magenta = rgb(hues.magenta);
    let cyan = rgb(hues.cyan);
    let black = if mode == "dark" { mix(p.text_muted, p.surface, 0.35) } else { p.text };
    let colours = [
        [black, p.text_muted],
        [p.bad, mix(p.bad, p.text, 0.25)],
        [p.ok, mix(p.ok, p.text, 0.25)],
        [p.warn, mix(p.warn, p.text, 0.25)],
        [blue, mix(blue, p.text, 0.25)],
        [magenta, mix(magenta, p.text, 0.25)],
        [cyan, mix(cyan, p.text, 0.25)],
        [p.text_secondary, p.text],
    ];
    let t = "[Background]\nColor=" + kde(p.surface) + "\n\n[BackgroundFaint]\nColor=" + kde(p.surface) + "\n\n[BackgroundIntense]\nColor=" + kde(p.surface) + "\n\n";
    for i in 0..8 {
        let c = colours[i];
        t += "[Color" + i + "]\nColor=" + kde(c[0]) + "\n\n";
        t += "[Color" + i + "Faint]\nColor=" + kde(mix(c[0], p.surface, 0.5)) + "\n\n";
        t += "[Color" + i + "Intense]\nColor=" + kde(c[1]) + "\n\n";
    }
    t += "[Foreground]\nColor=" + kde(p.text) + "\n\n[ForegroundFaint]\nColor=" + kde(p.text_secondary) + "\n\n[ForegroundIntense]\nColor=" + kde(p.text) + "\n\n";
    t += "[General]\nBlur=false\nColorRandomization=false\nDescription=" + os.name + (if mode == "dark" { " Dark" } else { " Light" }) + "\nOpacity=1\nWallpaper=\n";
    t
}


// The system-wide default applications (/etc/xdg/mimeapps.list) for the
// kinds of file `apps` names (#{kind: desktop entry}).
fn mimeapps(apps) {
    let kinds = #{
        browser: ["x-scheme-handler/http", "x-scheme-handler/https", "text/html", "application/xhtml+xml"],
        files: ["inode/directory"],
        text: ["text/plain"],
        image: ["image/png", "image/jpeg", "image/gif", "image/webp", "image/svg+xml", "image/bmp", "image/tiff"],
        pdf: ["application/pdf"],
        archive: ["application/zip", "application/x-tar", "application/gzip", "application/x-compressed-tar",
                  "application/x-xz-compressed-tar", "application/x-zstd-compressed-tar",
                  "application/x-bzip2-compressed-tar", "application/x-7z-compressed", "application/vnd.rar"]
    };
    let text = "[Default Applications]\n";
    for kind in kinds.keys() {
        let app = apps[kind];
        if type_of(app) == "()" { continue; }
        for mime in kinds[kind] { text += mime + "=" + app + ";\n"; }
    }
    text
}
// What a user at the machine (an active local session) may do without the
// administrator's password beyond the packages' defaults: set the time zone,
// and save a network for every user. In usr/share/polkit-1/rules.d: the
// /etc one is polkit's own directory (root:polkitd 0750), which a group
// that does not hold polkit cannot also own.
fn desktop_polkit_rules() {
    let rules = "// The desktop system (installed-system.rhai): what a user at the machine does without the administrator's password.\n";
    rules += "polkit.addRule(function(action, subject) {\n    if (subject.active && subject.local &&\n";
    rules += "            (action.id == \"org.freedesktop.timedate1.set-timezone\" ||\n";
    rules += "             action.id == \"org.freedesktop.NetworkManager.settings.modify.system\")) {\n";
    rules += "        return polkit.Result.YES;\n    }\n});\n";
    rules
}

// What the OS builder's desktop policy did for LXQt, moved here so it goes
// with LXQt: the default applications, the look (LXQt's theme of the
// starting mode with the OS's palette, Breeze icons, Fusion widgets, GTK in
// Adwaita, Openbox's decoration for the mode, the Adwaita cursor), the OS's
// mark on the menu button, touchpads that tap and scroll naturally, menu
// entries that do nothing useful here hidden (Hibernate, the bare
// XScreenSaver daemon), and what a user at the machine may do without the
// administrator's password. The mark is the base's file (the image's
// branding); this only points at it.
ctx.os = APK_OS;
fn configure(ctx) {
    let os = ctx.os;
    let mode = os.appearance;
    let p = palette(os, mode);
    let apps = #{ browser: "firefox.desktop", files: "pcmanfm-qt.desktop", image: "lximage-qt.desktop",
                  pdf: "firefox.desktop", archive: "lxqt-archiver.desktop" };
    put(ctx, "etc/xdg/mimeapps.list", mimeapps(apps), 0o644);

    let cursor = "Adwaita";
    if !is_dir(join_path(ctx.system, "usr/share/icons/" + cursor + "/cursors")) { throw "lxqt: the packages lack the cursor theme " + cursor; }
    put(ctx, "usr/share/icons/default/index.theme", "[Icon Theme]\nInherits=" + cursor + "\n", 0o644);
    if !is_dir(join_path(ctx.system, "usr/share/lxqt/themes/" + mode)) { throw "lxqt: the packages lack the LXQt theme " + mode; }
    let conf = tree_text(ctx, "usr/share/lxqt/lxqt.conf");
    conf = ini_set(conf, "General", "theme", mode);
    conf = ini_set(conf, "General", "icon_theme", icon_theme(mode));
    conf = ini_set(conf, "Qt", "style", "Fusion");
    for pair in [["window_color", p.surface], ["window_text_color", p.text], ["base_color", p.surface_raised],
                 ["text_color", p.text], ["highlight_color", p.accent], ["highlighted_text_color", p.surface],
                 ["link_color", p.accent], ["link_visited_color", p.highlight],
                 ["tooltip_base_color", p.surface_raised], ["tooltip_text_color", p.text]] {
        conf = ini_set(conf, "Palette", pair[0], pair[1]);
    }
    put(ctx, "etc/xdg/lxqt/lxqt.conf", conf, 0o644);
    let gtk = "[Settings]\ngtk-theme-name=Adwaita\ngtk-icon-theme-name=" + icon_theme(mode) + "\ngtk-cursor-theme-name=" + cursor + "\ngtk-font-name=Sans 11\n";
    gtk += "gtk-application-prefer-dark-theme=" + (if mode == "dark" { "true" } else { "false" }) + "\n";
    put(ctx, "etc/gtk-3.0/settings.ini", gtk, 0o644);
    put(ctx, "etc/gtk-4.0/settings.ini", gtk, 0o644);
    let decoration = if mode == "dark" { "Onyx" } else { "Clearlooks" };
    tree_text(ctx, "usr/share/themes/" + decoration + "/openbox-3/themerc");
    let rc = "etc/xdg/openbox/rc.xml";
    let xml = tree_text(ctx, rc);
    let theme = xml.index_of("<theme>");
    let open = if theme < 0 { -1 } else { xml.index_of("<name>", theme) };
    let close = if open < 0 { -1 } else { xml.index_of("</name>", open) };
    if close < 0 { throw "lxqt: Openbox's settings name no theme"; }
    put(ctx, rc, xml.sub_string(0, open + 6) + decoration + xml.sub_string(close), 0o644);

    // The OS's mark on the menu button.
    let icon = "usr/share/icons/hicolor/scalable/apps/distributor-logo-" + os.id + ".svg";
    let panel = "etc/xdg/lxqt/panel.conf";
    let text = tree_text(ctx, panel);
    if !text.contains("[fancymenu]\n") { throw "lxqt: the panel's settings have no fancymenu button"; }
    put(ctx, panel, text.replace("[fancymenu]\n", "[fancymenu]\nownIcon=true\nicon=/" + icon + "\n"), 0o644);

    for name in ["lxqt-hibernate.desktop", "xscreensaver.desktop"] {
        let path = "usr/share/applications/" + name;
        let entry = tree_text(ctx, path);
        if !entry.contains("[Desktop Entry]\n") || entry.contains("\nNoDisplay=") { throw "lxqt: the menu entry " + name + " is not one this recipe can hide"; }
        put(ctx, path, entry.replace("[Desktop Entry]\n", "[Desktop Entry]\nNoDisplay=true\n"), 0o644);
    }
    put(ctx, "etc/X11/xorg.conf.d/40-touchpad.conf",
        "Section \"InputClass\"\n    Identifier \"touchpad defaults\"\n    MatchIsTouchpad \"on\"\n    Driver \"libinput\"\n    Option \"Tapping\" \"on\"\n    Option \"NaturalScrolling\" \"true\"\nEndSection\n",
        0o644);
    put(ctx, "usr/share/polkit-1/rules.d/50-" + os.id + "-desktop.rules", desktop_polkit_rules(), 0o644);
}
