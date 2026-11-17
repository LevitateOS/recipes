const RECIPE_API = 1;
// network: a Recipe group, installed into the system root (`recipe --system install network`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: network.pins beside this file (the pinned packages
// and the group's version), written by `cargo xtask base groups levitate`
// (glibc: Fedora RPMs) and `cargo xtask base groups acorn` (musl: Alpine APKs)
// from the seeds below. A package more than one group needs belongs to
// desktop-libs.
//
// Recipe downloads the pins for this system, unpacks them into one system tree
// without running their scripts (var/ only as state seeds), calls configure,
// and finishes the tree with the accounts below.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "NetworkManager and its WiFi support over wpa_supplicant, which bring wired and wireless networks up and keep them up; nmcli comes with it.",
    homepage: "https://networkmanager.dev",
    license: "GPL-2.0-or-later AND LGPL-2.1-or-later AND BSD-3-Clause",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "network", description: "NetworkManager, with WiFi" };   // version: network.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["NetworkManager", "NetworkManager-wifi", "wpa_supplicant"],
    musl:  ["networkmanager", "networkmanager-cli", "networkmanager-wifi", "wpa_supplicant"],
};

// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS = #{ musl: ["g plugdev -"] };

let deps = ["desktop-libs"];

// NetworkManager starts at boot: this group enables it, in the system root it
// is installed into and in the live overlay.
fn configure(tree) {
    enable_service(tree, "NetworkManager.service", "networkmanager");
}
