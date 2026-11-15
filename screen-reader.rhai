// screen-reader: a Recipe group, installed into the system root (`recipe --system install screen-reader`)
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
    network_max_bytes: 32505856,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "Orca reads the screen aloud through Speech Dispatcher and the eSpeak NG voice; AcornOS adds the Onboard on-screen keyboard.",
    homepage: "https://orca.gnome.org",
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
const SEEDS_GLIBC = [
    "orca", "speech-dispatcher", "speech-dispatcher-espeak-ng", "espeak-ng"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "orca", "speech-dispatcher", "espeak-ng", "onboard"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs", "audio", "spelling"];

let ctx = #{
    name: "screen-reader",
    version: "2026.11.13",
    description: "The Orca screen reader, with speech",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-10): 16 packages, 22580893 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-10";
const RPM_PINNED_BYTES = 22580893;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["brlapi", "brlapi-0.8.8-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/b/brlapi-0.8.8-9.fc45.x86_64.rpm", "b023d8f04bec6281cdd3ade78b5cf87106a7848b1dc7a92fddb720973c4a25ad", 203065, "LGPL-2.0-or-later AND LGPL-2.1-or-later AND GPL-2.0-or-later", false],
    ["dotconf", "dotconf-1.4.1-8.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/d/dotconf-1.4.1-8.fc45.x86_64.rpm", "5431ac4ec8a2481e08c2270ce497cd687d8fda318db45119cb0ae9170f551657", 31716, "LGPL-2.1-only AND Apache-1.1", false],
    ["espeak-ng", "espeak-ng-1.52.0-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/e/espeak-ng-1.52.0-4.fc45.x86_64.rpm", "bb0421e2ce542fa0d2890b69d85c8780ecdb0c815564c4b140e73acf3d80c4f6", 9742910, "GPL-3.0-only AND GPL-3.0-or-later AND Apache-2.0 AND BSD-2-Clause AND Unicode-DFS-2016 AND CC-BY-SA-3.0", false],
    ["libao", "libao-1.2.0-32.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libao-1.2.0-32.fc45.x86_64.rpm", "99113e417e37ade253d29185a7d61eeb6d78d134823df39516f6e5b189cc0447", 54779, "GPL-2.0-or-later", false],
    ["liblouis", "liblouis-3.33.0-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/liblouis-3.33.0-9.fc45.x86_64.rpm", "6ec9577feddbe5d64f72c2066cbcce768a5507af5bc38f4215647e524191c2e7", 218693, "LGPL-2.1-or-later AND LGPL-2.0-or-later", false],
    ["liblouis-tables", "liblouis-tables-3.33.0-9.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/liblouis-tables-3.33.0-9.fc45.noarch.rpm", "9869b7c3d51c0e2cec3a090b8ef2275303576178655dcfd4c313d2e6048173f9", 2432555, "LGPL-2.1-or-later AND LGPL-3.0-or-later", false],
    ["orca", "orca-51.1-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/o/orca-51.1-1.fc45.noarch.rpm", "9ebafb81bcb3adce127f4a308ca04215a8e6e590c4953f380928c2552e7b3b8c", 4505763, "LGPL-2.1-or-later AND CC-BY-SA-3.0", false],
    ["pcaudiolib", "pcaudiolib-1.1-20.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pcaudiolib-1.1-20.fc45.x86_64.rpm", "2f6eadbe1890733d589096c92fcd7d604f7be6e945b72d12b7ebbd9c0d205cf5", 29487, "GPL-3.0-or-later", false],
    ["python3-brlapi", "python3-brlapi-0.8.8-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-brlapi-0.8.8-9.fc45.x86_64.rpm", "f2c22f0f5716ea079c80222145349b8207e2b9ab6e139799029ccf316c897731", 112145, "LGPL-2.0-or-later AND LGPL-2.1-or-later AND GPL-2.0-or-later", false],
    ["python3-dasbus", "python3-dasbus-1.7-16.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-dasbus-1.7-16.fc45.noarch.rpm", "e49b688045f7f50f4c5da5fd9f2cbd7bc62990adc12c6fa21f812624e03a0202", 123919, "LGPL-2.1-or-later", false],
    ["python3-louis", "python3-louis-3.33.0-9.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-louis-3.33.0-9.fc45.noarch.rpm", "4fff81b783064107a54f5fde1479f03cd563896b3082ccedbd369625b6fbee44", 20106, "LGPL-2.1-or-later", false],
    ["python3-pyatspi", "python3-pyatspi-2.58.2-6.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-pyatspi-2.58.2-6.fc45.noarch.rpm", "4081af0f6c57ae0af16815b5ba712d406ad9223a1a6f94a04a871a46a7352458", 117833, "LGPL-2.0-or-later AND GPL-2.0-or-later", false],
    ["python3-speechd", "python3-speechd-0.12.1-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-speechd-0.12.1-9.fc45.x86_64.rpm", "611ba9b2adbadbe74a3e0d551ef391eb07c8d649404a25b4e9cf9589758d9df8", 75385, "GPL-2.0-or-later", false],
    ["speech-dispatcher", "speech-dispatcher-0.12.1-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/speech-dispatcher-0.12.1-9.fc45.x86_64.rpm", "653c714cf77da5f43c4b014dc9571f3960adfb5ff1480702fa956584dd9b9b28", 4835257, "GPL-2.0-or-later AND LGPL-2.1-only OR LGPL-2.0-only", true],
    ["speech-dispatcher-espeak-ng", "speech-dispatcher-espeak-ng-0.12.1-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/speech-dispatcher-espeak-ng-0.12.1-9.fc45.x86_64.rpm", "ccc0e06c74a84c6a8ba686c6fd3385be8d15e2c395a647a694ae455dcfd5f902", 33684, "GPL-2.0-or-later AND LGPL-2.1-only OR LGPL-2.0-only", false],
    ["speech-dispatcher-libs", "speech-dispatcher-libs-0.12.1-9.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/speech-dispatcher-libs-0.12.1-9.fc45.x86_64.rpm", "6ee0d406e1b994469db3bc3e2fb7a6ddafef6811026f6fab35e373abbf8288fa", 43596, "GPL-2.0-or-later", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-13): 32 packages, 31901859 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-13";
const APK_PINNED_BYTES = 31901859;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["dconf", "dconf-0.49.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/dconf-0.49.0-r1.apk", "5f51b8af4ac032445708b4c70127c79ed0f7ecf533cb8db4f202347d45004228", 85419, "LGPL-2.1-or-later", false],
    ["dconf-bash-completion", "dconf-bash-completion-0.49.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/dconf-bash-completion-0.49.0-r1.apk", "3ff569b13033669beae992014b0e92e24e69a5c244aa61553b13848e37f4dc0c", 2018, "LGPL-2.1-or-later", false],
    ["espeak-ng", "espeak-ng-1.52.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/espeak-ng-1.52.0-r1.apk", "7c3fdfab20ccd2e5f9fd146599cac2d63f6bfb9f2369fa103bde12763bd5413e", 9394030, "GPL-3.0-or-later", false],
    ["gst-plugin-pipewire", "gst-plugin-pipewire-1.6.8-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gst-plugin-pipewire-1.6.8-r4.apk", "5c67841e50b7a07f3e53894738369847e48719865672cb4bf42e627694af45b7", 76088, "MIT", false],
    ["gst-plugins-good", "gst-plugins-good-1.28.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/gst-plugins-good-1.28.3-r0.apk", "fcfc9516ebca1ba2c9aa502ead2a2ea26dac552b02efc483beef276ca24745c5", 2937272, "GPL-2.0-or-later LGPL-2.0-or-later", false],
    ["libavc1394", "libavc1394-0.5.4-r3.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libavc1394-0.5.4-r3.apk", "ac0ac780e0e9f1a602e862ace651a14d84f0847549f091b7f189370f0ab9275c", 36131, "GPL-2.0-or-later LGPL-2.0-or-later", false],
    ["libcanberra", "libcanberra-0.30-r12.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libcanberra-0.30-r12.apk", "61316b1bb8361fd4c0224310377435bfbd58bb5ed796d5ce3dc6c0aff46ea952", 31769, "LGPL-2.1-or-later", false],
    ["libcanberra-gstreamer", "libcanberra-gstreamer-0.30-r12.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libcanberra-gstreamer-0.30-r12.apk", "776c4e039cf2abdce00f3d49aaab9e28e59422cc0ebac8ef1c51ff34ed2129a4", 7679, "LGPL-2.1-or-later", false],
    ["libcanberra-pulse", "libcanberra-pulse-0.30-r12.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libcanberra-pulse-0.30-r12.apk", "578ab63346cbef0ce1e7b4226f7cef4000f6194c6b096c5b584e081b9f5ef00f", 11416, "LGPL-2.1-or-later", false],
    ["libdotconf", "libdotconf-1.4.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libdotconf-1.4.1-r0.apk", "97c261fcb11b6047f004e60f2761788759d473a0fe9d4bd33fe9a8a66d1c8af6", 10927, "LGPL-2.1-only", false],
    ["libdv", "libdv-1.0.0-r8.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libdv-1.0.0-r8.apk", "bc8df8d32c2f46c7a7d046d83e08f6867264e7cbbd803afef88e74582c87cffe", 48413, "LGPL-2.0-or-later", false],
    ["libiec61883", "libiec61883-1.2.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libiec61883-1.2.0-r4.apk", "296f1baaec84a8661c65850430819edac3085f433b098ff01a5ba69a82faa02a", 20402, "LGPL-2.1-or-later", false],
    ["libshout", "libshout-2.4.6-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libshout-2.4.6-r4.apk", "46de1100b2c057ccc512b8b297e6a4bd63c8a38ccc7560bc88a2879a2d006845", 51719, "GPL-2.0-only", false],
    ["libtag", "libtag-2.2.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libtag-2.2.1-r0.apk", "aa530e0e149dd36fb57f88f6099b6e3462181950a65d06a0453fc23e3f3a0d99", 375506, "LGPL-2.1-only OR MPL-1.1", false],
    ["ncurses", "ncurses-6.6_p20260516-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/ncurses-6.6_p20260516-r0.apk", "a36d43d2bacbfaab10fe76221f62704066d8bbb5800d7d3a9c2a562e723fad8a", 83717, "X11", false],
    ["onboard", "onboard-1.4.4.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/onboard-1.4.4.2-r0.apk", "1157a8f784a2f03eebf95f6aca98dc54e10fe09d6db4d04d94f0657b9929b771", 9474929, "GPL-3.0-only", false],
    ["onboard-pyc", "onboard-pyc-1.4.4.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/onboard-pyc-1.4.4.2-r0.apk", "9a09b8cdbe48808da943963bb8a75ffb158d0eccdc6bce1f78e51cf076325fef", 737596, "GPL-3.0-only", false],
    ["opencore-amr", "opencore-amr-0.1.6-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/opencore-amr-0.1.6-r1.apk", "a68d1582e280b35a88c5cf8af2525041c0c4d7ea19de67d586eba8ba7b66e8a0", 130534, "Apache-2.0", false],
    ["orca", "orca-50.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/orca-50.2-r0.apk", "74c36c035a926b7bd935dc9359281e83891bacb56eb1f887964a060011966bd4", 654363, "LGPL-2.1-or-later", false],
    ["orca-pyc", "orca-pyc-50.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/orca-pyc-50.2-r0.apk", "184ee1a25b2cca9b35a15ef13c7903f7ec6a58f8c45f97d8b2301f0ed6e15262", 1466735, "LGPL-2.1-or-later", false],
    ["pcaudiolib", "pcaudiolib-1.3-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/pcaudiolib-1.3-r0.apk", "7ed2c147cfa213f26d9d18fd110173271217cbf6831b34303842306a69bc310f", 5266, "GPL-3.0-or-later", false],
    ["py3-atspi", "py3-atspi-2.58.2-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-atspi-2.58.2-r1.apk", "64076212cbae3c3a864ccf46ebcc8edc7ae5b4ed98e5535433a3fa3851adf91e", 40014, "GPL-2.0-or-later", false],
    ["py3-atspi-pyc", "py3-atspi-pyc-2.58.2-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-atspi-pyc-2.58.2-r1.apk", "a02d89a7ca32028d229839891d36f8920b5a961542ac5c28c12d3851195c74e0", 65429, "GPL-2.0-or-later", false],
    ["py3-dasbus", "py3-dasbus-1.7-r5.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-dasbus-1.7-r5.apk", "d367a59238597608cd4fe0b31417467e5190c094ee483e97e58e840d98dc436c", 37769, "LGPL-2.1-or-later", false],
    ["py3-dasbus-pyc", "py3-dasbus-pyc-1.7-r5.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-dasbus-pyc-1.7-r5.apk", "b8146834d7f574c5b6579fa7dea6bf97a4dd1bbde19136eccd850ae362569cf2", 73583, "LGPL-2.1-or-later", false],
    ["py3-xdg", "py3-xdg-0.28-r7.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-xdg-0.28-r7.apk", "f2ebdf92b6b3645f142b729e21a4c07cbdcd1bef87d174997c1c7ab883a96982", 47712, "LGPL-2.1-only", false],
    ["py3-xdg-pyc", "py3-xdg-pyc-0.28-r7.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/py3-xdg-pyc-0.28-r7.apk", "e88318d6deefed23aaaf2af6d316edfbd40bb8dda7eece07fed514bd4b77bd62", 88555, "LGPL-2.1-only", false],
    ["sound-theme-freedesktop", "sound-theme-freedesktop-0.8-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sound-theme-freedesktop-0.8-r2.apk", "31bf8f6aefa5d7e7af97b8deb00913e57d8b3f684e7bbb551c7f6f99c83e293b", 390179, "CC-BY-SA-3.0 AND GPL-2.0-or-later AND GPL-2.0-only AND CC-BY-3.0", false],
    ["speech-dispatcher", "speech-dispatcher-0.12.1-r3.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/speech-dispatcher-0.12.1-r3.apk", "2e034830f89c858226873a9ed2aaf00462ee7e6478c8e0ee4bea7f5c5f2756dd", 5261367, "LGPL-2.1-or-later", false],
    ["speech-dispatcher-pyc", "speech-dispatcher-pyc-0.12.1-r3.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/speech-dispatcher-pyc-0.12.1-r3.apk", "76b35c6cee4de7f22a42c2b50c16eb0119c9d6293e25b19d542356afa9fb84cc", 108102, "LGPL-2.1-or-later", false],
    ["speex", "speex-1.2.1-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/speex-1.2.1-r2.apk", "1cbfe70405f2c1a8575a55178621b6b8848be932962920b96d11c65af17d3e10", 48256, "BSD-3-Clause", false],
    ["wavpack-libs", "wavpack-libs-5.9.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/wavpack-libs-5.9.0-r0.apk", "ee6bb979df1138e06d0dd1e842b7ba610a3aebcdff53c5dd7289c13529455cc3", 98964, "BSD-3-Clause", false],
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
