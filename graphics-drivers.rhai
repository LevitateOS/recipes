const RECIPE_API = 1;
// graphics-drivers: a Recipe group, installed into the system root (`recipe --system install graphics-drivers`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: graphics-drivers.pins beside this file (the pinned packages and
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
    kind: "system",
    category: "drivers-codecs",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "Mesa's open drivers for OpenGL and Vulkan, its VA-API video decoding, and Intel's media driver.",
    homepage: "https://mesa3d.org",
    license: "MIT AND BSD-3-Clause",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "graphics-drivers", description: "Mesa's OpenGL, Vulkan and video decoding drivers" };   // version: graphics-drivers.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["mesa-vulkan-drivers", "libva-intel-media-driver"],
    musl:  ["mesa-dri-gallium", "mesa-va-gallium", "intel-media-driver", "mesa-vulkan-intel", "mesa-vulkan-ati"],
};

let deps = ["desktop-libs"];
