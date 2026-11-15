// firewall: a Recipe group, installed into the system root (`recipe --system install firewall`)
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
    network_max_bytes: 3145728,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "firewalld and its graphical settings (Plasma's firewall page on LevitateOS, firewall-config on AcornOS).",
    homepage: "https://firewalld.org",
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
const SEEDS_GLIBC = [
    "firewalld", "plasma-firewall", "plasma-firewall-firewalld"
];
// AcornOS (musl, Alpine 3.24):
const SEEDS_MUSL = [
    "firewalld", "firewalld-gui"
];
// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS_GLIBC = [];
const ACCOUNTS_MUSL = [];
let deps = ["desktop-libs"];

let ctx = #{
    name: "firewall",
    version: "2026.11.16",
    description: "The firewalld firewall, with its settings",
};

// BEGIN GENERATED PINS glibc
// Written by `cargo xtask base groups levitate`; do not edit. This group's
// share of the Fedora 45 RPMs in levitate-rpm-lock.rhai and levitate-rpm-desktop-lock.rhai (locked on
// 2026-11-16): 12 packages, 2770097 bytes. Licences are each package's own.
const RPM_PINNED_ON = "2026-11-16";
const RPM_PINNED_BYTES = 2770097;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const RPM_PINS = [
    ["firewalld", "firewalld-2.5.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/firewalld-2.5.2-1.fc45.noarch.rpm", "a214f928b56fb678ccba8c328e976d02ef5684a4915ec216ca4ea86df473b541", 560763, "GPL-2.0-or-later", false],
    ["firewalld-filesystem", "firewalld-filesystem-2.5.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/firewalld-filesystem-2.5.2-1.fc45.noarch.rpm", "ac762b333c9bbc7c0072fa224f12010453dd7a8278ce95ae02a35349465817f4", 10041, "GPL-2.0-or-later", false],
    ["iptables-libs", "iptables-libs-1.8.13-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/i/iptables-libs-1.8.13-3.fc45.x86_64.rpm", "2e918ea84115596b7469fbe5a335e5f25cd438f8f3a412acd6f10c1c50550676", 415476, "GPL-2.0-only AND Artistic-2.0 AND ISC", false],
    ["libnetfilter_conntrack", "libnetfilter_conntrack-1.1.1-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libnetfilter_conntrack-1.1.1-2.fc45.x86_64.rpm", "929bfe0bd5def4a1b8d9ce63b70e7a3bf688f5e15bcb9625f349d4f73c2d8e51", 63697, "GPL-2.0-or-later", false],
    ["libnfnetlink", "libnfnetlink-1.0.2-2.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libnfnetlink-1.0.2-2.fc45.x86_64.rpm", "d332a8c13a1aff44d45b9106b883dcada5d50d8f399f13bd6dd5c23e8d516a1e", 29887, "GPL-2.0-or-later", false],
    ["libnftnl", "libnftnl-1.3.1-3.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libnftnl-1.3.1-3.fc45.x86_64.rpm", "b79fbb57a0852c4e6e3b6d94221ac2c6ac195c166d846ea47297fd5ed69ee080", 91975, "GPL-2.0-or-later", false],
    ["nftables", "nftables-1.1.6-4.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/nftables-1.1.6-4.fc45.x86_64.rpm", "6cd8d5b71430fa8aec48d012aa3b663d53dbf703ac7d753be633d35716b7dc64", 459829, "GPL-2.0-only", false],
    ["nftables-services", "nftables-services-1.1.6-4.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/nftables-services-1.1.6-4.fc45.noarch.rpm", "01755da25f0fca3082369a821cf627a5bef4c317ced0911991f5b0c9dc76ff10", 21833, "GPL-2.0-only", false],
    ["plasma-firewall", "plasma-firewall-6.8.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-firewall-6.8.3-1.fc45.x86_64.rpm", "d62d6fa48864c4058ad558d0e0a933d418398bafd1c329cf37066b93ac0a25a6", 497073, "BSD-3-Clause AND CC0-1.0 AND FSFAP AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND GPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only)", false],
    ["plasma-firewall-firewalld", "plasma-firewall-firewalld-6.8.3-1.fc45.x86_64.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/plasma-firewall-firewalld-6.8.3-1.fc45.x86_64.rpm", "deffea21dc5a832b9584f1ba0f96a065776296a691b4f34548ee48132be8b82c", 68381, "BSD-3-Clause AND CC0-1.0 AND FSFAP AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND GPL-3.0-or-later AND (GPL-2.0-only OR GPL-3.0-only)", false],
    ["python3-firewall", "python3-firewall-2.5.2-1.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-firewall-2.5.2-1.fc45.noarch.rpm", "08a28652e5f832fafb71c980190977b71fcaa1d7396c96312e416b0c01e7dff9", 529323, "GPL-2.0-or-later", false],
    ["python3-nftables", "python3-nftables-1.1.6-4.fc45.noarch.rpm", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/python3-nftables-1.1.6-4.fc45.noarch.rpm", "fe9473c5269c296aceb0b2ef09b8a46af57da3399142df8b7cc0fa9ba13535d0", 21819, "GPL-2.0-only", false],
];
// END GENERATED PINS glibc

// BEGIN GENERATED PINS musl
// Written by `cargo xtask base groups acorn`; do not edit. This group's
// share of the Alpine v3.24 APKs in acorn-apk-lock.rhai and acorn-apk-desktop-lock.rhai (locked on
// 2026-11-16): 10 packages, 1791901 bytes. Licences are each package's own.
const APK_PINNED_ON = "2026-11-16";
const APK_PINNED_BYTES = 1791901;
// [name, file, URL, SHA-256, bytes, licence, var/ kept as state seeds]
const APK_PINS = [
    ["firewalld", "firewalld-2.4.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/firewalld-2.4.1-r0.apk", "8efe764d658857908903bf22c84f4dd2c9e2658c0541f0175f68848c942608ee", 1217504, "GPL-2.0-or-later", false],
    ["firewalld-bash-completion", "firewalld-bash-completion-2.4.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/firewalld-bash-completion-2.4.1-r0.apk", "308acd02e6b2c43b53db00106cc2ae6cd180d59a8a22efc75b60045f0d63e082", 4288, "GPL-2.0-or-later", false],
    ["firewalld-gui", "firewalld-gui-2.4.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/firewalld-gui-2.4.1-r0.apk", "8dd9dcf4b3781d1882325a92377f854471aa6c77818618043add2e10954cd7c5", 110301, "GPL-2.0-or-later", false],
    ["firewalld-openrc", "firewalld-openrc-2.4.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/community/x86_64/firewalld-openrc-2.4.1-r0.apk", "a99a61ac70fd526899e6f0e40ec3db2161c160148d3954743fa4f73b7c95d6f5", 1787, "GPL-2.0-or-later", false],
    ["libnftnl", "libnftnl-1.3.1-r0.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libnftnl-1.3.1-r0.apk", "2f4cf35959fde00fdba0dd35ef12a6739739b504e8319c97e30bd4834f98d924", 67237, "GPL-2.0-or-later", false],
    ["nftables", "nftables-1.1.6-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/nftables-1.1.6-r1.apk", "edca96e6160479bd734bb6cdb8412f84f689c6a771fdec75ce2c1c18f3e7cf42", 348599, "GPL-2.0-or-later", true],
    ["nftables-openrc", "nftables-openrc-1.1.6-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/nftables-openrc-1.1.6-r1.apk", "91c361bb038b4e37f1e9a586d43e2b3f8ebf607ace3280ee0194fa00c00ae0be", 3748, "GPL-2.0-or-later", false],
    ["py3-libcap-ng", "py3-libcap-ng-0.8.5-r2.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-libcap-ng-0.8.5-r2.apk", "671053f2782eca0f1eed6a175ccb6f9753d32c0e6e5fa78543c607cd91d3bb20", 21634, "GPL-2.0-or-later AND LGPL-2.1-or-later", false],
    ["py3-nftables", "py3-nftables-1.1.6-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-nftables-1.1.6-r1.apk", "f7e030c338f75d5d9f65e64e5360e20f44e46ba73cde2c9bc53440818ab68856", 7072, "GPL-2.0-or-later", false],
    ["py3-nftables-pyc", "py3-nftables-pyc-1.1.6-r1.apk", "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/py3-nftables-pyc-1.1.6-r1.apk", "74bd6e1d96d581e053926c93f21b8f2f0dd2779768be7c2785b3ab012dec787a", 9731, "GPL-2.0-or-later", false],
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

// firewalld starts at boot (also as dbus-org.fedoraproject.FirewallD1 on
// systemd), and its default zone, public, refuses every incoming connection
// but replies, ssh (whose server is off unless enabled), DHCPv6 and mDNS
// answers, which Avahi needs to find driverless printers.
fn configure(ctx) {
    tree_text(ctx, "usr/lib/firewalld/zones/public.xml");
    let zone = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<zone>\n  <short>Public</short>\n";
    zone += "  <description>Incoming connections are refused, except replies, ssh, DHCPv6 and mDNS.</description>\n";
    zone += "  <service name=\"ssh\"/>\n  <service name=\"dhcpv6-client\"/>\n  <service name=\"mdns\"/>\n  <forward/>\n</zone>\n";
    put(ctx, "etc/firewalld/zones/public.xml", zone, 0o644);
    enable_service(ctx, "firewalld.service", "firewalld");
}
