// network: a Recipe group, installed into the system root (`recipe --system install network`)
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
    network_max_bytes: 7340032,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "NetworkManager and its WiFi support over wpa_supplicant, which bring wired and wireless networks up and keep them up; nmcli comes with it.",
    homepage: "https://networkmanager.dev",
    license: "GPL-2.0-or-later AND LGPL-2.1-or-later AND BSD-3-Clause",
    steps: #{
        acquire: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        build: "Unpacks the packages natively into one system tree, without running their scripts.",
        install: "Publishes the system tree for Recipe to write into the system root, with a receipt.",
    },
    keeps: [],
};

// What this group installs, by name; the generator adds what they need.
// LevitateOS (glibc, Fedora 45):
const SEEDS_GLIBC = [
    "NetworkManager", "NetworkManager-wifi", "wpa_supplicant"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "networkmanager", "networkmanager-cli", "networkmanager-wifi", "wpa_supplicant"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [
    "g plugdev -"
];
let deps = ["desktop-libs"];

let ctx = #{
    name: "network",
    version: "2026.11.13",
    description: "NetworkManager, with WiFi",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-10): 6 packages, 6997607 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-10";
const RPM_PINNED_BYTES = 6997607;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["NetworkManager", "NetworkManager-1.58.1-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/NetworkManager-1.58.1-3.fc45.x86_64.rpm", "d671027360305dbedf54553eb37d49a9072c2ce291d29bc7c800d21f47cfeb47", 2440040, "GPL-2.0-or-later AND LGPL-2.1-or-later", true],
    ["NetworkManager-libnm", "NetworkManager-libnm-1.58.1-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/NetworkManager-libnm-1.58.1-3.fc45.x86_64.rpm", "2a678dcf3676c22ae0f4bcbf6635d7216a3eff34266f3b9f739527037aed85b0", 2293523, "LGPL-2.1-or-later", false],
    ["NetworkManager-wifi", "NetworkManager-wifi-1.58.1-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/NetworkManager-wifi-1.58.1-3.fc45.x86_64.rpm", "87fee075a32918648afe466f90b860575c63cad603697169cb11521d913f7515", 141477, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["libndp", "libndp-1.9-6.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libndp-1.9-6.fc45.x86_64.rpm", "0a7dda4e5c4c6249f7796b5c88ea3f19e0fc09cef346f2de6a88b51e5e6dcadb", 37961, "LGPL-2.1-or-later", false],
    ["pkcs11-provider", "pkcs11-provider-1.3.0-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pkcs11-provider-1.3.0-1.fc45.x86_64.rpm", "c136e282fafec2b162401b14b6b62594e841be3f9bb0bad0f29d87dd7c0ebe94", 214078, "Apache-2.0", false],
    ["wpa_supplicant", "wpa_supplicant-2.11-13.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/w/wpa_supplicant-2.11-13.fc45.x86_64.rpm", "5aed14fde99c7473765ec32fceef7cee7112bee527726388fe80a2aacbb9fba0", 1870528, "BSD-3-Clause", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-13): 12 packages, 4357247 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-13";
const APK_PINNED_BYTES = 4357247;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["ifupdown-ng-wifi", "ifupdown-ng-wifi-0.13.0-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/ifupdown-ng-wifi-0.13.0-r0.apk", "1e2ac354da99c601210a60d236938ec7e2325a9d8adc0fd04f4af4cceaff3af6", 3039, "ISC", false],
    ["libndp", "libndp-1.9-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libndp-1.9-r1.apk", "5249e4624947046729bfc2c48de77ff90a5ed59d934b9f9b1f099f899eea86d1", 16962, "LGPL-2.1-or-later", false],
    ["libnm", "libnm-1.52.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/libnm-1.52.2-r0.apk", "4cf09c5edbf337138c7bafac0246977e4e0543846d844bd5c97e2d789ebf9491", 460235, "GPL-2.0-or-later", false],
    ["networkmanager", "networkmanager-1.52.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/networkmanager-1.52.2-r0.apk", "e94d73bfaeceed7cbae6c10d7197ac7258a6b32b158117c84c2f91f32fcff92b", 1491034, "GPL-2.0-or-later", true],
    ["networkmanager-bash-completion", "networkmanager-bash-completion-1.52.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/networkmanager-bash-completion-1.52.2-r0.apk", "4585b4804c60503d4dfa7d5a0f8d0a6d8ccd2f823d6624655435fc1fb0767bd8", 3188, "GPL-2.0-or-later", false],
    ["networkmanager-cli", "networkmanager-cli-1.52.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/networkmanager-cli-1.52.2-r0.apk", "4de109d73f3632174933acdf1f6bacb3c3c167e32ca1185d7926a1e7404d8ccc", 257437, "GPL-2.0-or-later", false],
    ["networkmanager-openrc", "networkmanager-openrc-1.52.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/networkmanager-openrc-1.52.2-r0.apk", "bb4cc3fa4b0bfe17cfc6ec80a20903eb60c2886fa3fc6d7e6fb92616a4ea407b", 1962, "GPL-2.0-or-later", false],
    ["networkmanager-wifi", "networkmanager-wifi-1.52.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/networkmanager-wifi-1.52.2-r0.apk", "b67f197513616e1d8649c0f2bfb2139ae35017654d8598ef8cb6a4f9242675f4", 106123, "GPL-2.0-or-later", false],
    ["networkmanager-wwan", "networkmanager-wwan-1.52.2-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/networkmanager-wwan-1.52.2-r0.apk", "871e3075cc9fac4dbd0ba6579ed8f64efd4559623bc9ce0edc411b0fbd1cf83a", 57692, "GPL-2.0-or-later", false],
    ["pcsc-lite-libs", "pcsc-lite-libs-2.4.0-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/pcsc-lite-libs-2.4.0-r4.apk", "f01c9af6f32a01dc385e7959dd2215711ab1037afe45f0cbf34efb19c7cb39ac", 22767, "BSD-3-Clause AND BSD-2-Clause AND ISC", false],
    ["wpa_supplicant", "wpa_supplicant-2.11-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/wpa_supplicant-2.11-r4.apk", "6b3dc3546634cebd64570162b6b399582a83d6d00635d7436804e39a7850a0ef", 1933646, "BSD-3-Clause", false],
    ["wpa_supplicant-openrc", "wpa_supplicant-openrc-2.11-r4.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/wpa_supplicant-openrc-2.11-r4.apk", "0241a61765f1ff2416b034f8f4a6fb225aafc43df06beaee4a6c9a711b95dfa4", 3162, "BSD-3-Clause", false],
];
// END GENERATED PINS musl

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

// NetworkManager starts at boot (the OS builder enabled it in the base).
fn configure(ctx) {
    enable_service(ctx, "NetworkManager.service", "networkmanager");
}
