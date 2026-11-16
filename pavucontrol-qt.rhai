const RECIPE_API = 1;
// pavucontrol-qt: a Recipe group, installed into the system root (`recipe --system install pavucontrol-qt`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: pavucontrol-qt.pins beside this file (the pinned packages and
// the group's version), written by `cargo xtask base groups levitate` (glibc:
// Fedora RPMs) and `cargo xtask base groups acorn` (musl: Alpine APKs) from the
// seeds below. A package more than one group needs belongs to desktop-libs.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "app",
    category: "media",
    libc: ["musl"],
    systems: ["acornos"],
    details: "PulseAudio Volume Control (Qt) sets volumes and devices per program, over PipeWire.",
    homepage: "https://github.com/lxqt/pavucontrol-qt",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["pavucontrol-qt"], menu: ["PulseAudio Volume Control"] },
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "pavucontrol-qt", description: "Sound volume and device settings" };   // version: pavucontrol-qt.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    musl:  ["pavucontrol-qt"],
};

let deps = ["desktop-libs"];
