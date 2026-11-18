const RECIPE_API = 1;
// audio: a Recipe group, installed into the system root (`recipe --system install audio`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: audio.pins beside this file (the pinned packages and
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
    category: "media",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "PipeWire with WirePlumber as its session manager, and the PulseAudio and ALSA routes into it, so every program's sound plays.",
    homepage: "https://pipewire.org",
    license: "MIT AND LGPL-2.1-or-later",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "audio", description: "Sound: PipeWire and WirePlumber" };   // version: audio.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["pipewire", "pipewire-pulseaudio", "pipewire-alsa", "wireplumber"],
    musl:  ["pipewire", "pipewire-pulse", "pipewire-alsa", "wireplumber"],
};

// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS = #{ musl: ["g pipewire -"] };

let deps = ["desktop-libs"];

fn configure(tree) {
    if PACKAGE_FORMAT != "rpm" { return; }
    let units = "/usr/lib/systemd/user/";
    for unit in ["pipewire.socket", "pipewire-pulse.socket", "wireplumber.service"] { tree_text(tree, units.sub_string(1) + unit); }
    put_link(tree, "etc/systemd/user/sockets.target.wants/pipewire.socket", units + "pipewire.socket");
    put_link(tree, "etc/systemd/user/sockets.target.wants/pipewire-pulse.socket", units + "pipewire-pulse.socket");
    put_link(tree, "etc/systemd/user/pipewire.service.wants/wireplumber.service", units + "wireplumber.service");
    put_link(tree, "etc/systemd/user/pipewire-session-manager.service", units + "wireplumber.service");
}
