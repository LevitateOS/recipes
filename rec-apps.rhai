const RECIPE_API = 1;
// rec-apps: LevitateOS's own desktop apps, Recipe (recipe-gui) and Recdirstat
// (disk-gui), installed into the system root (`recipe --system install
// rec-apps`) with a receipt. The prebuilt archives also hold two apps that
// are NOT installed here, because only one kind of installation gets each:
// the Recab app (recab-gui, A/B systems only) and the Updater (updater-gui,
// mutable systems only). The installer places them from recsetup's
// /usr/lib/recsetup/ab-only and /usr/lib/recsetup/mutable-only trees
// (distro/contract AB_DESKTOP_APP_FILES and MUTABLE_DESKTOP_APP_FILES: the
// program, .desktop file, icon and polkit policy of each), so FILES leaves
// out every file with "recab" or "updater" in its path, icons included.
//
// The programs are the OS builder's pinned prebuilt tree (the
// LevitateOS/prebuilt release `desktop-apps-<key16>` that `prebuilt publish
// desktop-apps` makes from tools/gui/), compiled in each OS's own apps-build
// root against the Qt that desktop-libs ships: one archive per C library
// (SOURCES, by libc; Recipe fetches only this system's). The pins follow the
// newest published key (2026-11-16: glibc desktop-apps-a55c64e2b967af33,
// musl desktop-apps-1d8c3e52cfdf462c); when the apps or the Qt they are built against
// change, a new key is published and these pins must be moved to it (by hand
// today: nothing generates them).
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "objects.githubusercontent.com:443"],
    network_max_bytes: 8388608,
    timeout_secs: 1800,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "Recipe, the software catalog and installer, and Recdirstat, which shows where the space on the disk goes and how alike the two systems are. Built from LevitateOS's desktop-apps source for each OS's own Qt.",
    homepage: "https://github.com/LevitateOS/desktop-apps",
    license: "MIT OR Apache-2.0",
    steps: #{
        download: "Downloads the pinned prebuilt archive for this system's C library and checks its SHA-256.",
        install: "Unpacks it, keeps the two apps' programs, menu entries and icons and Recipe's polkit action (not the Recab app or the Updater, which the installer places), and writes them into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "rec-apps", version: "2026.11.17", description: "Recipe and Recdirstat, LevitateOS's desktop apps" };

let deps = ["desktop-libs"];

// The release asset per C library and the digest GitHub publishes for it.
// Their paths start at usr/, so the top folder is kept (strip: false).
const SOURCES = #{
    glibc: #{
        url: "https://github.com/LevitateOS/prebuilt/releases/download/desktop-apps-a55c64e2b967af33/desktop-apps-levitate.tar.gz",
        sha256: "6a968920998a3da476989424768b637a139911381220d0265ccaa8897bb749ce",
        strip: false,
        libc: "glibc",
    },
    musl: #{
        url: "https://github.com/LevitateOS/prebuilt/releases/download/desktop-apps-1d8c3e52cfdf462c/desktop-apps-acorn.tar.gz",
        sha256: "f7608e81f315c236e712d22d1a3ea0f64659f02faf364138902153195a25a2e5",
        strip: false,
        libc: "musl",
    },
};

// What the system tree takes from the prebuilt tree of this system's C
// library; the entries of the other library's source are left out with it.
const FILES = [
    ["glibc/usr/bin/recipe-gui",                                    "usr/bin/recipe-gui", 0o755],
    ["glibc/usr/bin/disk-gui",                                      "usr/bin/disk-gui", 0o755],
    ["glibc/usr/share/applications/org.levitateos.recipe.desktop",  "usr/share/applications/org.levitateos.recipe.desktop", 0o644],
    ["glibc/usr/share/applications/org.levitateos.disk.desktop",    "usr/share/applications/org.levitateos.disk.desktop", 0o644],
    ["glibc/usr/share/polkit-1/actions/org.levitateos.recipe.policy", "usr/share/polkit-1/actions/org.levitateos.recipe.policy", 0o644],
    ["glibc/usr/share/icons/hicolor/scalable/apps/org.levitateos.recipe.svg", "usr/share/icons/hicolor/scalable/apps/org.levitateos.recipe.svg", 0o644],
    ["glibc/usr/share/icons/hicolor/scalable/apps/org.levitateos.disk.svg",   "usr/share/icons/hicolor/scalable/apps/org.levitateos.disk.svg", 0o644],
    ["musl/usr/bin/recipe-gui",                                     "usr/bin/recipe-gui", 0o755],
    ["musl/usr/bin/disk-gui",                                       "usr/bin/disk-gui", 0o755],
    ["musl/usr/share/applications/org.levitateos.recipe.desktop",   "usr/share/applications/org.levitateos.recipe.desktop", 0o644],
    ["musl/usr/share/applications/org.levitateos.disk.desktop",     "usr/share/applications/org.levitateos.disk.desktop", 0o644],
    ["musl/usr/share/polkit-1/actions/org.levitateos.recipe.policy", "usr/share/polkit-1/actions/org.levitateos.recipe.policy", 0o644],
    ["musl/usr/share/icons/hicolor/scalable/apps/org.levitateos.recipe.svg", "usr/share/icons/hicolor/scalable/apps/org.levitateos.recipe.svg", 0o644],
    ["musl/usr/share/icons/hicolor/scalable/apps/org.levitateos.disk.svg",   "usr/share/icons/hicolor/scalable/apps/org.levitateos.disk.svg", 0o644],
];
