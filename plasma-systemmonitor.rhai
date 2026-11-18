const RECIPE_API = 1;
// plasma-systemmonitor: a Recipe group, installed into the system root (`recipe --system install plasma-systemmonitor`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: plasma-systemmonitor.pins beside this file (the pinned packages and
// the group's version), written by `cargo xtask base groups levitate` (glibc:
// Fedora RPMs) and `cargo xtask base groups acorn` (musl: Alpine APKs) from the
// seeds below. A package more than one group needs belongs to desktop-libs.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "kojipkgs.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "app",
    category: "utilities",
    libc: ["glibc"],
    systems: ["levitateos"],
    details: "System Monitor shows processes, CPU, memory, disk and network use, and ends programs.",
    homepage: "https://apps.kde.org/plasma-systemmonitor/",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["plasma-systemmonitor"], menu: ["System Monitor"] },
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "plasma-systemmonitor", description: "KDE's system monitor" };   // version: plasma-systemmonitor.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["plasma-systemmonitor"],
};

let deps = ["desktop-libs"];
