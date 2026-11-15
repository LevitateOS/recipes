// rec-apps: LevitateOS's own desktop apps, Recipe (recipe-gui) and Recdirstat
// (disk-gui), installed into the system root (`recipe --system install
// rec-apps`) with a receipt. The Recab app is not here: the installer places
// it on A/B systems only.
//
// The programs are the OS builder's pinned prebuilt tree (the
// LevitateOS/prebuilt release `desktop-apps-<key16>` that `prebuilt publish
// desktop-apps` makes from tools/gui/), compiled in each OS's own apps-build
// root against the Qt that desktop-libs ships: one archive per C library. The
// pins below follow the newest published key; when the apps or the Qt they
// are built against change, a new key is published and these pins must be
// moved to it (by hand today: nothing generates them).
const RECIPE_API = 3;
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
        acquire: "Downloads the pinned prebuilt archive for this system's C library and checks its SHA-256.",
        build: "Unpacks it and keeps the two apps' programs, menu entries and Recipe's polkit actions.",
        install: "Publishes the system tree for Recipe to write into the system root, with a receipt.",
    },
    keeps: [],
};

let deps = ["desktop-libs"];

let ctx = #{
    name: "rec-apps",
    version: "2026.11.15",
    description: "Recipe and Recdirstat, LevitateOS's desktop apps",
};

// [file, URL, SHA-256] per C library: the release asset and the digest GitHub
// publishes for it.
const PINS = #{
    glibc: ["desktop-apps-levitate.tar.gz",
            "https://github.com/LevitateOS/prebuilt/releases/download/desktop-apps-9e4fc1a3847479c5/desktop-apps-levitate.tar.gz",
            "d45595835f349f91182ab3ee925d399bfc1bf3f3ce6f4d2960c4c3e0ce5ddb72"],
    musl: ["desktop-apps-acorn.tar.gz",
           "https://github.com/LevitateOS/prebuilt/releases/download/desktop-apps-4166ccbac14baca6/desktop-apps-acorn.tar.gz",
           "559769c95640a3953a3902578b10de32294dca668ba74ff9fec97245aa52291b"],
};
// What the system tree takes from the prebuilt tree: [path, mode].
const FILES = [
    ["usr/bin/recipe-gui", 0o755],
    ["usr/bin/disk-gui", 0o755],
    ["usr/share/applications/org.levitateos.recipe.desktop", 0o644],
    ["usr/share/applications/org.levitateos.disk.desktop", 0o644],
    ["usr/share/polkit-1/actions/org.levitateos.recipe.policy", 0o644],
];

ctx.pin = PINS[RUNTIME.host.libc];
ctx.files = FILES;
ctx.archive = join_path(RUNTIME.paths.build, "prebuilt.tar.gz");
ctx.unpacked = join_path(RUNTIME.paths.build, "unpacked");
ctx.system = join_path(RUNTIME.paths.output, "system");
ctx.record = join_path(RUNTIME.paths.build, "system.pin");

fn no_build(ctx) {
    "rec-apps has prebuilt apps for glibc (LevitateOS) and musl (AcornOS); this system's C library is " +
        ctx.runtime.host.libc + ", for which there is none"
}

fn is_acquired(ctx) {
    if type_of(ctx.pin) == "()" { return needs_work(ctx, no_build(ctx)); }
    if !is_file(ctx.archive) { return needs_work(ctx, "download " + ctx.pin[0]); }
    verify_sha256(ctx.archive, ctx.pin[2]);
    ready(ctx)
}

fn acquire(ctx) {
    if type_of(ctx.pin) == "()" { throw no_build(ctx); }
    download(ctx.pin[1], ctx.archive, ctx.pin[2]);
    ctx
}

fn check_system(ctx) {
    if !is_file(ctx.record) || !is_dir(ctx.system) { return needs_work(ctx, "unpack the desktop apps"); }
    if read_file(ctx.record) != ctx.pin[2] + "\n" { return needs_work(ctx, "the pinned apps changed"); }
    ready(ctx)
}

fn is_built(ctx) { check_system(ctx) }

fn build(ctx) {
    verify_sha256(ctx.archive, ctx.pin[2]);
    for dir in [ctx.unpacked, ctx.system] { if exists(dir) { rm(dir); } }
    if exists(ctx.record) { rm(ctx.record); }
    mkdir(ctx.unpacked);
    extract(ctx.archive, ctx.unpacked);
    mkdir(ctx.system);
    for file in ctx.files {
        let from = join_path(ctx.unpacked, file[0]);
        if !is_file(from) { throw "the prebuilt desktop apps lack /" + file[0]; }
        let dest = join_path(ctx.system, file[0]);
        mkdir(dirname(dest));
        copy_file(from, dest);
        target_mode(ctx.system, file[0], file[1]);
    }
    rm(ctx.unpacked);
    target_finalize(ctx.system, #{ owners: "apply" });
    write_file(ctx.record, ctx.pin[2] + "\n");
    ctx
}

fn is_installed(ctx) {
    if !is_dir(ctx.system) { return needs_work(ctx, "unpack the desktop apps"); }
    ctx.outputs.system = ctx.system;
    check_system(ctx)
}

fn install(ctx) {
    ctx.outputs.system = ctx.system;
    ctx
}

fn remove(ctx) {
    for dir in [ctx.system, ctx.record] { if exists(dir) { rm(dir); } }
    ctx.outputs = #{};
    ctx
}
