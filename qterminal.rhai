const RECIPE_API = 1;
// qterminal: a Recipe group, installed into the system root (`recipe --system install qterminal`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps),
// and configure, which writes the look through look.rhai from the OS facts
// (os-facts.rhai). Generated: qterminal.pins beside this file (the pinned packages
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
    libc: ["musl"],
    systems: ["acornos"],
    details: "QTerminal, the terminal of the LXQt desktop.",
    homepage: "https://github.com/lxqt/qterminal",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["qterminal"], menu: ["QTerminal"] },
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "qterminal", description: "LXQt's terminal" };   // version: qterminal.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    musl: ["qterminal"],
};

let deps = ["desktop-libs"];

// QTerminal's colours: the OS's terminal schemes in both modes in
// QTermWidget's folder, and the dark one as the default (a terminal is dark
// on both distros).
fn configure(tree) {
    let os = os_facts::of(PACKAGE_FORMAT);
    let schemes = "usr/share/qtermwidget6/color-schemes/";
    if !is_dir(join_path(tree, schemes)) { throw "qterminal: QTermWidget's colour schemes are missing"; }
    for m in ["light", "dark"] {
        put(tree, schemes + look::scheme_name(os, m) + ".colorscheme", look::terminal_scheme(os, m), 0o644);
    }
    put(tree, "etc/xdg/qterminal.org/qterminal.ini", "[General]\ncolorScheme=" + look::scheme_name(os, "dark") + "\n", 0o644);
}
