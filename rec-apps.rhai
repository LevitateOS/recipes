const RECIPE_API = 1;
// rec-apps: LevitateOS's own desktop apps, Recipe (recipe-gui) and Recdirstat
// (disk-gui), installed into the system root (`recipe --system install
// rec-apps`) with a receipt. The Recab app is not here: the installer places
// it on A/B systems only.
//
// The programs are the OS builder's pinned prebuilt tree (the
// LevitateOS/prebuilt release `desktop-apps-<key16>` that `prebuilt publish
// desktop-apps` makes from tools/gui/), compiled in each OS's own apps-build
// root against the Qt that desktop-libs ships: one archive per C library
// (SOURCES, by libc; Recipe fetches only this system's). The pins follow the
// newest published key; when the apps or the Qt they are built against
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
        install: "Unpacks it, keeps the two apps' programs, menu entries and Recipe's polkit actions, and writes them into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "rec-apps", version: "2026.11.15", description: "Recipe and Recdirstat, LevitateOS's desktop apps" };

let deps = ["desktop-libs"];

// The release asset per C library and the digest GitHub publishes for it.
// Their paths start at usr/, so the top folder is kept (strip: false).
const SOURCES = #{
    glibc: #{
        url: "https://github.com/LevitateOS/prebuilt/releases/download/desktop-apps-9e4fc1a3847479c5/desktop-apps-levitate.tar.gz",
        sha256: "d45595835f349f91182ab3ee925d399bfc1bf3f3ce6f4d2960c4c3e0ce5ddb72",
        strip: false,
        libc: "glibc",
    },
    musl: #{
        url: "https://github.com/LevitateOS/prebuilt/releases/download/desktop-apps-4166ccbac14baca6/desktop-apps-acorn.tar.gz",
        sha256: "559769c95640a3953a3902578b10de32294dca668ba74ff9fec97245aa52291b",
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
    ["musl/usr/bin/recipe-gui",                                     "usr/bin/recipe-gui", 0o755],
    ["musl/usr/bin/disk-gui",                                       "usr/bin/disk-gui", 0o755],
    ["musl/usr/share/applications/org.levitateos.recipe.desktop",   "usr/share/applications/org.levitateos.recipe.desktop", 0o644],
    ["musl/usr/share/applications/org.levitateos.disk.desktop",     "usr/share/applications/org.levitateos.disk.desktop", 0o644],
    ["musl/usr/share/polkit-1/actions/org.levitateos.recipe.policy", "usr/share/polkit-1/actions/org.levitateos.recipe.policy", 0o644],
];
