// login-screen: a Recipe group, installed into the system root (`recipe --system install login-screen`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps).
// Generated: the two pin blocks, `version` and `network_max_bytes`, written by
// `cargo xtask base groups levitate` (glibc: Fedora RPMs) and
// `cargo xtask base groups acorn` (musl: Alpine APKs) from the seeds below. A
// package more than one group needs belongs to desktop-libs.
const RECIPE_API = 3;
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    network_max_bytes: 4194304,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["musl"],
    systems: ["acornos"],
    details: "SDDM, the graphical login screen; on LevitateOS with Plasma's Breeze theme and Wayland greeter. It lists whatever sessions the installed desktops provide.",
    homepage: "https://github.com/sddm/sddm",
    license: "GPL-2.0-or-later",
    steps: #{
        acquire: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        build: "Unpacks the packages natively into one system tree, without running their scripts.",
        install: "Publishes the system tree for Recipe to write into the system root, with a receipt.",
    },
    keeps: [],
};

// What this group installs, by name; the generator adds what they need.
// LevitateOS (glibc, Fedora 45):
const SEEDS_GLIBC = [];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "sddm"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [
    "g sddm -", "u sddm - 'SDDM display manager' /var/lib/sddm /sbin/nologin", "m sddm video"
];
let deps = ["desktop-libs"];

let ctx = #{
    name: "login-screen",
    version: "2026.11.16",
    description: "The SDDM login screen",
};

// BEGIN GENERATED PINS glibc
// No glibc build: this recipe names no seeds in SEEDS_GLIBC. Written by
// `cargo xtask base groups levitate`; do not edit.
const RPM_PINNED_ON = "";
const RPM_PINNED_BYTES = 0;
const RPM_PINS = [];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-16): 4 packages, 3969110 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-16";
const APK_PINNED_BYTES = 3969110;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["sddm", "sddm-0.21.0-r10.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sddm-0.21.0-r10.apk", "632ee19ebeeb207dc98cf8575f3fabf8d911df3cfd8de52f903382d57e13f8cd", 3836964, "GPL-2.0-or-later", false],
    ["sddm-openrc", "sddm-openrc-0.21.0-r10.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/sddm-openrc-0.21.0-r10.apk", "56d6bf208dc3b8ef7da1c55f363263281ae84398235c76602f6b97a623e21368", 1889, "GPL-2.0-or-later", false],
    ["upower", "upower-1.91.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/upower-1.91.0-r2.apk", "78761cf27cb5d4a516a11e5536ad2236eee6c1a811e720266ee3b81e9af06430", 126255, "GPL-2.0-or-later", true],
    ["upower-udev", "upower-udev-1.91.0-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/upower-udev-1.91.0-r2.apk", "defc1d7faf6c795758a28cec57b96f82d6e23f0497d31aa6b9acb64d2b9d30a0", 4002, "GPL-2.0-or-later", false],
];
// END GENERATED PINS musl

// BEGIN GENERATED OS FACTS glibc
// Written by `cargo xtask base groups levitate` from distro/variants/levitate/distro.toml
// (identity, profile, look); do not edit.
const RPM_OS = #{
    id: "levitateos",
    name: "LevitateOS",
    home_url: "https://levitateos.org",
    desktop: "plasma",
    appearance: "dark",
    light: #{
        surface: "#DDE2D2",
        surface_raised: "#E8ECDF",
        surface_sunken: "#CFD6C3",
        text: "#14221A",
        text_secondary: "#465047",
        text_muted: "#5C6459",
        rule: "#AEB8A4",
        hairline: "#C6CDB9",
        accent: "#214438",
        highlight: "#644532",
        band: "#214438",
        on_band: "#F2EEE4",
        ok: "#2F6B3F",
        warn: "#7F5200",
        bad: "#B22F27",
    },
    dark: #{
        surface: "#14221A",
        surface_raised: "#1D2D24",
        surface_sunken: "#0D1711",
        text: "#F2EEE4",
        text_secondary: "#BAC5B7",
        text_muted: "#9AA89D",
        rule: "#3A4B40",
        hairline: "#2A3B31",
        accent: "#C7D9BA",
        highlight: "#E4CBA6",
        band: "#214438",
        on_band: "#F2EEE4",
        ok: "#A9CF9A",
        warn: "#F0B866",
        bad: "#F0A497",
    },
};
// END GENERATED OS FACTS glibc

// BEGIN GENERATED OS FACTS musl
// Written by `cargo xtask base groups acorn` from distro/variants/acorn/distro.toml
// (identity, profile, look); do not edit.
const APK_OS = #{
    id: "acornos",
    name: "AcornOS",
    home_url: "",
    desktop: "lxqt",
    appearance: "dark",
    light: #{
        surface: "#E6DFCF",
        surface_raised: "#EFE9DB",
        surface_sunken: "#D9D1BE",
        text: "#241A12",
        text_secondary: "#54483C",
        text_muted: "#6B5D4F",
        rule: "#C2B8A2",
        hairline: "#D0C7B3",
        accent: "#644532",
        highlight: "#214438",
        band: "#644532",
        on_band: "#F2EEE4",
        ok: "#2F6B3F",
        warn: "#7F5200",
        bad: "#B22F27",
    },
    dark: #{
        surface: "#1F1711",
        surface_raised: "#2B2019",
        surface_sunken: "#150F0A",
        text: "#F2EEE4",
        text_secondary: "#CDBFAE",
        text_muted: "#A89886",
        rule: "#4D3D30",
        hairline: "#382B21",
        accent: "#E4CBA6",
        highlight: "#C7D9BA",
        band: "#644532",
        on_band: "#F2EEE4",
        ok: "#A9CF9A",
        warn: "#F0B866",
        bad: "#F0A497",
    },
};
// END GENERATED OS FACTS musl

// The rest is the same in every group recipe.
//
// Which build this system takes: the Fedora RPMs on glibc (LevitateOS), the
// Alpine APKs on musl (AcornOS). RUNTIME.host.libc is the C library of the
// system the group is installed into.
ctx.libc = RUNTIME.host.libc;
ctx.downloads = join_path(RUNTIME.paths.build, "downloads");
ctx.record = join_path(RUNTIME.paths.build, "system.pins");
ctx.system = join_path(RUNTIME.paths.output, "system");
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
ctx.no_build = ctx.name + " has pins for glibc (Fedora RPMs, LevitateOS) and musl (Alpine APKs, AcornOS); " +
    "this system's C library is " + ctx.libc + ", for which it has none. `cargo xtask base groups <distro>` " +
    "writes a variant's pins once the recipe names seeds for its C library.";
if ctx.pinned_bytes > NEEDS.network_max_bytes {
    throw "the pinned packages (" + ctx.pinned_bytes + " bytes) exceed NEEDS.network_max_bytes; " +
        "`cargo xtask base groups <distro>` sets it";
}
// What the system tree was made from: one line per pinned package.
ctx.pins_record = "";
for pin in ctx.pins {
    ctx.pins_record += pin[3] + "  " + pin[1] + "\n";
}

fn archive_of(ctx, pin) {
    join_path(ctx.downloads, pin[1])
}

fn check_system(ctx) {
    if ctx.pins.is_empty() { return needs_work(ctx, ctx.no_build); }
    if !is_file(ctx.record) || !is_dir(ctx.system) {
        return needs_work(ctx, "unpack the " + ctx.pins.len() + " packages of " + ctx.name);
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
    ready(ctx)
}

// Each pinned file by its SHA-256: from the install medium's cache when
// Recipe finds it there, else from the distribution's mirror.
fn acquire(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    mkdir(ctx.downloads);
    let done = 0;
    for pin in ctx.pins {
        progress(done, ctx.pins.len(), "packages");
        download(pin[2], archive_of(ctx, pin), pin[3]);
        done += 1;
    }
    progress(done, ctx.pins.len(), "packages");
    ctx
}

fn is_built(ctx) {
    check_system(ctx)
}

// Unpacks every package into one system tree, natively, without running any
// of its scripts. Paths a system package does not own (run-time data: run,
// tmp and the like) are left out. Under var/, only what a package needs and
// nothing at boot makes (pin[6]: it ships no tmpfiles.d, and AcornOS runs
// none) is kept, as state seeds: created where missing, never owned or
// removed. Owners stay names, resolved in the root the group is written
// into, after the accounts it needs are made there: those in its own
// usr/lib/sysusers.d (Fedora packages ship them) and ACCOUNTS_* above.
fn build(ctx) {
    if ctx.pins.is_empty() { throw ctx.no_build; }
    if exists(ctx.record) { rm(ctx.record); }
    if exists(ctx.system) { rm(ctx.system); }
    mkdir(ctx.system);
    let done = 0;
    // Packages whose var/ is not kept first, then the var/ they left, then
    // the packages whose var/ is kept.
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
    // This group's configuration (configure, above): files in its own tree,
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
// The text of the packaged file `path`; the group's packages must ship it.
fn tree_text(ctx, path) {
    let file = join_path(ctx.system, path);
    if !is_file(file) { throw ctx.name + ": its packages no longer ship /" + path; }
    read_file(file)
}
// Start a system service at boot, in this system's init's own form: on
// systemd (Fedora) the links `systemctl enable` makes, the unit's Alias=
// names included (D-Bus activation finds dbus-org.* through them); on
// OpenRC (Alpine) the service in its runlevel.
fn enable_service(ctx, unit, service) {
    if ctx.format == "rpm" {
        let file = "usr/lib/systemd/system/" + unit;
        let text = tree_text(ctx, file);
        put_link(ctx, "etc/systemd/system/multi-user.target.wants/" + unit, "/" + file);
        for line in text.split("\n") {
            if line.starts_with("Alias=") {
                for alias in trim(line.sub_string(6)).split(" ") {
                    if alias != "" { put_link(ctx, "etc/systemd/system/" + alias, "/" + file); }
                }
            }
        }
    } else {
        if !is_file(join_path(ctx.system, "etc/init.d/" + service)) { throw ctx.name + ": its packages no longer ship the OpenRC service " + service; }
        put_link(ctx, "etc/runlevels/default/" + service, "/etc/init.d/" + service);
    }
}

// ---------------------------------------------------------------------------
// This group's configuration (hand-written).
// ---------------------------------------------------------------------------

// The login screen on AcornOS (on LevitateOS SDDM is part of plasma): SDDM
// starts at boot after dbus and elogind; SDDM's own Maldives theme under the
// OS's name (Alpine's copy does not say it is for the Qt 6 greeter, the only
// one Alpine has) with the starting mode's wallpaper (the base's file) and
// the Adwaita cursor. Alpine's sddm service waits in start_post for the
// greeter's runtime directory, which an autologin never makes; its conf.d,
// sourced before the service script, makes that wait succeed.
ctx.os = APK_OS;
fn configure(ctx) {
    let os = ctx.os;
    let background = "/usr/share/wallpapers/" + os.name + (if os.appearance == "dark" { "/contents/images_dark/3840x2160.jpg" } else { "/contents/images/3840x2160.jpg" });
    let themes = "usr/share/sddm/themes/";
    let theme = os.id;
    let packaged = themes + "maldives/";
    let meta = tree_text(ctx, packaged + "metadata.desktop");
    for file in ["Main.qml", "angle-down.png", "rectangle.png"] {
        mkdir(join_path(ctx.system, themes + theme));
        copy_file(join_path(ctx.system, packaged + file), join_path(ctx.system, themes + theme + "/" + file));
        target_mode(ctx.system, themes + theme + "/" + file, 0o644);
    }
    let metadata = "";
    for line in meta.split("\n") {
        if line.starts_with("Name=") { line = "Name=" + os.name; }
        else if line.starts_with("Theme-Id=") { line = "Theme-Id=" + theme; }
        else if line.starts_with("Screenshot=") || line.starts_with("QtVersion=") || line == "" { continue; }
        metadata += line + "\n";
    }
    put(ctx, themes + theme + "/metadata.desktop", metadata + "QtVersion=6\n", 0o644);
    put(ctx, themes + theme + "/theme.conf", "[General]\nbackground=" + background + "\n", 0o644);
    put(ctx, "etc/sddm.conf.d/10-theme.conf", "[Theme]\nCurrent=" + theme + "\nCursorTheme=Adwaita\n", 0o644);
    let conf = "etc/conf.d/sddm";
    let text = read_file_or_empty(join_path(ctx.system, conf));
    if text != "" && !text.ends_with("\n") { text += "\n"; }
    text += "# The desktop system (installed-system.rhai): start_post's wait for the\n";
    text += "# greeter's runtime directory succeeds, since an autologin starts no greeter.\n";
    text += "ewaitfile() { return 0; }\n";
    put(ctx, conf, text, 0o644);
    enable_service(ctx, "", "sddm");
}
