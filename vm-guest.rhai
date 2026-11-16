const RECIPE_API = 1;
// vm-guest: a Recipe group, installed into the system root (`recipe --system install vm-guest`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: vm-guest.pins beside this file (the pinned packages and
// the group's version), written by `cargo xtask base groups levitate` (glibc:
// Fedora RPMs) and `cargo xtask base groups acorn` (musl: Alpine APKs) from the
// seeds below. A package more than one group needs belongs to desktop-libs.
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
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "spice-vdagent: clipboard sharing and display resizing in a SPICE (libvirt) virtual machine.",
    homepage: "https://www.spice-space.org",
    license: "GPL-3.0-or-later",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "vm-guest", description: "Guest agent for SPICE virtual machines" };   // version: vm-guest.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["spice-vdagent"],
    musl:  ["spice-vdagent"],
};

let deps = ["desktop-libs"];

fn configure(tree) {
    if PACKAGE_FORMAT != "apk" { return; }
    tree_text(tree, "etc/init.d/spice-vdagentd");   // fails when spice-vdagent no longer ships its OpenRC service
    let s = "#!/sbin/openrc-run\ndescription=\"Start spice-vdagentd when the machine is a VM with its port\"\n\n";
    s += "depend() {\n    need localmount\n    after udev-settle\n}\n\nstart() {\n";
    s += "    [ -e /dev/virtio-ports/com.redhat.spice.0 ] && rc-service spice-vdagentd start\n";
    s += "    return 0\n}\n";
    put(tree, "etc/init.d/spice-vdagent-vm", s, 0o755);
    put_link(tree, "etc/runlevels/default/spice-vdagent-vm", "/etc/init.d/spice-vdagent-vm");
}
