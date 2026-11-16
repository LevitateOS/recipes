const RECIPE_API = 1;
// lxqt: a Recipe group, installed into the system root (`recipe --system install lxqt`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps),
// and configure, which writes the look through look.rhai from the OS facts
// (os-facts.rhai). Generated: lxqt.pins beside this file (the pinned packages
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
    kind: "system",
    category: "utilities",
    libc: ["musl"],
    systems: ["acornos"],
    details: "LXQt on X11 (XLibre): the session, panel, runner, settings, notifications, power management, the polkit agent and Openbox, with the picom compositor, gvfs for removable drives, phones, cameras and network shares, the desktop portals, keyboard and monitor settings, notify-send and the Adwaita cursor theme. AcornOS's default desktop; removing it and installing another desktop is how desktops are changed.",
    homepage: "https://lxqt-project.org",
    license: "LGPL-2.1-or-later AND GPL-2.0-or-later AND GPL-3.0-or-later",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "lxqt", description: "The LXQt desktop on X11" };   // version: lxqt.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    musl: [
        "lxqt-desktop", "picom", "gvfs", "gvfs-mtp", "gvfs-gphoto2", "gvfs-smb", "gvfs-nfs", "udisks2",
        "xdg-desktop-portal", "xdg-desktop-portal-lxqt", "setxkbmap", "xrandr", "dbus-x11",
        "adwaita-icon-theme", "breeze-icons"
    ],
};

let deps = ["desktop-libs", "xlibre", "qterminal", "pcmanfm-qt", "lxqt-archiver"];

// What the OS builder's desktop policy did for LXQt, moved here so it goes
// with LXQt: the default applications, the look (LXQt's theme of the
// starting mode with the OS's palette, Breeze icons, Fusion widgets, GTK in
// Adwaita, Openbox's decoration for the mode, the Adwaita cursor), the OS's
// mark on the menu button, touchpads that tap and scroll naturally, menu
// entries that do nothing useful here hidden (Hibernate, the bare
// XScreenSaver daemon), and what a user at the machine may do without the
// administrator's password. The mark is the base's file (the image's
// branding); this only points at it.
fn configure(tree) {
    let os = os_facts::of(PACKAGE_FORMAT);
    let mode = os.appearance;
    let p = look::palette(os, mode);
    let apps = #{ browser: "firefox.desktop", files: "pcmanfm-qt.desktop", image: "lximage-qt.desktop",
                  pdf: "firefox.desktop", archive: "lxqt-archiver.desktop" };
    put(tree, "etc/xdg/mimeapps.list", look::mimeapps(apps), 0o644);

    let cursor = "Adwaita";
    if !is_dir(join_path(tree, "usr/share/icons/" + cursor + "/cursors")) { throw "lxqt: the packages lack the cursor theme " + cursor; }
    put(tree, "usr/share/icons/default/index.theme", "[Icon Theme]\nInherits=" + cursor + "\n", 0o644);
    if !is_dir(join_path(tree, "usr/share/lxqt/themes/" + mode)) { throw "lxqt: the packages lack the LXQt theme " + mode; }
    let conf = tree_text(tree, "usr/share/lxqt/lxqt.conf");
    conf = look::ini_set(conf, "General", "theme", mode);
    conf = look::ini_set(conf, "General", "icon_theme", look::icon_theme(mode));
    conf = look::ini_set(conf, "Qt", "style", "Fusion");
    for pair in [["window_color", p.surface], ["window_text_color", p.text], ["base_color", p.surface_raised],
                 ["text_color", p.text], ["highlight_color", p.accent], ["highlighted_text_color", p.surface],
                 ["link_color", p.accent], ["link_visited_color", p.highlight],
                 ["tooltip_base_color", p.surface_raised], ["tooltip_text_color", p.text]] {
        conf = look::ini_set(conf, "Palette", pair[0], pair[1]);
    }
    put(tree, "etc/xdg/lxqt/lxqt.conf", conf, 0o644);
    let gtk = "[Settings]\ngtk-theme-name=Adwaita\ngtk-icon-theme-name=" + look::icon_theme(mode) + "\ngtk-cursor-theme-name=" + cursor + "\ngtk-font-name=Sans 11\n";
    gtk += "gtk-application-prefer-dark-theme=" + (if mode == "dark" { "true" } else { "false" }) + "\n";
    put(tree, "etc/gtk-3.0/settings.ini", gtk, 0o644);
    put(tree, "etc/gtk-4.0/settings.ini", gtk, 0o644);
    let decoration = if mode == "dark" { "Onyx" } else { "Clearlooks" };
    tree_text(tree, "usr/share/themes/" + decoration + "/openbox-3/themerc");
    let rc = "etc/xdg/openbox/rc.xml";
    let xml = tree_text(tree, rc);
    let theme = xml.index_of("<theme>");
    let open = if theme < 0 { -1 } else { xml.index_of("<name>", theme) };
    let close = if open < 0 { -1 } else { xml.index_of("</name>", open) };
    if close < 0 { throw "lxqt: Openbox's settings name no theme"; }
    put(tree, rc, xml.sub_string(0, open + 6) + decoration + xml.sub_string(close), 0o644);

    // The OS's mark on the menu button.
    let icon = "usr/share/icons/hicolor/scalable/apps/distributor-logo-" + os.id + ".svg";
    let panel = "etc/xdg/lxqt/panel.conf";
    let text = tree_text(tree, panel);
    if !text.contains("[fancymenu]\n") { throw "lxqt: the panel's settings have no fancymenu button"; }
    put(tree, panel, text.replace("[fancymenu]\n", "[fancymenu]\nownIcon=true\nicon=/" + icon + "\n"), 0o644);

    for name in ["lxqt-hibernate.desktop", "xscreensaver.desktop"] {
        let path = "usr/share/applications/" + name;
        let entry = tree_text(tree, path);
        if !entry.contains("[Desktop Entry]\n") || entry.contains("\nNoDisplay=") { throw "lxqt: the menu entry " + name + " is not one this recipe can hide"; }
        put(tree, path, entry.replace("[Desktop Entry]\n", "[Desktop Entry]\nNoDisplay=true\n"), 0o644);
    }
    put(tree, "etc/X11/xorg.conf.d/40-touchpad.conf",
        "Section \"InputClass\"\n    Identifier \"touchpad defaults\"\n    MatchIsTouchpad \"on\"\n    Driver \"libinput\"\n    Option \"Tapping\" \"on\"\n    Option \"NaturalScrolling\" \"true\"\nEndSection\n",
        0o644);
    put(tree, "usr/share/polkit-1/rules.d/50-" + os.id + "-desktop.rules", look::desktop_polkit_rules(), 0o644);
}
