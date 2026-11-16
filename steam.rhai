const RECIPE_API = 1;
// steam: Valve's Steam launcher, installed into the system root (`recipe --system install steam`)
// with a receipt, so it can be removed like any other recipe. LevitateOS only:
// Steam is an upstream glibc program that needs 32-bit glibc libraries (lib32),
// and AcornOS's musl base cannot run it (docs/product-handoff.md, section 2.5);
// ABOUT.libc and ABOUT.systems say so, and there is no musl build.
//
// What it installs, and where each part comes from (2026-11-15):
// - The launcher, from Valve's own server: the steam-launcher tarball 1.0.0.87,
//   https://repo.steampowered.com/steam/archive/stable/steam_1.0.0.87.tar.gz,
//   SHA-256 of our own download (Valve publishes the archive's checksum only in
//   its signed apt Release files; the pin is trust on first use of the bytes
//   served on 2026-11-15, 20409598 bytes). Fetched by this recipe on the user's
//   machine and never mirrored or redistributed by LevitateOS. The tarball
//   carries the launcher script (bin_steam.sh, installed as /usr/bin/steam),
//   the client bootstrap (bootstraplinux_ubuntu12_32.tar.xz, which the
//   launcher unpacks into ~/.local/share/Steam on first start), the menu entry,
//   the icons, the AppStream file, the manual page and Valve's licence. Placed
//   as Valve's own Makefile places them (`make install`), less what Fedora's
//   package also leaves out: the apt source list and key, steamdeps (an apt
//   tool) and its Python module.
// - The controller and VR headset device rules (steam-devices), from the same
//   tarball (subprojects/steam-devices, MIT, the source of
//   https://github.com/ValveSoftware/steam-devices): usr/lib/udev/rules.d.
// - One change to Valve's launcher script, the one Fedora's package makes
//   (RPM Fusion steam-no-icon-on-desktop.patch): it does not copy steam.desktop
//   onto the user's desktop on first start.
// - The file-descriptor limit Proton's esync needs, as Fedora's package sets
//   it (RPM Fusion 01-steam.conf): systemd system.conf.d and user.conf.d.
// - The 32-bit libraries, from the lib32 group (deps).
// - The 64-bit programs Fedora's package requires that today's locks lack:
//   zenity (the launcher's dialogs) and xz (the launcher unpacks the
//   bootstrap with `tar xJf`): this group's seeds.
//   Fedora's other 64-bit requirements are already in the system: Mesa and the
//   Vulkan loader (desktop-libs, graphics-drivers), the X11, sound, NSS and
//   NetworkManager client libraries (desktop-libs, network, the base), polkit
//   and the PipeWire services (audio), xdg-desktop-portal (desktop-libs) and
//   Xwayland (plasma). The source for that list: RPM Fusion nonfree `steam`
//   1.0.0.87-4, https://github.com/rpmfusion/steam/blob/master/steam.spec,
//   and Valve's steam-launcher/debian/control (steam-launcher, steam-libs-amd64).
//   Not taken: Valve's Debian-only Depends (apt, python3-apt, xterm, file,
//   lsof), and Fedora's Recommends (gamemode, gamescope, mangohud,
//   ntsync-autoload) and its SteamVR helper (holo-grant-cap-sys-nice).
//
// Hand-written: ABOUT, Valve's source and files, the seeds and the groups it
// needs (deps). Generated: steam.pins beside this file (the pinned packages
// and the group's version), written by `cargo xtask base groups levitate`.
// NEEDS.network_max_bytes is Valve's tarball (20409598 bytes); Recipe adds the
// pins' bytes.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "repo.steampowered.com:443"],
    network_max_bytes: 20971520,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "app",
    category: "games",
    libc: ["glibc"],
    systems: ["levitateos"],
    details: "Valve's Steam: the store, library and launcher for games, Counter-Strike 2 among them. This installs Valve's Steam launcher, the menu entry and icon, the device rules that let Steam controllers, other game pads and VR headsets work without root, and the 32-bit libraries Steam and its runtime load (the lib32 group). On first start the launcher downloads the Steam client from Valve into ~/.local/share/Steam. The Steam client updates itself there, from Valve, every time it starts, and it has no setting to turn that off: Recipe installs and updates the launcher, the device rules and the libraries, and the client and the games are Steam's own. Graphics: the system's own drivers are Mesa's (OpenGL and Vulkan, 64- and 32-bit), meant for AMD and Intel graphics; on NVIDIA they are nouveau and its Vulkan driver. For NVIDIA's proprietary driver, install its recipe, which must bring its 32-bit libraries too; that recipe is still to be written. Games run in Steam's runtime container (Steam Linux Runtime), which needs unprivileged user namespaces in the kernel. Needs a Steam account and network access to Valve. Steam is proprietary software under Valve's Steam Subscriber Agreement; the recipe downloads it from Valve and LevitateOS does not redistribute it. Built for glibc and LevitateOS; AcornOS (musl) cannot run it.",
    homepage: "https://store.steampowered.com/about/",
    license: "proprietary (Valve: Steam Subscriber Agreement) AND MIT (steam-devices); Fedora packages under their own licences",
    adds: #{ programs: ["steam"], menu: ["Steam"] },
    steps: #{
        download: "Downloads Valve's pinned Steam launcher tarball from repo.steampowered.com and checks its SHA-256, and takes each pinned Fedora package by its SHA-256 from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the Fedora packages natively into one system tree, without running their scripts, places Valve's launcher, client bootstrap, menu entry, icons and device rules in it (nothing is compiled), and writes the tree into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "steam", description: "Valve's Steam launcher and what it needs" };   // version: steam.pins

// What this group installs, by name; the generator adds what they need.
// LevitateOS (glibc, Fedora 45): what Fedora's steam package requires
// (Requires: zenity, xz) and no other group installs. AcornOS (musl): Steam
// does not run there, so there are no musl seeds and no musl build.
const PACKAGES = #{ glibc: ["zenity", "xz"] };

let deps = ["desktop-libs", "lib32", "graphics-drivers"];

// Valve's launcher tarball 1.0.0.87 (glibc only, like the group).
const SOURCES = #{
    valve: #{
        url: "https://repo.steampowered.com/steam/archive/stable/steam_1.0.0.87.tar.gz",
        sha256: "649375d2f9377f8009aaf3e2ff09978041eb9114897d9c5a3886f1d82e27ba1f",
        libc: "glibc",
    },
};

// From Valve's tarball into the tree (its top folder steam-launcher/ is left
// out), as Valve's own Makefile places them.
const FILES = [
    ["valve/bootstraplinux_ubuntu12_32.tar.xz",              "usr/lib/steam/bootstraplinux_ubuntu12_32.tar.xz"],
    ["valve/steam.desktop",                                  "usr/share/applications/steam.desktop"],
    ["valve/icons/16/steam.png",                             "usr/share/icons/hicolor/16x16/apps/steam.png"],
    ["valve/icons/24/steam.png",                             "usr/share/icons/hicolor/24x24/apps/steam.png"],
    ["valve/icons/32/steam.png",                             "usr/share/icons/hicolor/32x32/apps/steam.png"],
    ["valve/icons/48/steam.png",                             "usr/share/icons/hicolor/48x48/apps/steam.png"],
    ["valve/icons/256/steam.png",                            "usr/share/icons/hicolor/256x256/apps/steam.png"],
    ["valve/icons/48/steam.png",                             "usr/share/pixmaps/steam.png"],
    ["valve/icons/48/steam_tray_mono.png",                   "usr/share/pixmaps/steam_tray_mono.png"],
    ["valve/com.valvesoftware.Steam.metainfo.xml",           "usr/share/metainfo/com.valvesoftware.Steam.metainfo.xml"],
    ["valve/steam.6",                                        "usr/share/man/man6/steam.6"],
    ["valve/steam_subscriber_agreement.txt",                 "usr/share/licenses/steam/steam_subscriber_agreement.txt"],
    ["valve/subprojects/steam-devices/LICENSE",              "usr/share/licenses/steam/steam-devices-LICENSE"],
    ["valve/subprojects/steam-devices/60-steam-input.rules", "usr/lib/udev/rules.d/60-steam-input.rules"],
    ["valve/subprojects/steam-devices/60-steam-vr.rules",    "usr/lib/udev/rules.d/60-steam-vr.rules"],
];

// The launcher script: Valve's file, then without the block that copies the
// menu entry onto the user's desktop (Fedora's steam-no-icon-on-desktop.patch).
const LAUNCHER = #{
    source: "bin_steam.sh",
    path: "usr/lib/steam/bin_steam.sh",
    sha256: "98e391905f8f00c294f63c3581477af7053b064dede46c70795d7e2f6ffa6b49",
    cut_from: "\t# put the Steam icon on the user's desktop\n",
    cut_to: "\t# Restore the umask\n",
    patched_sha256: "14979322e5d40a06b002fbc10ba9ee4120c867bbf495b8a193723e74bbee3bfc",
};
// Fedora's 01-steam.conf (RPM Fusion steam package), as it ships it.
const NOFILE_CONF = `[Manager]
# Increase the file descriptor limit to make Steam Proton/Wine esync work out of
# the box. As of Proton 5, the limit should be 1048576:
# https://github.com/zfigura/wine/blob/esync/README.esync#L26
DefaultLimitNOFILE=1024:1048576
`;

// Valve's launcher, less the desktop-copy block, as /usr/bin/steam, and
// Fedora's file-descriptor limit for Proton's esync.
fn configure(tree, src) {
    let script = join_path(src.valve, LAUNCHER.source);
    verify_sha256(script, LAUNCHER.sha256);
    let text = read_file(script);
    let from = text.index_of(LAUNCHER.cut_from);
    let to = text.index_of(LAUNCHER.cut_to);
    if from < 0 || to < from {
        throw "Valve's " + LAUNCHER.source + " no longer has the block that copies steam.desktop onto the desktop; " +
            "compare it with RPM Fusion's steam-no-icon-on-desktop.patch and update LAUNCHER";
    }
    put(tree, LAUNCHER.path, text.sub_string(0, from) + text.sub_string(to), 0o755);
    verify_sha256(join_path(tree, LAUNCHER.path), LAUNCHER.patched_sha256);
    put_link(tree, "usr/bin/steam", "/" + LAUNCHER.path);

    put(tree, "usr/lib/systemd/system.conf.d/01-steam.conf", NOFILE_CONF, 0o644);
    put(tree, "usr/lib/systemd/user.conf.d/01-steam.conf", NOFILE_CONF, 0o644);
}
