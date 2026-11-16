const RECIPE_API = 1;
// login-screen: a Recipe group, installed into the system root (`recipe --system install login-screen`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: login-screen.pins beside this file (the pinned packages and
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

import "os-facts.rhai" as os_facts;

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["musl"],
    systems: ["acornos"],
    details: "SDDM, the graphical login screen; on LevitateOS with Plasma's Breeze theme and Wayland greeter. It lists whatever sessions the installed desktops provide.",
    homepage: "https://github.com/sddm/sddm",
    license: "GPL-2.0-or-later",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "login-screen", description: "The SDDM login screen" };   // version: login-screen.pins

// What this group installs, by name; the generator adds what they need.
// musl: AcornOS (Alpine 3.24) only; on LevitateOS SDDM is part of plasma, so
// there are no glibc seeds and no glibc build.
const PACKAGES = #{ musl: ["sddm"] };

// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Alpine packages
// make theirs in install scripts, which never run, so the lines are written
// here from those scripts.
const ACCOUNTS = #{
    musl: ["g sddm -", "u sddm - 'SDDM display manager' /var/lib/sddm /sbin/nologin", "m sddm video"],
};

let deps = ["desktop-libs"];

// The login screen on AcornOS (on LevitateOS SDDM is part of plasma): SDDM
// starts at boot after dbus and elogind; SDDM's own Maldives theme under the
// OS's name (Alpine's copy does not say it is for the Qt 6 greeter, the only
// one Alpine has) with the starting mode's wallpaper (the base's file) and
// the Adwaita cursor. Alpine's sddm service waits in start_post for the
// greeter's runtime directory, which an autologin never makes; its conf.d,
// sourced before the service script, makes that wait succeed.
fn configure(tree) {
    let os = os_facts::of(PACKAGE_FORMAT);
    let background = "/usr/share/wallpapers/" + os.name + (if os.appearance == "dark" { "/contents/images_dark/3840x2160.jpg" } else { "/contents/images/3840x2160.jpg" });
    let themes = "usr/share/sddm/themes/";
    let theme = os.id;
    let packaged = themes + "maldives/";
    let meta = tree_text(tree, packaged + "metadata.desktop");
    for file in ["Main.qml", "angle-down.png", "rectangle.png"] {
        mkdir(join_path(tree, themes + theme));
        copy_file(join_path(tree, packaged + file), join_path(tree, themes + theme + "/" + file));
        target_mode(tree, themes + theme + "/" + file, 0o644);
    }
    let metadata = "";
    for line in meta.split("\n") {
        if line.starts_with("Name=") { line = "Name=" + os.name; }
        else if line.starts_with("Theme-Id=") { line = "Theme-Id=" + theme; }
        else if line.starts_with("Screenshot=") || line.starts_with("QtVersion=") || line == "" { continue; }
        metadata += line + "\n";
    }
    put(tree, themes + theme + "/metadata.desktop", metadata + "QtVersion=6\n", 0o644);
    put(tree, themes + theme + "/theme.conf", "[General]\nbackground=" + background + "\n", 0o644);
    put(tree, "etc/sddm.conf.d/10-theme.conf", "[Theme]\nCurrent=" + theme + "\nCursorTheme=Adwaita\n", 0o644);
    let conf = "etc/conf.d/sddm";
    let text = read_file_or_empty(join_path(tree, conf));
    if text != "" && !text.ends_with("\n") { text += "\n"; }
    text += "# The desktop system (installed-system.rhai): start_post's wait for the\n";
    text += "# greeter's runtime directory succeeds, since an autologin starts no greeter.\n";
    text += "ewaitfile() { return 0; }\n";
    put(tree, conf, text, 0o644);
    enable_service(tree, "", "sddm");
}
