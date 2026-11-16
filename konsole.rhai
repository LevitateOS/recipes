const RECIPE_API = 1;
// konsole: a Recipe group, installed into the system root (`recipe --system install konsole`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps),
// and configure, which writes the look through look.rhai from the OS facts
// (os-facts.rhai). Generated: konsole.pins beside this file (the pinned packages
// and the group's version), written by `cargo xtask base groups levitate`
// (glibc: Fedora RPMs) and `cargo xtask base groups acorn` (musl: Alpine APKs)
// from the seeds below. A package more than one group needs belongs to
// desktop-libs.
import "os-facts.rhai" as os_facts;
import "look.rhai" as look;

const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "app",
    category: "utilities",
    libc: ["glibc"],
    systems: ["levitateos"],
    details: "Konsole, the terminal of the Plasma desktop, with tabs, split views and profiles.",
    homepage: "https://konsole.kde.org",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["konsole"], menu: ["Konsole"] },
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "konsole", description: "KDE's terminal" };   // version: konsole.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["konsole"],
};

let deps = ["desktop-libs"];

// Konsole's colours: the OS's terminal schemes in both modes, and a default
// profile on the dark one (a terminal is dark on both distros).
fn configure(tree) {
    let os = os_facts::of(PACKAGE_FORMAT);
    for m in ["light", "dark"] {
        put(tree, "usr/share/konsole/" + look::scheme_name(os, m) + ".colorscheme", look::terminal_scheme(os, m), 0o644);
    }
    let profile = os.name.replace(" ", "");
    put(tree, "usr/share/konsole/" + profile + ".profile",
        "[Appearance]\nColorScheme=" + look::scheme_name(os, "dark") + "\n\n[General]\nName=" + profile + "\nParent=FALLBACK/\n", 0o644);
    let rc = read_file_or_empty(join_path(tree, "etc/xdg/konsolerc"));
    put(tree, "etc/xdg/konsolerc", look::ini_set(rc, "Desktop Entry", "DefaultProfile", profile + ".profile"), 0o644);
}
