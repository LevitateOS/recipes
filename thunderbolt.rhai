const RECIPE_API = 1;
// thunderbolt: a Recipe group, installed into the system root (`recipe --system install thunderbolt`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: thunderbolt.pins beside this file (the pinned packages and
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
    kind: "system",
    category: "drivers-codecs",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "bolt, which authorises Thunderbolt devices; Plasma's settings page for it on LevitateOS.",
    homepage: "https://gitlab.freedesktop.org/bolt/bolt",
    license: "LGPL-2.1-or-later",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "thunderbolt", description: "Thunderbolt device authorisation" };   // version: thunderbolt.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["bolt", "plasma-thunderbolt"],
    musl:  ["bolt"],
};

let deps = ["desktop-libs"];
