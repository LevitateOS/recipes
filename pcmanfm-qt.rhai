const RECIPE_API = 1;
// pcmanfm-qt: a Recipe group, installed into the system root (`recipe --system install pcmanfm-qt`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps),
// and configure, which writes the look through look.rhai from the OS facts
// (os-facts.rhai). Generated: pcmanfm-qt.pins beside this file (the pinned packages
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
    details: "PCManFM-Qt, the file manager of LXQt, which also draws the desktop and its icons.",
    homepage: "https://github.com/lxqt/pcmanfm-qt",
    license: "GPL-2.0-or-later",
    adds: #{ programs: ["pcmanfm-qt"], menu: ["PCManFM-Qt File Manager"] },
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "pcmanfm-qt", description: "LXQt's file manager and desktop" };   // version: pcmanfm-qt.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    musl: ["pcmanfm-qt"],
};

let deps = ["desktop-libs"];

// pcmanfm-qt draws the LXQt desktop: its packaged settings with the OS's
// wallpaper of the starting mode (the base's file), the mode's icons and the
// desktop's text in the mode's colours, in /etc/xdg ahead of the packaged file.
fn configure(tree) {
    let os = os_facts::of(PACKAGE_FORMAT);
    let mode = os.appearance;
    let p = look::palette(os, mode);
    let text = tree_text(tree, "usr/share/pcmanfm-qt/lxqt/settings.conf");
    for key in ["Wallpaper=", "WallpaperMode=", "BgColor=", "FgColor=", "ShadowColor="] {
        if !text.contains("\n" + key) { throw "pcmanfm-qt: its desktop settings have no " + key; }
    }
    let shown = "/usr/share/wallpapers/" + os.name + (if mode == "dark" { "/contents/images_dark/3840x2160.jpg" } else { "/contents/images/3840x2160.jpg" });
    text = look::ini_set(text, "System", "IconThemeName", look::icon_theme(mode));
    text = look::ini_set(text, "Desktop", "Wallpaper", shown);
    text = look::ini_set(text, "Desktop", "WallpaperMode", "zoom");
    text = look::ini_set(text, "Desktop", "BgColor", p.surface);
    text = look::ini_set(text, "Desktop", "FgColor", p.text);
    text = look::ini_set(text, "Desktop", "ShadowColor", p.surface);
    put(tree, "etc/xdg/pcmanfm-qt/lxqt/settings.conf", text, 0o644);
}
