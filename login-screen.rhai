const RECIPE_API = 1;
// login-screen: reclogin, the login screen of LevitateOS and AcornOS, as a
// Recipe group installed into the system root (`recipe --system install
// login-screen`) with a receipt, so it can be removed or replaced like any
// other group. Removed, the machine starts to its text logins.
//
// It names no packages (no PACKAGES, no pins file), so `cargo xtask base
// groups` leaves it alone, as it leaves rec-apps.
//
// The programs and their files are the OS builder's pinned prebuilt tree (the
// LevitateOS/prebuilt release `login-screen-<key16>` that `prebuilt publish
// login-screen <distro>` makes from tools/reclogin), compiled in each OS's own
// apps-build root against the libpam, libinput and libxkbcommon that OS
// ships: one archive per C library. The SOURCES below follow the newest
// published key; when reclogin or the libraries it is built against change, a
// new key is published and these sources must be moved to it (by hand: nothing
// generates them).
//
// The libraries it links: libpam is in the base on both systems; libinput,
// libxkbcommon (with the keymaps of xkeyboard-config) come with desktop-libs.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "objects.githubusercontent.com:443"],
    // Two stripped programs, the fonts and the background: the larger
    // archive (glibc, 5525221 bytes), rounded up.
    network_max_bytes: 6291456,
    timeout_secs: 1800,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "reclogin, the login screen: it lists the people who use this computer, asks for the password through the system's own login rules, and starts the desktop they choose. It draws straight to the screen, on console 7; the text logins on consoles 1 to 6 stay. Removing it leaves the text logins.",
    homepage: "https://github.com/LevitateOS/reclogin",
    license: "(MIT OR Apache-2.0) AND OFL-1.1",
    steps: #{
        download: "Downloads the pinned prebuilt archive for this system's C library and checks its SHA-256.",
        build: "Unpacks it and keeps the two programs, the login rules (PAM), the settings file, the service, the accounts, the brand files and the guest session's files.",
        install: "Publishes the system tree for Recipe to write into the system root, with a receipt, and starts the login screen at boot.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "login-screen", version: "2026.11.16", description: "reclogin, the login screen" };

let deps = ["desktop-libs"];

// One prebuilt archive per C library: the release asset and the digest GitHub
// publishes for it. The source is fetched only on the system whose C library
// it names (`libc`): glibc from `prebuilt publish login-screen levitate`,
// musl from `... acorn`. The archive holds the tree at its root (etc/, usr/),
// so nothing is left out when it is unpacked (strip: false).
const SOURCES = #{
    glibc: #{
        url: "https://github.com/LevitateOS/prebuilt/releases/download/login-screen-d1b52d0912b41d7b/login-screen-levitate.tar.gz",
        sha256: "7e4aa8e9ac295d078ad8cb3e95e23179de647e91b5ba2a55b93e813e88a102bc",
        strip: false,
        libc: "glibc",
    },
    musl: #{
        url: "https://github.com/LevitateOS/prebuilt/releases/download/login-screen-ffd914bc27cad91d/login-screen-acorn.tar.gz",
        sha256: "9d029420be4574f2572f946e116c24018e98a316c5ed848b9d152d6417bdd4b9",
        strip: false,
        libc: "musl",
    },
};

// The account the greeter runs as, and the guest account (fixed uid and gid
// 60600, locked, home in memory at /run/reclogin/guest: reclogind uses it only
// when it is exactly this). The tree's usr/lib/sysusers.d/reclogin.conf makes
// them too (Recipe reads a change's own sysusers.d); a line made twice is
// made once. Same lines as tools/reclogin/dist/sysusers/reclogin.conf. The
// same on both systems.
const ACCOUNTS = #{
    glibc: [
        "u reclogin - 'reclogin login screen' - -",
        "g guest 60600",
        "u guest 60600:60600 'Guest' /run/reclogin/guest /bin/bash",
        "u reclogin-sweep 60601 'reclogin guest sweep' - -",
    ],
    musl: [
        "u reclogin - 'reclogin login screen' - -",
        "g guest 60600",
        "u guest 60600:60600 'Guest' /run/reclogin/guest /bin/bash",
        "u reclogin-sweep 60601 'reclogin guest sweep' - -",
    ],
};

// What the system tree takes from the prebuilt tree: [path, mode], the
// builder's list (distro/builder/os-recipes/reclogin.rhai, installed_files)
// for this system's init. Paths are written out in full: a computed constant
// is not visible inside build. The display-manager link (systemd) and the
// runlevel link (OpenRC) are made in build.
const PLACED = [
    ["usr/bin/reclogind", 0o755],
    ["usr/bin/reclogin-greeter", 0o755],
    ["etc/pam.d/reclogin", 0o644],
    ["etc/pam.d/reclogin-autologin", 0o644],
    ["etc/reclogin.conf", 0o644],
    ["usr/lib/sysusers.d/reclogin.conf", 0o644],
    ["usr/share/reclogin/brand.json", 0o644],
    ["usr/share/reclogin/background.png", 0o644],
    ["usr/share/reclogin/fonts/Newsreader.ttf", 0o644],
    ["usr/share/reclogin/fonts/Newsreader-Italic.ttf", 0o644],
    ["usr/share/reclogin/fonts/NewsreaderDisplay.ttf", 0o644],
    ["usr/share/reclogin/fonts/NewsreaderDisplay-Italic.ttf", 0o644],
    ["usr/share/reclogin/fonts/InstrumentSans.ttf", 0o644],
    ["usr/share/reclogin/fonts/OFL-Newsreader.txt", 0o644],
    ["usr/share/reclogin/fonts/OFL-InstrumentSans.txt", 0o644],
    // The guest.
    ["etc/pam.d/reclogin-guest", 0o644],
    ["etc/security/limits.d/50-reclogin-guest.conf", 0o644],
    ["etc/ssh/sshd_config.d/50-reclogin-guest.conf", 0o644],
    ["usr/share/polkit-1/rules.d/50-reclogin-guest.rules", 0o644],
    ["usr/libexec/reclogin/reclogin-guest-notice", 0o755],
    ["usr/share/reclogin/guest-home/.config/autostart/reclogin-guest-notice.desktop", 0o644],
];
// systemd (LevitateOS, glibc) and OpenRC (AcornOS, musl).
const PLACED_SYSTEMD = [
    ["usr/lib/systemd/system/reclogin.service", 0o644],
    ["usr/lib/systemd/system/user@60600.service.d/50-reclogin-guest.conf", 0o644],
];
const PLACED_OPENRC = [
    ["etc/init.d/reclogin", 0o755],
    ["usr/libexec/reclogin/reclogind-run", 0o755],
];

// The prebuilt tree is unpacked into `src` (the source named for this system's
// C library); the placed files go into the system tree `out`.
fn build(src, out) {
    let prebuilt = if HOST_LIBC == "glibc" { src.glibc } else { src.musl };
    let init = if HOST_LIBC == "glibc" { "systemd" } else { "openrc" };
    let placed = PLACED + (if init == "systemd" { PLACED_SYSTEMD } else { PLACED_OPENRC });
    for file in placed {
        let from = join_path(prebuilt, file[0]);
        if !is_file(from) { throw "the prebuilt login screen lacks /" + file[0]; }
        let dest = join_path(out, file[0]);
        mkdir(dirname(dest));
        copy_file(from, dest);
        target_mode(out, file[0], file[1]);
    }
    start_at_boot(out, init);
}

// Start the login screen at boot, in this system's init's own form. systemd:
// the unit's Alias=, display-manager.service, which graphical.target wants
// (the unit has no WantedBy: nothing else starts it). OpenRC: the service in
// the default runlevel (it needs elogind and dbus, which the base starts).
// Text logins stay on consoles 1 to 6 on both: nothing is masked.
fn start_at_boot(out, init) {
    if init == "systemd" {
        let unit = "usr/lib/systemd/system/reclogin.service";
        if !read_file(join_path(out, unit)).contains("Alias=display-manager.service") {
            throw "login-screen: /" + unit + " no longer names display-manager.service as its alias";
        }
        put_link(out, "etc/systemd/system/display-manager.service", "/" + unit);
    } else {
        if !is_file(join_path(out, "etc/init.d/reclogin")) { throw "login-screen: the prebuilt has no OpenRC service reclogin"; }
        put_link(out, "etc/runlevels/default/reclogin", "/etc/init.d/reclogin");
    }
}
