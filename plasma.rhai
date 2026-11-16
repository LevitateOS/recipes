const RECIPE_API = 1;
// plasma: a Recipe group, installed into the system root (`recipe --system install plasma`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps),
// and configure, which writes the look through look.rhai from the OS facts
// (os-facts.rhai). Generated: plasma.pins beside this file (the pinned packages
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
    libc: ["glibc"],
    systems: ["levitateos"],
    details: "KDE Plasma on Wayland: the workspace and panel, KWin with Xwayland for X11 programs, sound and screen settings, power management, the system information centre, GTK theming, the Breeze theme and icons, the desktop portal, the polkit agent, the wallet unlocked at login and the crash handler, with battery state, power profiles and mounting removable drives. LevitateOS's default desktop; removing it and installing another desktop is how desktops are changed.",
    homepage: "https://kde.org/plasma-desktop/",
    license: "GPL-2.0-or-later AND LGPL-2.1-or-later AND GPL-3.0-or-later",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "plasma", description: "The KDE Plasma desktop on Wayland" };   // version: plasma.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
// kf6-kimageformats: the image formats KDE's programs and thumbnails read
// beyond Qt's own (AVIF and others).
const PACKAGES = #{
    glibc: [
        "plasma-desktop", "plasma-workspace", "kwin", "xorg-x11-server-Xwayland", "plasma-pa",
        "powerdevil", "kscreen", "kinfocenter", "kde-gtk-config", "breeze-gtk",
        "xdg-desktop-portal-kde", "polkit-kde", "kwalletmanager5", "pam-kwallet", "upower",
        "power-profiles-daemon", "udisks2", "kf6-kimageformats"
    ],
};

let deps = ["desktop-libs", "audio", "fonts", "spelling"];

// What the OS builder's desktop policy did for Plasma, moved here so it goes
// with Plasma: power profiles at boot, Recipe as the software app on the
// panel and in the menu's favourites (Discover is not shipped), the default
// applications, the look (colour schemes from the OS's
// palettes, the Global Theme of the starting mode, Breeze icons and cursor),
// the OS's mark on the start button, the OS's wallpaper as Plasma's default,
// and what a user at the machine may do without the administrator's
// password. The wallpapers and the mark are the base's files (the image's
// branding); this only points at them.
fn configure(tree) {
    let os = os_facts::of(PACKAGE_FORMAT);
    let mode = os.appearance;
    enable_service(tree, "power-profiles-daemon.service", "");
    // Nothing provides the Unity GTK module its user unit starts.
    put_link(tree, "etc/systemd/user/unity-gtk-module.service", "/dev/null");

    // The default application for each kind of file.
    let apps = #{ browser: "org.mozilla.firefox.desktop", files: "org.kde.dolphin.desktop", text: "org.kde.kwrite.desktop",
                  image: "org.mozilla.firefox.desktop", pdf: "org.mozilla.firefox.desktop", archive: "org.kde.ark.desktop" };
    put(tree, "etc/xdg/mimeapps.list", look::mimeapps(apps), 0o644);

    // Recipe in Discover's place on the panel, in the menu's favourites, and
    // not as the handler of .rpm files.
    let recipe = "org.levitateos.recipe.desktop";
    let panel = "usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js";
    let tasks = "panel.addWidget(\"org.kde.plasma.icontasks\")";
    let text = tree_text(tree, panel);
    if !text.contains(tasks) { throw "plasma: the default panel no longer adds the icon task manager"; }
    let launchers = "applications:systemsettings.desktop,applications:" + recipe + ",preferred://filemanager,preferred://browser";
    put(tree, panel, text.replace(tasks, "var tasks = " + tasks + "\ntasks.currentConfigGroup = [\"General\"]\ntasks.writeConfig(\"launchers\", \"" + launchers + "\")"), 0o644);
    let profile = "usr/share/kde-settings/kde-profile/default/xdg/";
    text = tree_text(tree, profile + "kicker-extra-favoritesrc");
    if !text.contains(";org.kde.discover.desktop") { throw "plasma: Fedora's menu favourites no longer list Discover"; }
    put(tree, profile + "kicker-extra-favoritesrc", text.replace(";org.kde.discover.desktop", ";" + recipe), 0o644);
    text = tree_text(tree, profile + "kde-mimeapps.list");
    if !text.contains("=org.kde.discover.desktop\n") { throw "plasma: Fedora's default applications no longer name Discover"; }
    put(tree, profile + "kde-mimeapps.list", text.replace("application/x-rpm=org.kde.discover.desktop\n", ""), 0o644);

    // The OS's mark on a new start button, in place of Fedora's start-here.
    let name = "distributor-logo-" + os.id;
    let fedora_icon = "writeConfig(\"icon\", \"start-here\")";
    let set = 0;
    for flavour in ["fedora", "fedoradark", "fedoralight"] {
        let dir = "usr/share/plasma/look-and-feel/org.fedoraproject." + flavour + ".desktop/contents/plasmoidsetupscripts";
        for file in glob_list(join_path(tree, dir) + "/*.js") {
            let script = read_file(file);
            if !script.contains(fedora_icon) { continue; }
            let path = dir + "/" + basename(file);
            put(tree, path, script.replace(fedora_icon, "writeConfig(\"icon\", \"" + name + "\")"), 0o644);
            set += 1;
        }
    }
    if set == 0 { throw "plasma: the Global Themes no longer set the launcher's icon to start-here"; }

    // The look: one cursor theme everywhere, the OS's colour schemes, the
    // starting mode's Global Theme naming them, Breeze icons of that mode.
    // The fallback cursor theme file (usr/share/icons/default/index.theme)
    // is libXcursor's, in desktop-libs, so Plasma names its cursor in its own
    // settings instead (KWin and the KDE apps read kcminputrc).
    tree_text(tree, "usr/share/icons/breeze_cursors/index.theme");
    put(tree, "etc/xdg/kcminputrc", "[Mouse]\ncursorTheme=breeze_cursors\n", 0o644);
    let lnf = "usr/share/plasma/look-and-feel/";
    let theme = if mode == "dark" { "org.fedoraproject.fedoradark.desktop" } else { "org.fedoraproject.fedoralight.desktop" };
    for m in ["light", "dark"] {
        put(tree, "usr/share/color-schemes/" + look::scheme_name(os, m) + ".colors", look::kde_colour_scheme(os, m), 0o644);
    }
    let found = false;
    for pair in [["org.fedoraproject.fedora.desktop", "BreezeLight", "light"], ["org.fedoraproject.fedoralight.desktop", "BreezeLight", "light"],
                 ["org.fedoraproject.fedoradark.desktop", "BreezeDark", "dark"]] {
        let defaults = lnf + pair[0] + "/contents/defaults";
        if !is_file(join_path(tree, defaults)) { continue; }
        let t = read_file(join_path(tree, defaults));
        let packaged = "ColorScheme=" + pair[1] + "\n";
        if !t.contains(packaged) { continue; }
        put(tree, defaults, t.replace(packaged, "ColorScheme=" + look::scheme_name(os, pair[2]) + "\n"), 0o644);
        if pair[0] == theme { found = true; }
    }
    if !found { throw "plasma: the Global Theme " + theme + " no longer names a Breeze colour scheme"; }
    let globals = "[KDE]\nLookAndFeelPackage=" + theme + "\n\n";
    globals += "[General]\nColorScheme=" + look::scheme_name(os, mode) + "\naccentColorFromWallpaper=false\n\n";
    globals += "[Icons]\nTheme=" + look::icon_theme(mode) + "\n\n";
    globals += look::kde_colour_groups(os, mode);
    put(tree, "etc/xdg/kdeglobals", globals, 0o644);
    let about = "[General]\nLogoPath=/usr/share/icons/hicolor/scalable/apps/" + name + ".svg\nVariant=Desktop\n";
    if os.home_url != "" { about += "Website=" + os.home_url + "\n"; }
    put(tree, "etc/xdg/kcm-about-distrorc", about, 0o644);

    // Plasma's default wallpaper package is the OS's (Fedora's points
    // "Default" at Fedora's own).
    if !exists(join_path(tree, "usr/share/wallpapers/Fedora")) { throw "plasma: the packages no longer take their wallpaper from /usr/share/wallpapers/Default"; }
    put_link(tree, "usr/share/wallpapers/Default", os.name);

    put(tree, "usr/share/polkit-1/rules.d/50-" + os.id + "-desktop.rules", look::desktop_polkit_rules(), 0o644);

    // Guest defaults (docs/reclogin-guest.md): the login screen copies
    // /usr/share/reclogin/guest-home/ into the guest's new home at every
    // guest login. The guest has no password, so a locked screen could never
    // be opened, and a wallet that asks to be created is noise in a session
    // that is thrown away. Plain files nothing else reads: harmless without
    // the login screen.
    //  kscreenlockerrc (kscreenlocker's kscreenlockersettings.kcfg, group
    //  Daemon): no automatic lock after idle (Autolock), none when the
    //  screen blanks (Lock), none on suspend (LockOnResume); and a lock by
    //  the shortcut needs no password (RequirePassword=false makes it a
    //  grace lock that any input ends).
    //  kdeglobals: KAuthorized's action restriction lock_screen, which
    //  kscreenlocker checks before it registers the lock shortcut and before
    //  it answers the Lock D-Bus call (the menu's Lock Screen).
    //  kwalletrc (kwallet's kwalletsettings.kcfg): the wallet daemons stay off
    //  and the first-use wizard is marked done.
    let guest = "usr/share/reclogin/guest-home/.config/";
    put(tree, guest + "kscreenlockerrc", "[Daemon]\nAutolock=false\nLock=false\nLockOnResume=false\nLockOnStart=false\nRequirePassword=false\n", 0o644);
    put(tree, guest + "kdeglobals", "[KDE Action Restrictions]\naction/lock_screen=false\n", 0o644);
    put(tree, guest + "kwalletrc", "[Wallet]\nEnabled=false\nFirst Use=false\n\n[KSecretD]\nEnabled=false\n", 0o644);
}
