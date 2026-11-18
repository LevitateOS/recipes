const RECIPE_API = 1;
// drkonqi: a Recipe group, installed into the system root (`recipe --system install drkonqi`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: drkonqi.pins beside this file (the pinned packages and
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
    details: "DrKonqi shows what happened when a KDE program crashes and helps report it. Fedora's build needs Konsole.",
    homepage: "https://invent.kde.org/plasma/drkonqi",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["drkonqi"], menu: [] },
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "drkonqi", description: "KDE's crash handler" };   // version: drkonqi.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["plasma-drkonqi"],
};

let deps = ["desktop-libs", "plasma", "konsole"];
