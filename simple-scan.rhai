// simple-scan: a Recipe group, installed into the system root (`recipe --system install simple-scan`)
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
    network_max_bytes: 7340032,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "app",
    category: "graphics",
    libc: ["musl"],
    systems: ["acornos"],
    details: "Document Scanner scans images and documents over SANE and its drivers, which this group brings.",
    homepage: "https://gitlab.gnome.org/GNOME/simple-scan",
    license: "GPL-3.0-or-later",
    adds: #{ programs: ["simple-scan"], menu: ["Document Scanner"] },
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
    "simple-scan", "sane-backends"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [
    "g scanner -", "u saned - 'SANE network scanning daemon' /run/saned /sbin/nologin",
    "m saned scanner"
];
let deps = ["desktop-libs"];

let ctx = #{
    name: "simple-scan",
    version: "2026.11.13",
    description: "A scanning program, with the scanner drivers",
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
// 2026-11-13): 103 packages, 6471632 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-13";
const APK_PINNED_BYTES = 6471632;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["hplip-libs", "hplip-libs-3.26.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/hplip-libs-3.26.6-r0.apk", "7939845bc63f712b5aeacd09149610e5ef4ff66e5086481d1d779c00d02d6712", 120670, "GPL-2.0-only AND BSD-3-Clause AND MIT", false],
    ["libcolord", "libcolord-1.4.8-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libcolord-1.4.8-r4.apk", "69d6b8f97f8695c7dd384ff7e5dde4f76d97b523a355b59ebed3f763a33d9dfb", 206716, "GPL-2.0-or-later", false],
    ["libgusb", "libgusb-0.4.9-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libgusb-0.4.9-r1.apk", "539e0ef251a4ab1403d16abdebd1053944cc157204cec5f51e999d8cc15e4bdc", 39278, "LGPL-2.1-or-later", false],
    ["libieee1284", "libieee1284-0.2.11-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libieee1284-0.2.11-r4.apk", "e23289216dafd2e898c014fbf798fa8616896d01356a4afcfcab7246b43c4c43", 17789, "GPL-2.0-or-later", false],
    ["net-snmp-libs", "net-snmp-libs-5.9.5.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/net-snmp-libs-5.9.5.2-r0.apk", "7d230df1ec0f2e7a19e85f9be35cebb7468850c4f38c1e99d379685f388ffe59", 616603, "Net-SNMP", false],
    ["poppler-glib", "poppler-glib-25.12.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/poppler-glib-25.12.0-r1.apk", "64b9d75c2347fccdee023c7583e3ee3f2323719e9c9eece2cd03705de2829464", 183898, "GPL-2.0-or-later", false],
    ["sane", "sane-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-1.4.0-r4.apk", "8a6e4f75111c148296a230cf39a06c7cf8b060e796a7ac10f4e26db2977f4336", 100817, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-abaton", "sane-backend-abaton-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-abaton-1.4.0-r4.apk", "93f8093b9f475193edd5f1f6252770ac4a4da14b01703515f68e4d530b6cd912", 26952, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-agfafocus", "sane-backend-agfafocus-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-agfafocus-1.4.0-r4.apk", "972e2c77d0f2cac3c36d36aaf9b093342aec441726bb57adaaf269b9cb1e8b1a", 30338, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-apple", "sane-backend-apple-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-apple-1.4.0-r4.apk", "c0bc4e155380adce2bde0fc2be36db404e9347ccba7f4ee8889b381b56751890", 31542, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-artec", "sane-backend-artec-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-artec-1.4.0-r4.apk", "2356847a8b261d9f81f013bd07ccb1dd457b4e97ee736a8d9d79722c69be2e73", 37907, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-artec_eplus48u", "sane-backend-artec_eplus48u-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-artec_eplus48u-1.4.0-r4.apk", "263dce21ef02569fb85cee0a54c8f2533e87d4ed24a333f885c890a8575f92df", 51194, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-as6e", "sane-backend-as6e-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-as6e-1.4.0-r4.apk", "d718c405290a7c384f11ce6d1babc53db5cf9f11d7647404507ecb7545b99b74", 16018, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-avision", "sane-backend-avision-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-avision-1.4.0-r4.apk", "15d6dc4af8d5932b98d4f7fe6c5bef11e62417312f120f36831928b8a8edc688", 83040, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-bh", "sane-backend-bh-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-bh-1.4.0-r4.apk", "03e7ae1960736e8d4a65e9952f7a5a65f0cfea849806caee35c403fd8d46267d", 39536, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-canon", "sane-backend-canon-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-canon-1.4.0-r4.apk", "33239983446b8181cddd92b5e0e72a70d3a4417af5af8dcdaf6cc6fc199d3c85", 42648, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-canon630u", "sane-backend-canon630u-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-canon630u-1.4.0-r4.apk", "d05b156b898453a4ad096000bbcbdc5032f1a4badd22bf7392e8827e64983d3e", 40251, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-canon_dr", "sane-backend-canon_dr-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-canon_dr-1.4.0-r4.apk", "a39a69ef1a91582dc56cce154dfa11e96e1273850c850be634ed87acb1b672c1", 85050, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-canon_lide70", "sane-backend-canon_lide70-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-canon_lide70-1.4.0-r4.apk", "090732fd8a2a95ff6d1bc8668cdc0ff2eda4ca7116b88a75f8390524f661855a", 49730, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-canon_pp", "sane-backend-canon_pp-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-canon_pp-1.4.0-r4.apk", "06983223a648312a145c4484cd99ed5c7c83344b02ae1214c087fbb1342c86d1", 28127, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-cardscan", "sane-backend-cardscan-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-cardscan-1.4.0-r4.apk", "9374bf3c65c52b23c9c0ccd81a4dd55216a0f9ba4c99e82e6ba3b0478b96ead0", 36069, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-coolscan", "sane-backend-coolscan-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-coolscan-1.4.0-r4.apk", "dab19249236ce15ad704608245225602e655507a5f1eed8fdeae71cb36c4d10e", 57479, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-coolscan2", "sane-backend-coolscan2-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-coolscan2-1.4.0-r4.apk", "fc56e6c2267f3f0a08453fcb0ae9383f35947a6c6e2b05cbf07c4b10e220af92", 51881, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-coolscan3", "sane-backend-coolscan3-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-coolscan3-1.4.0-r4.apk", "4f6637e56a9e4db1f103f9575cb0d8733092b6ab0789e8e2b7064035baccaad7", 52890, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-dc210", "sane-backend-dc210-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-dc210-1.4.0-r4.apk", "9534cbb0f017a760e2afe5faccfb069bda5b2747e876726b0d3ea6dd9527bebd", 18490, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-dc240", "sane-backend-dc240-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-dc240-1.4.0-r4.apk", "28d220eb12ceca0ae241c81bfa61a2d0aee10c432ea0792d38e60c7a2af34d5f", 21510, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-dc25", "sane-backend-dc25-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-dc25-1.4.0-r4.apk", "c3865a84e49a2020ac546f811421ef2cad4142083582247c94c7371df396e08c", 21256, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-dell1600n_net", "sane-backend-dell1600n_net-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-dell1600n_net-1.4.0-r4.apk", "ff4157e864d1746ceb1aee7c04d14979ae90c1859b5b335e844a15f60008384f", 20272, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-dmc", "sane-backend-dmc-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-dmc-1.4.0-r4.apk", "3a7c7a7b0839b5c6f82666cfb7df6e2038231b5542e0ce82687fcf4136bcc6de", 26137, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-epjitsu", "sane-backend-epjitsu-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-epjitsu-1.4.0-r4.apk", "82f8708023f1535594647781512b0c6e677646bcb0e98d3d8a18d6e37bf108ff", 52064, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-epson", "sane-backend-epson-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-epson-1.4.0-r4.apk", "5cf6aeee5de6eb485260d05533365bfaabebbd616b36343a7aebf477a846adb2", 62637, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-epson2", "sane-backend-epson2-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-epson2-1.4.0-r4.apk", "dcf69b2256364d048d6abfdbbe0205ae0f5e480f1776d85738f42a4ea55d959a", 80218, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-epsonds", "sane-backend-epsonds-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-epsonds-1.4.0-r4.apk", "4b579e708120b8ff4f9695d08acaaf6063406a6d953a1fc31f9a550297e75ad2", 68365, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-escl", "sane-backend-escl-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-escl-1.4.0-r4.apk", "a8fa24d2c3077ad108d87359b17c59879a47e29e84c26c4f9c509d513ba581e6", 35584, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-fujitsu", "sane-backend-fujitsu-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-fujitsu-1.4.0-r4.apk", "36f5a326f52afc141ca8414435a09d0c0d79de8a604b693c61eda4f4d8835516", 89415, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-genesys", "sane-backend-genesys-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-genesys-1.4.0-r4.apk", "de7fd552b47d1d90efee736f0b10bb285e1edcaf4e315fc7e83e4cc477b5013d", 365143, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-gphoto2", "sane-backend-gphoto2-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-gphoto2-1.4.0-r4.apk", "81964e8e93555b441adbfe9afe99124c7f1fbfeb4f0a805fb97152d568926cba", 20560, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-gt68xx", "sane-backend-gt68xx-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-gt68xx-1.4.0-r4.apk", "f1770ef281a7e3014b92eb2f4c77ba0a8bb2687187f48a6e6492cf96d3940511", 71309, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hp", "sane-backend-hp-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hp-1.4.0-r4.apk", "4284e18fc0785a4e83c9c5e1627b05a14258249f93e3d1ebff5442208ed1d999", 83123, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hp3500", "sane-backend-hp3500-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hp3500-1.4.0-r4.apk", "7627da7aac7e601d08691d40691ea5b023e6ad38a6043ec0a68966b049f643d2", 44905, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hp3900", "sane-backend-hp3900-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hp3900-1.4.0-r4.apk", "0e8457c8aa56ec89b1890253ea248e04c2df541bc7dbd3db67fa1758fb563a30", 123487, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hp4200", "sane-backend-hp4200-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hp4200-1.4.0-r4.apk", "f10f4ec2839844ca2cf123ae8625ba4f492fd8e221d13f35c0e00595ee596dee", 41523, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hp5400", "sane-backend-hp5400-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hp5400-1.4.0-r4.apk", "902e77a24e47e3248961277b3f9ab26db2d38da8102d0efbbdaa87fd525f32dc", 40788, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hp5590", "sane-backend-hp5590-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hp5590-1.4.0-r4.apk", "6e020f78f3bc129834fe7e9828e6f2e5854e2dca2bbf965b9cfdf07964f9a4b7", 50439, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hpaio", "sane-backend-hpaio-3.26.6-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hpaio-3.26.6-r0.apk", "36947d80605a1ac4ae8e463ea459e692198ec2bf40da3ce8837bb4c57571bf4b", 85455, "GPL-2.0-only AND BSD-3-Clause AND MIT", false],
    ["sane-backend-hpljm1005", "sane-backend-hpljm1005-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hpljm1005-1.4.0-r4.apk", "1b4871e16c1780935978abab62dd612c08893765489bdad4a3f30b14677d14b6", 34100, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hpsj5s", "sane-backend-hpsj5s-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hpsj5s-1.4.0-r4.apk", "e8d568348797e484558e7a3c32a28e1f8af230203afb6a47849c66ff9609649f", 17006, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-hs2p", "sane-backend-hs2p-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-hs2p-1.4.0-r4.apk", "f16e7b43ce24b9ee466b6265748c83f50dffa9276268f8177fae2a2db4b23ce5", 47998, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-ibm", "sane-backend-ibm-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-ibm-1.4.0-r4.apk", "8b62c3bdf7eeea28f777addd9954e2af2a0ed493217e2d7dc31277dd3b5e9521", 27914, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-kodak", "sane-backend-kodak-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-kodak-1.4.0-r4.apk", "2a48644731910f4e351046e63477f8f7a8593a6a00de5a7579bf31645376f2de", 33300, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-kodakaio", "sane-backend-kodakaio-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-kodakaio-1.4.0-r4.apk", "a606d629f867efc3ab23cb9d5a0ed733fea5092339d007fe8bbb208c5a8afb57", 58745, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-kvs1025", "sane-backend-kvs1025-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-kvs1025-1.4.0-r4.apk", "b2fd2ac5b525c465fd804946eab0d1b40942d48896290c8a981937ffa0a68073", 55360, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-kvs20xx", "sane-backend-kvs20xx-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-kvs20xx-1.4.0-r4.apk", "2bed0b3797c9a1b8d94adab6e8efec3a9d2e22eaf3e7ce805c19f74cde628586", 47209, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-kvs40xx", "sane-backend-kvs40xx-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-kvs40xx-1.4.0-r4.apk", "a6d1e6bd2e0743273c7614b7c89a8e3558c248c312479c2206bf8cf02273c2ef", 51560, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-leo", "sane-backend-leo-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-leo-1.4.0-r4.apk", "66ca6292498b4890ef5c085fffd2f875d4baec91dd7bc140e48bbd88082e5770", 30286, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-lexmark", "sane-backend-lexmark-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-lexmark-1.4.0-r4.apk", "177fd4f79b8ec7a0bc5237b5880c0014f555c7e85cdc80770ae3f24bc66f2984", 49400, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-ma1509", "sane-backend-ma1509-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-ma1509-1.4.0-r4.apk", "bc4311cedf20d57372f7014608b7f2a45df0fe8fbc5abef0811b15d221d987e1", 39666, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-magicolor", "sane-backend-magicolor-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-magicolor-1.4.0-r4.apk", "158b6bdd1fc5e924914d82bb425242ac0fbae9840e5f80bc56e9eb857691c98f", 56145, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-matsushita", "sane-backend-matsushita-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-matsushita-1.4.0-r4.apk", "7cf128031453613ef7c001c962026123610c66f2a56958e824f713bd64d9decc", 30597, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-microtek", "sane-backend-microtek-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-microtek-1.4.0-r4.apk", "195c153fb122c29fd810421bc11b43a6d13751c61e444638f395cc66b29d5df0", 43047, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-microtek2", "sane-backend-microtek2-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-microtek2-1.4.0-r4.apk", "adf6642df9901a87a5b1e63d22627fad52a7ef81a3604aeafd9202cb988b10c8", 58411, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-mustek", "sane-backend-mustek-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-mustek-1.4.0-r4.apk", "a2b15e12e3045594f5f48f9481530b557820196d20189281356d1e1f0a6866dd", 65619, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-mustek_pp", "sane-backend-mustek_pp-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-mustek_pp-1.4.0-r4.apk", "b470898a940ba044bca81c5f321d875b9ac9d332a6dde2e4988912815fab1ea2", 44645, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-mustek_usb", "sane-backend-mustek_usb-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-mustek_usb-1.4.0-r4.apk", "9780b28656e57e947436144af628cedeea0de50b06840b97a07a3b211164c69e", 67523, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-mustek_usb2", "sane-backend-mustek_usb2-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-mustek_usb2-1.4.0-r4.apk", "9cfc73bf607b025372698c8ace66654a2786d8ac80aeab49a8b9cefce243cfb3", 71523, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-nec", "sane-backend-nec-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-nec-1.4.0-r4.apk", "34836608eb173fc2aab4c9bf0568af7099144fa349d0e5bfdf2ad8bb5a33f87c", 33674, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-net", "sane-backend-net-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-net-1.4.0-r4.apk", "d99e25c2d6f0441ebec5aaa1cce438509d472ac7989b0255f6ca2d1906189bb5", 28068, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-niash", "sane-backend-niash-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-niash-1.4.0-r4.apk", "16e3647f74513abafccbeda32e787f35ad6e74827cac0c4defd9480e7b174d96", 40870, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-p5", "sane-backend-p5-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-p5-1.4.0-r4.apk", "46e8a46ffae00fecf81b2a609320931934887e7c59a4b71f684cacd5b33c096a", 24651, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-pie", "sane-backend-pie-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-pie-1.4.0-r4.apk", "a013fbbfbd4db3d91ff6230784d955dd4dbe6684620b9150d2d3c8636da5824e", 37721, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-pieusb", "sane-backend-pieusb-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-pieusb-1.4.0-r4.apk", "537beec9b807e16f07002815e8368ad71b4429b2cf908ef568ce4e3cd1e585ab", 83509, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-pixma", "sane-backend-pixma-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-pixma-1.4.0-r4.apk", "9cbfee8d686d10a279d5c8e36a6b799173d9aa6d3f6b3b261935e35428914419", 88668, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-plustek", "sane-backend-plustek-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-plustek-1.4.0-r4.apk", "a6c1b9fddbee1f3ad1b105ea221af3975ab89f80b8809f9f792882e9088438f1", 99846, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-plustek_pp", "sane-backend-plustek_pp-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-plustek_pp-1.4.0-r4.apk", "07cd6d6f86b94009ba3ecbda7a4f8da212762fd8f02118ca342a77dcf013cc58", 79060, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-qcam", "sane-backend-qcam-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-qcam-1.4.0-r4.apk", "bac9843488718e9396b290e27c9f99f5b303e01daf35c094e1683529a44b67ae", 23518, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-ricoh", "sane-backend-ricoh-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-ricoh-1.4.0-r4.apk", "f104bce6a905c9d283ab5b13f99df9dc11d7542f2de6c5285f26c16569b45e3e", 27130, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-ricoh2", "sane-backend-ricoh2-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-ricoh2-1.4.0-r4.apk", "81e0492ffc13346087c3e62511ecd4821d2b22076ea34dfa2a00595a502113f4", 34844, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-rts8891", "sane-backend-rts8891-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-rts8891-1.4.0-r4.apk", "46a4302f49608057fa3fff576517a617011bbea334b484c89d4b07e0edd97026", 72000, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-s9036", "sane-backend-s9036-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-s9036-1.4.0-r4.apk", "74f264e9535a1f3540615710cc074f19fbffd7eafeaf6b6ed1c1ca67767bd2c9", 26236, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-sceptre", "sane-backend-sceptre-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-sceptre-1.4.0-r4.apk", "0407ca52a69f2296497de897fc2f4253ebc8f3275147b35a793ae3b530006fdd", 29394, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-sharp", "sane-backend-sharp-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-sharp-1.4.0-r4.apk", "8e617e92729af03372e073d4b8bb35ed9b557bb2ec439a01b35a888144bfead2", 38077, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-sm3600", "sane-backend-sm3600-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-sm3600-1.4.0-r4.apk", "b078327d0856abc0017ebf903b347c27f6353747ad2ae9a92ff270ddc4bb0284", 39589, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-sm3840", "sane-backend-sm3840-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-sm3840-1.4.0-r4.apk", "0fbd36b8cce07fe4897f7de2b15116b7d5fd55b0c1f0f7b11c14f0197112c409", 42646, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-snapscan", "sane-backend-snapscan-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-snapscan-1.4.0-r4.apk", "509e7a565b570e7af93adf2436ab84c103fa32ff6cc13cef53689663ec53a4aa", 105027, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-sp15c", "sane-backend-sp15c-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-sp15c-1.4.0-r4.apk", "bdeec7005d4047032f47bfd14cb49afd4cedb88e33745ea21637a53b99c5ae75", 30566, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-st400", "sane-backend-st400-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-st400-1.4.0-r4.apk", "44ee03a27bc3405caf55b4299be29ff2e3c97a0456b3eb5ef6112ad133f8da54", 28069, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-stv680", "sane-backend-stv680-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-stv680-1.4.0-r4.apk", "87197eaebc550b76fd342e5e707e0ca9f758fceba5bd67642bcd784dd88d63af", 40845, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-tamarack", "sane-backend-tamarack-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-tamarack-1.4.0-r4.apk", "46b636e812300f97280d09f8472237f9296e4f9edb6043cbb5da0815e69799cf", 27341, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-teco1", "sane-backend-teco1-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-teco1-1.4.0-r4.apk", "593b6c507d0589331b657f92587b044dcfcb5543f7a4ac67ac92dd75c4588eb8", 29811, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-teco2", "sane-backend-teco2-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-teco2-1.4.0-r4.apk", "dfdba2b6c432ba21980dc021fa461370f4fd913fc1062adaf678e851b3b61c4c", 32670, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-teco3", "sane-backend-teco3-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-teco3-1.4.0-r4.apk", "b99bbc31596f378f22cfdc78b7ad6e1d8453eafc03c5c1d743a4525017574b02", 29907, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-u12", "sane-backend-u12-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-u12-1.4.0-r4.apk", "1034764a4fffcb0d6da915b6911938fc4f323989b4efc7ef0a8ab40242f8ed7f", 60681, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-umax", "sane-backend-umax-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-umax-1.4.0-r4.apk", "3fd969cd1c28b83cf0c8699afac45dcca60f6e99a916b79ef678af49c868e0eb", 78270, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-umax1220u", "sane-backend-umax1220u-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-umax1220u-1.4.0-r4.apk", "dd5b9f7756a532c04cd930baafcf955496799ae8603b1221430416b7a662f25a", 46664, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-umax_pp", "sane-backend-umax_pp-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-umax_pp-1.4.0-r4.apk", "e61dec66ab8bea42b8fabcb930ace5d47983db2a4871380b45f377fd8c98fea5", 156085, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-v4l", "sane-backend-v4l-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-v4l-1.4.0-r4.apk", "234bbcf0d58e358a7e48ae9e5814db53071008391979d56d5e20b746084c484b", 17436, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backend-xerox_mfp", "sane-backend-xerox_mfp-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backend-xerox_mfp-1.4.0-r4.apk", "f51759232dc69c4aef250229aadab55ee02e16575f395a9c4e664ecf42947fc6", 43278, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-backends", "sane-backends-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-backends-1.4.0-r4.apk", "517fe9d0b0626c8b94b77709e602342203abee397423f826fd30c053a0cd93e2", 1760, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-saned", "sane-saned-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-saned-1.4.0-r4.apk", "e0f9b8e5bedfbe770eb46303e1a565bba20b690a9e4186fdb9bde3cbf1d02ab3", 25873, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-udev", "sane-udev-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-udev-1.4.0-r4.apk", "939471386befd639c756aa78e1030a615eb7191e34b5e773c7c2f23a9c375021", 19799, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["sane-utils", "sane-utils-1.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sane-utils-1.4.0-r4.apk", "df8de43130f3f21da6170e6247385e3cf9439efef9985a804ef1a4db57380006", 75972, "GPL-2.0-or-later GPL-2.0-or-later-with-sane-exception Public-Domain", false],
    ["simple-scan", "simple-scan-50.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/simple-scan-50.0-r0.apk", "a7a5b57714bcdcec57e41e4f0cf258413e841315ee0631c9aca2212cd70f9641", 172843, "GPL-3.0-or-later", false],
    ["v4l-utils-libs", "v4l-utils-libs-1.32.0-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/v4l-utils-libs-1.32.0-r1.apk", "63112984a4e69707302ce7487556fb0cb77ddce4838f0024467cabdd353f45b3", 200077, "LGPL-2.0-or-later", false],
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
