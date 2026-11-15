// printing: a Recipe group, installed into the system root (`recipe --system install printing`)
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
    network_max_bytes: 26214400,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "CUPS with its filters and driverless network printers found through Avahi; IPP over USB on LevitateOS, and the printer settings program system-config-printer on AcornOS. Plasma's printer settings are the print-manager recipe, which needs both this and Plasma.",
    homepage: "https://openprinting.github.io/cups/",
    license: "Apache-2.0 WITH LLVM-exception AND GPL-2.0-or-later AND LGPL-2.1-or-later",
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
    "cups", "cups-filters", "ipp-usb", "avahi"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "cups", "cups-filters", "avahi", "system-config-printer"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [
    "g avahi 86", "u avahi 86 'Avahi System User' /var/run/avahi-daemon /sbin/nologin", "g lp 7",
    "u lp 4 'lp' /var/spool/lpd /sbin/nologin", "g lpadmin -", "m lp lp"
];
let deps = ["desktop-libs"];

let ctx = #{
    name: "printing",
    version: "2026.11.16",
    description: "Printing: CUPS with driverless printers",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-16): 37 packages, 24647143 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-16";
const RPM_PINNED_BYTES = 24647143;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["acl", "acl-2.4.0-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/acl-2.4.0-2.fc45.x86_64.rpm", "48e25a76cd159e18665ddabdc768e426ddaa76115fa733926a5936bd359717b5", 78378, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["adobe-mappings-cmap", "adobe-mappings-cmap-20231115-6.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/adobe-mappings-cmap-20231115-6.fc45.noarch.rpm", "43034e9b0d70a7e2324b359f826db55a9afb257a7b5972c65fa848e138bd8954", 2349477, "BSD-3-Clause", false],
    ["adobe-mappings-cmap-deprecated", "adobe-mappings-cmap-deprecated-20231115-6.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/adobe-mappings-cmap-deprecated-20231115-6.fc45.noarch.rpm", "256fa297a9ed8ba34bf72415168e2b2a1a6adb782dd14d2ba62f770697b3d60e", 105055, "BSD-3-Clause", false],
    ["adobe-mappings-pdf", "adobe-mappings-pdf-20190401-13.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/adobe-mappings-pdf-20190401-13.fc45.noarch.rpm", "76165606c8d741818a48cae06015102f230c4a03d7545c52cad21e94f82eae84", 634768, "BSD-3-Clause", false],
    ["avahi", "avahi-0.9~rc2-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/avahi-0.9~rc2-9.fc45.x86_64.rpm", "9c8ec7097eaeaa7a4ff7beb854573b33411c5d0bbd2b421759f256496612b563", 465196, "LGPL-2.1-or-later AND LGPL-2.0-or-later AND BSD-2-Clause-Views AND MIT", true],
    ["color-filesystem", "color-filesystem-1-39.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/color-filesystem-1-39.fc45.noarch.rpm", "a8d27d949226936a42d6185ae28c9fe2425fe00c5d46eccc5d0dcaee2f955e84", 8579, "LicenseRef-Not-Copyrightable", true],
    ["colord", "colord-1.4.8-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/colord-1.4.8-5.fc45.x86_64.rpm", "d71dba29b861c79c595904f849db929dfa77817da2722887df16dcf25d01cf64", 608698, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["cups", "cups-2.4.19-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/cups-2.4.19-4.fc45.x86_64.rpm", "a24fc377a83848a09b849203005aee4d8b7d0fe1fea4a6d143915795df9517fe", 1589201, "Apache-2.0 WITH LLVM-exception AND BSD-3-Clause AND Zlib AND BSD-2-Clause", false],
    ["cups-client", "cups-client-2.4.19-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/cups-client-2.4.19-4.fc45.x86_64.rpm", "3fd3b29b7605e08ed1441487a64cdb7b30390260c00f1f385e779e3697739fdf", 75285, "Apache-2.0 WITH LLVM-exception AND BSD-3-Clause AND Zlib AND BSD-2-Clause", false],
    ["cups-filters", "cups-filters-2.0.1-17.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/cups-filters-2.0.1-17.fc45.x86_64.rpm", "ff4eef43054e6dac0c71720ed47afdf8bd8cd178c1681743f7481df567d916d1", 221551, "Apache-2.0 WITH LLVM-exception", false],
    ["ghostscript", "ghostscript-10.07.1-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/ghostscript-10.07.1-3.fc45.x86_64.rpm", "b07c073e8ccb5a9689599ef925e9f21b00cc39b460d2b32f6de0c6774d4af1ab", 37649, "AGPL-3.0-or-later", false],
    ["ghostscript-tools-fontutils", "ghostscript-tools-fontutils-10.07.1-3.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/ghostscript-tools-fontutils-10.07.1-3.fc45.noarch.rpm", "d32257f51f6453433e7a3c54c9e2b45f6c2e84ba30c5f22238b581d06c120349", 12043, "AGPL-3.0-or-later", false],
    ["ghostscript-tools-printing", "ghostscript-tools-printing-10.07.1-3.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/ghostscript-tools-printing-10.07.1-3.fc45.noarch.rpm", "2314e1f3154ce11d83820aaa48d496bda3abca682901def6d7812a481d891e2a", 12419, "AGPL-3.0-or-later", false],
    ["google-droid-sans-fonts", "google-droid-sans-fonts-20200215-25.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/google-droid-sans-fonts-20200215-25.fc45.noarch.rpm", "6c7b755a5bf2c4e461cb42c9cfd447f247b06b269e14e035663e9bc17824973c", 2833190, "Apache-2.0", false],
    ["ipp-usb", "ipp-usb-0.9.34-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/i/ipp-usb-0.9.34-3.fc45.x86_64.rpm", "61580294f440b7900dffabc1afbf3fa0169d5d05219e8b7a35166d11bce533b0", 2680073, "BSD-2-Clause", false],
    ["jbig2dec-libs", "jbig2dec-libs-0.20-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/j/jbig2dec-libs-0.20-9.fc45.x86_64.rpm", "6dfc9479439530b19fde74d01394722bd2aa92bf2c9d196c9072828a0196f62d", 77430, "AGPL-3.0-or-later", false],
    ["libcupsfilters", "libcupsfilters-2.2.1-8.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libcupsfilters-2.2.1-8.fc45.x86_64.rpm", "7b720fe8c196f0d75a23f229572b444325d3f16de2531a0f46e56dcd6b3bd330", 553213, "Apache-2.0 WITH LLVM-exception", false],
    ["libdaemon", "libdaemon-0.14-34.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdaemon-0.14-34.fc45.x86_64.rpm", "e23b749246ac851b05d7c64f45bb46aaa05658438cef9358eca79ef23ad6a2ff", 32709, "LGPL-2.1-or-later", false],
    ["libexif", "libexif-0.6.26-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libexif-0.6.26-2.fc45.x86_64.rpm", "d488b5dc285621cf0ca7a52de8d777ed3ef6be70aae8f7ea2ad555cc8def5f48", 526325, "LGPL-2.1-or-later", false],
    ["libgs", "libgs-10.07.1-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libgs-10.07.1-3.fc45.x86_64.rpm", "3af2bade31c824ddad2af826c7d5a9dc8919f0e796b84d65cfca1944f7f43e4a", 4096047, "AGPL-3.0-or-later", false],
    ["libijs", "libijs-0.35-27.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libijs-0.35-27.fc45.x86_64.rpm", "3beaba00c02e78d55be804f3588fc32449effe93b455b696bcb566fb2c5fa10f", 30129, "AGPL-3.0-or-later", false],
    ["libpaper", "libpaper-2.1.1-11.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libpaper-2.1.1-11.fc45.x86_64.rpm", "af798513d484bdc493a5bca13f2091c5c47b13047ac5d077a6ebdc4c09eab6ad", 26966, "LGPL-2.1-or-later AND LicenseRef-Fedora-Public-Domain AND GPL-3.0-or-later AND LGPL-2.0-or-later AND FSFAP", false],
    ["libppd", "libppd-2.1.1-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libppd-2.1.1-5.fc45.x86_64.rpm", "df4d7856b1f2ee08c54742cd8249e525e0c57cc4b153d01e151da74d28d2e031", 271748, "Apache-2.0 WITH LLVM-exception", false],
    ["pdfio", "pdfio-1.6.5-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pdfio-1.6.5-1.fc45.x86_64.rpm", "befaa28cceabf97df2c9c8c875db18ee7deae4310472f43e9ef70d4f8ede711d", 87553, "Apache-2.0 WITH LLVM-exception AND Zlib AND GPL-2.0-or-later AND MIT-CMU AND BSD-3-Clause", false],
    ["poppler-utils", "poppler-utils-26.08.0-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/poppler-utils-26.08.0-2.fc45.x86_64.rpm", "187bd0b0b1290e19be306ac7ce0ccaa11e1dfe4be654577dc1509c7a9d648857", 325463, "(GPL-2.0-only OR GPL-3.0-only) AND GPL-2.0-or-later AND LGPL-2.0-or-later AND LGPL-2.1-or-later AND MIT", false],
    ["urw-base35-bookman-fonts", "urw-base35-bookman-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-bookman-fonts-20200910-29.fc45.noarch.rpm", "6eab8e66bf7581d13e111780ba14d543f676ce6c618432de9d75568e1c0afdd4", 865271, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-c059-fonts", "urw-base35-c059-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-c059-fonts-20200910-29.fc45.noarch.rpm", "ac4327a999e2933148dea267ad8701ae8bfcb465579d5fa4c73399a8850e0592", 893665, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-d050000l-fonts", "urw-base35-d050000l-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-d050000l-fonts-20200910-29.fc45.noarch.rpm", "003b7ce250b0f9ddb29eb5806b352179b50d60a18cc0fe1fdd6e29085f26c106", 76920, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-fonts", "urw-base35-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-fonts-20200910-29.fc45.noarch.rpm", "40ab8b2af47cec6d83cea9b01ca5df8038448babb35a8e9b9ea138fa60bca7ba", 10008, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-fonts-common", "urw-base35-fonts-common-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-fonts-common-20200910-29.fc45.noarch.rpm", "5cb3621358f7ac28309636f237dec5de176dcbfba64f528a0f49e38f55774fba", 21022, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-gothic-fonts", "urw-base35-gothic-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-gothic-fonts-20200910-29.fc45.noarch.rpm", "598007b5a12fad7751cb63fa6412e5a404149c37049cf4ce8d7c8e36df1910ff", 656028, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-nimbus-mono-ps-fonts", "urw-base35-nimbus-mono-ps-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-nimbus-mono-ps-fonts-20200910-29.fc45.noarch.rpm", "449ab18c7012666f02e24f048419740648afd0f72d2c184da163056d1c7e467a", 812761, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-nimbus-roman-fonts", "urw-base35-nimbus-roman-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-nimbus-roman-fonts-20200910-29.fc45.noarch.rpm", "5f3f36ae0c665404e4eb428c5d91d3116f81ad04b8b84d585e73a7bbe3f21964", 873365, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-nimbus-sans-fonts", "urw-base35-nimbus-sans-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-nimbus-sans-fonts-20200910-29.fc45.noarch.rpm", "a8fe4c003977f1d70d75c215ee07c7c5592493436d45a3b4dde73259b132c6ad", 1363151, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-p052-fonts", "urw-base35-p052-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-p052-fonts-20200910-29.fc45.noarch.rpm", "b352e99751a486a82b73a9713e65c09185f428c173c77d8da91909c9aa6bef6a", 995420, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-standard-symbols-ps-fonts", "urw-base35-standard-symbols-ps-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-standard-symbols-ps-fonts-20200910-29.fc45.noarch.rpm", "2fc69283308904754ae2ba31089641a3bcb6b38f2ca7df8b6e466e740b8a22d7", 58986, "AGPL-3.0-only AND GPL-2.0-or-later", false],
    ["urw-base35-z003-fonts", "urw-base35-z003-fonts-20200910-29.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/u/urw-base35-z003-fonts-20200910-29.fc45.noarch.rpm", "b65621701fa6b2eb7193e672a8f48a71b67ff5d7118913df3b4ccd799efc2501", 281401, "AGPL-3.0-only AND GPL-2.0-or-later", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-16): 32 packages, 26172697 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-16";
const APK_PINNED_BYTES = 26172697;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["avahi", "avahi-0.9_rc4-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/avahi-0.9_rc4-r0.apk", "bc6f9260c74ad935d22e15d9f520e4f659dcbfefcac3b7da59ef704f885d96ff", 154737, "LGPL-2.1-or-later", true],
    ["avahi-glib", "avahi-glib-0.9_rc4-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/avahi-glib-0.9_rc4-r0.apk", "90496d0c295e1bff0d762a77c51b35727b3f113772aecdd1dbc529ed28d00636", 19928, "LGPL-2.1-or-later", false],
    ["avahi-openrc", "avahi-openrc-0.9_rc4-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/avahi-openrc-0.9_rc4-r0.apk", "497edded6a74a8d95b7a1873ef3b064319ccfb1ecae45a8bdcf08b91bd739779", 1936, "LGPL-2.1-or-later", false],
    ["cups", "cups-2.4.19-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/cups-2.4.19-r1.apk", "6aca0c92139e2c2ca75dcb9677e1f53250e139748cb78651f64f8a53ac530199", 811603, "Apache-2.0", true],
    ["cups-client", "cups-client-2.4.19-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/cups-client-2.4.19-r1.apk", "449516e50e85d10e27152a1fed81a99a0f7661c290f1dd7c9997e350e53936d3", 279647, "Apache-2.0", false],
    ["cups-filters", "cups-filters-1.28.17-r9.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/cups-filters-1.28.17-r9.apk", "c8727edad292b2e834d6748731660ab05c3730b9c7ea74648ca416f18e65ba93", 719101, "GPL-2.0-or-later LGPL-2.1-or-later MIT", false],
    ["cups-filters-libs", "cups-filters-libs-1.28.17-r9.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/cups-filters-libs-1.28.17-r9.apk", "55afdd544b22f6af25edc77b21a23b15403dec6a22ba3220d5341484a015416f", 110133, "GPL-2.0-or-later LGPL-2.1-or-later MIT", false],
    ["cups-openrc", "cups-openrc-2.4.19-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/cups-openrc-2.4.19-r1.apk", "176ceae5de8c7eb1d091d295bdf05c5e549b67258f971a0d7d098486c781ff97", 2004, "Apache-2.0", false],
    ["font-freefont", "font-freefont-20120503-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/font-freefont-20120503-r4.apk", "3f9f72d0baac83e42cc745dd07ae80cdf47900fcd6cdf89d745611fc039fa88e", 4305166, "GPL-3.0-or-later", false],
    ["ghostscript", "ghostscript-10.08.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/ghostscript-10.08.0-r0.apk", "598b89730c235735a5c257abee6638d995bf2266b092a9ab690fe61f9fc90111", 17171271, "AGPL-3.0-or-later", false],
    ["jbig2dec", "jbig2dec-0.20-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/jbig2dec-0.20-r0.apk", "5365e928155348baeacdb235789f2a16eb3f4850b006e1ae3a85a8713ac1161e", 55223, "AGPL-3.0-or-later", false],
    ["libdaemon", "libdaemon-0.14-r6.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libdaemon-0.14-r6.apk", "e9ac121e78bd45360f834539907344acd838fe102a4659bf1e2998c9171739f1", 10803, "MIT", false],
    ["libnotify", "libnotify-0.8.8-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libnotify-0.8.8-r0.apk", "280f083f69bf6dba1199c0f657f5ea0d9b4cd458332a0be399d6f6aa64e56a6f", 27104, "LGPL-2.1-or-later", false],
    ["libpaper", "libpaper-2.2.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libpaper-2.2.6-r0.apk", "413fa2b2122294762499577dfbcbc7a1461dbd1956777d41edd7af84c36b31da", 29722, "LGPL-2.1-or-later OR MIT", false],
    ["openssl", "openssl-3.5.9-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/openssl-3.5.9-r0.apk", "9358e8f38eb19a1e035355626570c76bda1e5a49084c768fb0edc1e607251e99", 340119, "Apache-2.0", false],
    ["poppler-utils", "poppler-utils-25.12.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/poppler-utils-25.12.0-r1.apk", "eb7fb9b86491a95a16011fff4581c42939008adcfd4d83c1a35367445d41d766", 211524, "GPL-2.0-or-later", false],
    ["py3-certifi", "py3-certifi-2026.10.23-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-certifi-2026.10.23-r0.apk", "185a041010566b7011a0469c024f8dbe6a6423537c24733acc0e62bdefae7663", 5894, "MPL-2.0", false],
    ["py3-certifi-pyc", "py3-certifi-pyc-2026.10.23-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-certifi-pyc-2026.10.23-r0.apk", "596abf7ad424b81e0c1fa9681980e972466830f50082f98ff49d917a99370055", 4862, "MPL-2.0", false],
    ["py3-charset-normalizer", "py3-charset-normalizer-3.4.9-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-charset-normalizer-3.4.9-r0.apk", "4a567523cd4f88d0c6cc84be1e81a55475045717f275eca48b8b66cf875b43a4", 62902, "MIT", false],
    ["py3-charset-normalizer-pyc", "py3-charset-normalizer-pyc-3.4.9-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-charset-normalizer-pyc-3.4.9-r0.apk", "9d60cb0b5e508692a4a8ee3938cc0e31c4056d4f29f025e2b57f52dfdbeb2b08", 82455, "MIT", false],
    ["py3-cupshelpers", "py3-cupshelpers-1.5.18-r10.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-cupshelpers-1.5.18-r10.apk", "e24c7b16b1ab17e5872ba3859368a6f645bfce7560851a07bca97fcc4244b86f", 33141, "GPL-2.0-or-later", false],
    ["py3-cupshelpers-pyc", "py3-cupshelpers-pyc-1.5.18-r10.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-cupshelpers-pyc-1.5.18-r10.apk", "caa707a2ff47f979481914a4260fab0e71751c43f8e1713682e82ab99f9e97c5", 57285, "GPL-2.0-or-later", false],
    ["py3-idna", "py3-idna-3.16-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-idna-3.16-r0.apk", "d25444cc6e6d6c33760c2873b642fe219ab38f467968bca8a8ed5084a2178181", 74947, "BSD-3-Clause", false],
    ["py3-idna-pyc", "py3-idna-pyc-3.16-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-idna-pyc-3.16-r0.apk", "6202064b0eb0e7d2ae87cf1a00f763bd687efde3885d11286f719c667b064395", 92718, "BSD-3-Clause", false],
    ["py3-pycups", "py3-pycups-2.0.4-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-pycups-2.0.4-r1.apk", "dbc514ad3ad3a1a8729a42517dce9e2fb34b9fc174486b529cdd3a36e1c35ed7", 60263, "GPL-2.0-or-later", false],
    ["py3-requests", "py3-requests-2.33.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-requests-2.33.1-r0.apk", "a7063a0737f0ad89e79b8a25ebba4f724e893b6adaddd450b47e28aa4409c7f6", 60992, "Apache-2.0", false],
    ["py3-requests-pyc", "py3-requests-pyc-2.33.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-requests-pyc-2.33.1-r0.apk", "8cfb8b870ec9e3a8e5e904cda1f4ee52ad53f3716d6bd4c73ea4945c7995a32f", 93707, "Apache-2.0", false],
    ["py3-urllib3", "py3-urllib3-2.7.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-urllib3-2.7.0-r0.apk", "9fde77a1efbe1da8482785eca2920a0b0fb97ebf0ffa0f647baf95057c484ba4", 119048, "MIT", false],
    ["py3-urllib3-pyc", "py3-urllib3-pyc-2.7.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-urllib3-pyc-2.7.0-r0.apk", "2a1c0e9180d2be5cb69495ea73081d978490c56ba37e438b5394bc8912c76f01", 216295, "MIT", false],
    ["qpdf-libs", "qpdf-libs-12.3.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/qpdf-libs-12.3.2-r0.apk", "fedd8952f394b8138b50f64dc8e50b656a249391adaeca49a447c710ec36d970", 717019, "Apache-2.0", false],
    ["system-config-printer", "system-config-printer-1.5.18-r10.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/system-config-printer-1.5.18-r10.apk", "b35fb525ba8648c269bf4529f7bf5ad43f0795fe1de27a35dbeb26fd935f74e4", 101665, "GPL-2.0-or-later", false],
    ["system-config-printer-common", "system-config-printer-common-1.5.18-r10.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/system-config-printer-common-1.5.18-r10.apk", "4bb89707bb73c3d4a283c0c762151408c8fd8a0787a109307e923023297dad9c", 139483, "GPL-2.0-or-later", false],
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

// CUPS and the Avahi discovery that driverless printing uses start at boot
// (Avahi also as dbus-org.freedesktop.Avahi on systemd). On Fedora the print
// commands are the links `alternatives` would make (lpr, lp, lpq, lprm,
// lpstat, cancel, lpc and their manual pages) to CUPS's. On AcornOS the menu
// hides CUPS's web page (the printer settings program does the job).
//
// /etc/cups itself is cups-filesystem's (root:lp), which is in desktop-libs;
// this tree only has it as the parent of CUPS's files, and Recipe gives the
// directory the owner and mode desktop-libs states.
fn configure(ctx) {
    if ctx.format == "rpm" {
        enable_service(ctx, "cups.service", "");
        enable_service(ctx, "avahi-daemon.service", "");
        for pair in [["usr/bin/lpr", "lpr.cups"], ["usr/bin/lp", "lp.cups"], ["usr/bin/lpq", "lpq.cups"], ["usr/bin/lprm", "lprm.cups"],
                     ["usr/bin/lpstat", "lpstat.cups"], ["usr/bin/cancel", "cancel.cups"], ["usr/bin/lpc", "lpc.cups"],
                     ["usr/share/man/man1/cancel.1.gz", "cancel-cups.1.gz"], ["usr/share/man/man1/lp.1.gz", "lp-cups.1.gz"],
                     ["usr/share/man/man8/lpc.8.gz", "lpc-cups.8.gz"], ["usr/share/man/man1/lpq.1.gz", "lpq-cups.1.gz"],
                     ["usr/share/man/man1/lpr.1.gz", "lpr-cups.1.gz"], ["usr/share/man/man1/lprm.1.gz", "lprm-cups.1.gz"],
                     ["usr/share/man/man1/lpstat.1.gz", "lpstat-cups.1.gz"]] {
            if !exists(join_path(ctx.system, dirname(pair[0]) + "/" + pair[1])) { throw "printing: cups-client no longer ships /" + dirname(pair[0]) + "/" + pair[1]; }
            put_link(ctx, pair[0], pair[1]);
        }
    } else {
        enable_service(ctx, "", "cupsd");
        enable_service(ctx, "", "avahi-daemon");
        let entry = "usr/share/applications/cups.desktop";
        let text = tree_text(ctx, entry);
        if !text.contains("\nNoDisplay=") { put(ctx, entry, text.replace("[Desktop Entry]\n", "[Desktop Entry]\nNoDisplay=true\n"), 0o644); }
    }
}
