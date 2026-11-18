const RECIPE_API = 1;
// screen-reader: a Recipe group, installed into the system root (`recipe --system install screen-reader`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: screen-reader.pins beside this file (the pinned packages and
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
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "Orca reads the screen aloud through Speech Dispatcher and the eSpeak NG voice; AcornOS adds the Onboard on-screen keyboard.",
    homepage: "https://orca.gnome.org",
    license: "LGPL-2.1-or-later AND GPL-2.0-or-later AND GPL-3.0-or-later",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "screen-reader", description: "The Orca screen reader, with speech" };   // version: screen-reader.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["orca", "speech-dispatcher", "speech-dispatcher-espeak-ng", "espeak-ng"],
    musl:  ["orca", "speech-dispatcher", "espeak-ng", "onboard"],
};

let deps = ["desktop-libs", "audio", "spelling"];

// Alpine's onboard package ships a compiled GSettings cache of its own
// (usr/share/glib-2.0/schemas/gschemas.compiled). The root effects recipe
// writes that same path for the whole root, with every installed schema, so
// the file stays out of this group: two packages may not own one path with
// different content. The schema XML files stay; the effects recipe compiles them.
fn configure(tree) {
    if PACKAGE_FORMAT == "apk" {
        let compiled = join_path(tree, "usr/share/glib-2.0/schemas/gschemas.compiled");
        if exists(compiled) { rm(compiled); }
    }
}
