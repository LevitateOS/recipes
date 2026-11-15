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
// Hand-written: ABOUT, the Valve pins, the seeds and the groups it needs
// (deps). Generated: the two pin blocks, `version` and `network_max_bytes`
// (which counts OTHER_DOWNLOAD_BYTES, Valve's tarball, on top of the packages),
// written by `cargo xtask base groups levitate`.
const RECIPE_API = 3;
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "repo.steampowered.com:443"],
    network_max_bytes: 32505856,
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
        acquire: "Downloads Valve's pinned Steam launcher tarball from repo.steampowered.com and checks its SHA-256, and takes each pinned Fedora package by its SHA-256 from the install medium's cache or the distribution's mirror.",
        build: "Unpacks the Fedora packages natively into one system tree, without running their scripts, and places Valve's launcher, client bootstrap, menu entry, icons and device rules in it, each checked against its own digest; nothing is compiled.",
        install: "Publishes the system tree for Recipe to write into the system root, with a receipt.",
    },
    keeps: [],
};

// What this group installs, by name; the generator adds what they need.
// LevitateOS (glibc, Fedora 45): what Fedora's steam package requires
// (Requires: zenity, xz) and no other group installs.
const SEEDS_GLIBC = [
    "zenity", "xz"
];
// AcornOS (musl): Steam does not run there.
const SEEDS_MUSL = [];
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs", "lib32", "graphics-drivers"];

let ctx = #{
    name: "steam",
    version: "2026.11.16",
    description: "Valve's Steam launcher and what it needs",
};

// Valve's launcher tarball: what acquire downloads besides the packages. The
// generator adds OTHER_DOWNLOAD_BYTES to network_max_bytes.
const OTHER_DOWNLOAD_BYTES = 20409598;
const VALVE = #{
    version: "1.0.0.87",
    url: "https://repo.steampowered.com/steam/archive/stable/steam_1.0.0.87.tar.gz",
    file: "steam_1.0.0.87.tar.gz",
    sha256: "649375d2f9377f8009aaf3e2ff09978041eb9114897d9c5a3886f1d82e27ba1f",
    top: "steam-launcher",
};
// [file in the tarball, path in the system tree, mode, SHA-256 of Valve's file]
const VALVE_FILES = [
    ["bootstraplinux_ubuntu12_32.tar.xz", "usr/lib/steam/bootstraplinux_ubuntu12_32.tar.xz", 0o644, "fba17e3c7550bfcd35bc7f60e04a0f7ba4dad21ce8c8a5704d257c37ce1c9c36"],
    ["steam.desktop", "usr/share/applications/steam.desktop", 0o644, "ac227a3f9e0a23f19c716d1a7232ba0c0e86472834c17bbad7fbce411c6d6183"],
    ["icons/16/steam.png", "usr/share/icons/hicolor/16x16/apps/steam.png", 0o644, "71b1fb9007b5fa3a025a4ae12e545c585d98df616795daac55d75b4647293cd7"],
    ["icons/24/steam.png", "usr/share/icons/hicolor/24x24/apps/steam.png", 0o644, "e4a820c0bed3938ba7c7ddb179d038cca0413bce4de5412239e6b158bb99b578"],
    ["icons/32/steam.png", "usr/share/icons/hicolor/32x32/apps/steam.png", 0o644, "da7423cf754b548d87736180bbc26173c625703ee4e20690dc35641b0ac2b274"],
    ["icons/48/steam.png", "usr/share/icons/hicolor/48x48/apps/steam.png", 0o644, "f5e3b495a15156a4db2c62ea83ad375d88c1ef61fa808101ef2f28ba324856e1"],
    ["icons/256/steam.png", "usr/share/icons/hicolor/256x256/apps/steam.png", 0o644, "b7087da76b8315024887b9a9313be5b9e6ba87d25eb624eac2d6542a823bb87d"],
    ["icons/48/steam.png", "usr/share/pixmaps/steam.png", 0o644, "f5e3b495a15156a4db2c62ea83ad375d88c1ef61fa808101ef2f28ba324856e1"],
    ["icons/48/steam_tray_mono.png", "usr/share/pixmaps/steam_tray_mono.png", 0o644, "d83af6f2e433f5c46e546096d983129bd5a2c5e05fb011d35825b2641cf1e19f"],
    ["com.valvesoftware.Steam.metainfo.xml", "usr/share/metainfo/com.valvesoftware.Steam.metainfo.xml", 0o644, "22f787d9c5d95685ac48908aab5aeb6359b2bbf4e216ae2eacae074775ea94c9"],
    ["steam.6", "usr/share/man/man6/steam.6", 0o644, "312c6315e1af59f3062546dc7e77efd967d3c78146088874fb73ee3a6bd65514"],
    ["steam_subscriber_agreement.txt", "usr/share/licenses/steam/steam_subscriber_agreement.txt", 0o644, "289b43903203775096e7a1811e934f14d1dc0849f62ad698b93935f81c809fb2"],
    ["subprojects/steam-devices/LICENSE", "usr/share/licenses/steam/steam-devices-LICENSE", 0o644, "4a8b10a725095d8be78a130dd21984d70976915a658da8fe158d3bc20ca03585"],
    ["subprojects/steam-devices/60-steam-input.rules", "usr/lib/udev/rules.d/60-steam-input.rules", 0o644, "284930f83cf8fde8a247057d46f48083d5e4aefc23a54310db02cfc2dbe42e50"],
    ["subprojects/steam-devices/60-steam-vr.rules", "usr/lib/udev/rules.d/60-steam-vr.rules", 0o644, "e12cda322c9f5f7c6336d8048264877690d3488e1b0f1b750cce18a836160420"],
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

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-16): 4 packages, 11788192 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-16";
const RPM_PINNED_BYTES = 11788192;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["gtk4", "gtk4-4.24.1-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gtk4-4.24.1-1.fc45.x86_64.rpm", "fb02ba7ae2efbb014d18d56207ced6f7f2c6be5ef2af7e797d4da0bdc738e943", 7244168, "LGPL-2.0-or-later AND LGPL-2.1-or-later AND Apache-2.0 AND CC0-1.0 AND MIT AND MIT-open-group AND HPND-sell-variant AND GPL-2.0-or-later AND GPL-3.0-or-later AND OFL-1.1", false],
    ["libadwaita", "libadwaita-1.10.0-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libadwaita-1.10.0-2.fc45.x86_64.rpm", "4ce2349fb1809450ec6c22686c6b63cf571c3079db36fa9fed1f26db0a22dde2", 805146, "LGPL-2.1-or-later AND MIT", false],
    ["xz", "xz-5.8.3-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/x/xz-5.8.3-2.fc45.x86_64.rpm", "47eb91b7b870716aa6fc177ea883fed67e3c091c06bc772c6e2261edbb0f940c", 666836, "0BSD AND GPL-2.0-or-later AND LicenseRef-Fedora-Public-Domain", false],
    ["zenity", "zenity-4.2.2-5.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/z/zenity-4.2.2-5.fc45.x86_64.rpm", "b473d0f3d41d16d9ac38b282999b8b42b51a130472b2b76e4983c5abd32ae9a4", 3072042, "LGPL-2.1-or-later", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// No musl build: this recipe names no seeds in SEEDS_MUSL. Written by
// `cargo xtask base groups acorn`; do not edit.
const APK_PINNED_ON = "";
const APK_PINNED_BYTES = 0;
const APK_PINS = [];
// END GENERATED PINS musl

// The rest is the same in every group recipe, except where it says Valve:
// acquire and is_acquired also take Valve's tarball, the record also names
// it, and configure places Valve's files.
//
// Which build this system takes: the Fedora RPMs on glibc (LevitateOS), the
// Alpine APKs on musl (AcornOS). RUNTIME.host.libc is the C library of the
// system the group is installed into.
ctx.libc = RUNTIME.host.libc;
ctx.downloads = join_path(RUNTIME.paths.build, "downloads");
ctx.record = join_path(RUNTIME.paths.build, "system.pins");
ctx.system = join_path(RUNTIME.paths.output, "system");
ctx.valve_archive = join_path(RUNTIME.paths.build, "downloads/" + VALVE.file);
ctx.valve_unpacked = join_path(RUNTIME.paths.build, "valve");
if ctx.libc == "glibc" {
    ctx.format = "rpm";
    ctx.accounts = ACCOUNTS_GLIBC;
    ctx.pins = RPM_PINS;
    ctx.pinned_bytes = RPM_PINNED_BYTES;
} else if ctx.libc == "musl" {
    ctx.format = "apk";
    ctx.accounts = ACCOUNTS_MUSL;
    ctx.pins = APK_PINS;
    ctx.pinned_bytes = APK_PINNED_BYTES;
} else {
    ctx.format = "";
    ctx.accounts = [];
    ctx.pins = [];
    ctx.pinned_bytes = 0;
}
ctx.no_build = ctx.name + " is built for glibc (LevitateOS): Valve's Steam is a glibc program with 32-bit " +
    "glibc libraries. This system's C library is " + ctx.libc + ". On a glibc system, " +
    "`cargo xtask base groups levitate` writes the pins from SEEDS_GLIBC.";
if ctx.pinned_bytes + OTHER_DOWNLOAD_BYTES > NEEDS.network_max_bytes {
    throw "the pinned packages (" + ctx.pinned_bytes + " bytes) and Valve's tarball exceed NEEDS.network_max_bytes; " +
        "`cargo xtask base groups <distro>` sets it";
}
// What the system tree was made from: one line per pinned package, and
// Valve's tarball.
ctx.pins_record = "";
for pin in ctx.pins {
    ctx.pins_record += pin[3] + "  " + pin[1] + "\n";
}
ctx.pins_record += VALVE.sha256 + "  " + VALVE.file + "\n";

fn archive_of(ctx, pin) {
    join_path(ctx.downloads, pin[1])
}

fn check_system(ctx) {
    if ctx.pins.is_empty() { return needs_work(ctx, ctx.no_build); }
    if !is_file(ctx.record) || !is_dir(ctx.system) {
        return needs_work(ctx, "unpack the " + ctx.pins.len() + " packages of " + ctx.name + " and Valve's launcher");
    }
    if read_file(ctx.record) != ctx.pins_record {
        return needs_work(ctx, "the pinned package set of " + ctx.name + " changed");
    }
    ready(ctx)
}

fn is_acquired(ctx) {
    if ctx.pins.is_empty() { return needs_work(ctx, ctx.no_build); }
    for pin in ctx.pins {
        let archive = archive_of(ctx, pin);
        if !is_file(archive) { return needs_work(ctx, "download " + pin[1]); }
        verify_sha256(archive, pin[3]);
    }
    // Valve
    if !is_file(ctx.valve_archive) { return needs_work(ctx, "download " + VALVE.file + " from Valve"); }
    verify_sha256(ctx.valve_archive, VALVE.sha256);
    ready(ctx)
}

// Each pinned file by its SHA-256: from the install medium's cache when
// Recipe finds it there, else from the distribution's mirror; and Valve's
// tarball from Valve.
fn acquire(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    mkdir(ctx.downloads);
    let done = 0;
    let total = ctx.pins.len() + 1;
    for pin in ctx.pins {
        progress(done, total, "packages");
        download(pin[2], archive_of(ctx, pin), pin[3]);
        done += 1;
    }
    // Valve
    progress(done, total, "packages");
    download(VALVE.url, ctx.valve_archive, VALVE.sha256);
    progress(total, total, "packages");
    ctx
}

fn is_built(ctx) {
    check_system(ctx)
}

// Unpacks every package into one system tree, natively, without running any
// of its scripts. Paths a system package does not own (run-time data: run,
// tmp and the like) are left out. Under var/, only what a package needs and
// nothing at boot makes (pin[6]) is kept, as state seeds: created where
// missing, never owned or removed. Owners stay names, resolved in the root
// the group is written into, after the accounts it needs are made there.
fn build(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    if exists(ctx.record) { rm(ctx.record); }
    if exists(ctx.system) { rm(ctx.system); }
    mkdir(ctx.system);
    let done = 0;
    for seeds in [false, true] {
        for pin in ctx.pins {
            if pin[6] != seeds { continue; }
            progress(done, ctx.pins.len(), "packages");
            let archive = archive_of(ctx, pin);
            verify_sha256(archive, pin[3]);
            if ctx.format == "apk" {
                target_extract_apk(archive, ctx.system);
            } else {
                target_extract_rpm(archive, ctx.system);
            }
            done += 1;
        }
        let state = join_path(ctx.system, "var");
        if !seeds && exists(state) { rm(state); }
    }
    progress(done, ctx.pins.len(), "packages");
    // This group's configuration (configure, below): files in its own tree,
    // so the receipt owns them and removing the group removes them.
    configure(ctx);
    for dir in ["run", "tmp", "boot", "home", "root", "proc", "sys", "dev", "lost+found", "var/run", "var/tmp", "var/lock"] {
        let path = join_path(ctx.system, dir);
        if exists(path) { rm(path); }
    }
    target_finalize(ctx.system, #{ owners: "apply", seed: "var", accounts: ctx.accounts });
    write_file(ctx.record, ctx.pins_record);
    ctx
}

fn is_installed(ctx) {
    if !is_dir(ctx.system) { return needs_work(ctx, "unpack the packages of " + ctx.name); }
    ctx.outputs.system = ctx.system;
    check_system(ctx)
}

fn install(ctx) {
    // The unpacked tree is already in owned storage; publish it as it is.
    ctx.outputs.system = ctx.system;
    ctx
}

fn remove(ctx) {
    if exists(ctx.system) { rm(ctx.system); }
    if exists(ctx.record) { rm(ctx.record); }
    ctx.outputs = #{};
    ctx
}

// ---------------------------------------------------------------------------
// Configuration helpers: what a group adds to its own tree.
// ---------------------------------------------------------------------------

// `content` at `path` (relative to the tree) with `mode`, replacing what is there.
fn put(ctx, path, content, mode) {
    let dest = join_path(ctx.system, path);
    mkdir(dirname(dest));
    if exists(dest) { rm(dest); }
    write_file(dest, content);
    target_mode(ctx.system, path, mode);
}
// A symbolic link at `path` to `target`.
fn put_link(ctx, path, target) {
    let dest = join_path(ctx.system, path);
    mkdir(dirname(dest));
    ln_force(target, dest);
}

// ---------------------------------------------------------------------------
// This group's configuration (hand-written): Valve's launcher.
// ---------------------------------------------------------------------------

fn configure(ctx) {
    if ctx.format != "rpm" { throw ctx.no_build; }
    verify_sha256(ctx.valve_archive, VALVE.sha256);
    if exists(ctx.valve_unpacked) { rm(ctx.valve_unpacked); }
    mkdir(ctx.valve_unpacked);
    extract(ctx.valve_archive, ctx.valve_unpacked);
    let top = join_path(ctx.valve_unpacked, VALVE.top);
    if !is_dir(top) { throw "Valve's tarball " + VALVE.file + " has no " + VALVE.top + "/ directory"; }

    for file in VALVE_FILES {
        let from = join_path(top, file[0]);
        if !is_file(from) { throw "Valve's tarball " + VALVE.file + " lacks " + VALVE.top + "/" + file[0]; }
        verify_sha256(from, file[3]);
        let dest = join_path(ctx.system, file[1]);
        mkdir(dirname(dest));
        if exists(dest) { rm(dest); }
        copy_file(from, dest);
        target_mode(ctx.system, file[1], file[2]);
    }

    // The launcher script, less the desktop-copy block.
    let script = join_path(top, LAUNCHER.source);
    verify_sha256(script, LAUNCHER.sha256);
    let text = read_file(script);
    let from = text.index_of(LAUNCHER.cut_from);
    let to = text.index_of(LAUNCHER.cut_to);
    if from < 0 || to < from {
        throw "Valve's " + LAUNCHER.source + " no longer has the block that copies steam.desktop onto the desktop; " +
            "compare it with RPM Fusion's steam-no-icon-on-desktop.patch and update LAUNCHER";
    }
    put(ctx, LAUNCHER.path, text.sub_string(0, from) + text.sub_string(to), 0o755);
    verify_sha256(join_path(ctx.system, LAUNCHER.path), LAUNCHER.patched_sha256);
    put_link(ctx, "usr/bin/steam", "/" + LAUNCHER.path);

    // Fedora's file-descriptor limit for Proton's esync.
    put(ctx, "usr/lib/systemd/system.conf.d/01-steam.conf", NOFILE_CONF, 0o644);
    put(ctx, "usr/lib/systemd/user.conf.d/01-steam.conf", NOFILE_CONF, 0o644);

    rm(ctx.valve_unpacked);
}
