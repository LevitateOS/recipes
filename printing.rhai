const RECIPE_API = 1;
// printing: a Recipe group, installed into the system root (`recipe --system install printing`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: printing.pins beside this file (the pinned packages and
// the group's version), written by `cargo xtask base groups levitate` (glibc:
// Fedora RPMs) and `cargo xtask base groups acorn` (musl: Alpine APKs) from the
// seeds below. A package more than one group needs belongs to desktop-libs.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "kojipkgs.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};


const ABOUT = #{
    kind: "system",
    category: "utilities",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "CUPS with its filters and driverless network printers found through Avahi; IPP over USB on LevitateOS, and the printer settings program system-config-printer on AcornOS. Plasma's printer settings are the print-manager recipe, which needs both this and Plasma.",
    homepage: "https://openprinting.github.io/cups/",
    license: "Apache-2.0 WITH LLVM-exception AND GPL-2.0-or-later AND LGPL-2.1-or-later",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "printing", description: "Printing: CUPS with driverless printers" };   // version: printing.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["cups", "cups-filters", "ipp-usb", "avahi"],
    musl:  ["cups", "cups-filters", "avahi", "system-config-printer"],
};

// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS = #{
    musl: [
        "g avahi 86", "u avahi 86 'Avahi System User' /var/run/avahi-daemon /sbin/nologin", "g lp 7",
        "u lp 4 'lp' /var/spool/lpd /sbin/nologin", "g lpadmin -", "m lp lp",
    ],
};

let deps = ["desktop-libs"];

// CUPS and the Avahi discovery that driverless printing uses start at boot
// (Avahi also as dbus-org.freedesktop.Avahi on systemd). On Fedora the print
// commands are the links `alternatives` would make (lpr, lp, lpq, lprm,
// lpstat, cancel, lpc and their manual pages) to CUPS's. On AcornOS the menu
// hides CUPS's web page (the printer settings program does the job).
//
// /etc/cups itself is cups-filesystem's (root:lp), which is in desktop-libs;
// this tree only has it as the parent of CUPS's files, and Recipe gives the
// directory the owner and mode desktop-libs states.
fn configure(tree) {
    if PACKAGE_FORMAT == "rpm" {
        enable_service(tree, "cups.service", "");
        enable_service(tree, "avahi-daemon.service", "");
        for pair in [["usr/bin/lpr", "lpr.cups"], ["usr/bin/lp", "lp.cups"], ["usr/bin/lpq", "lpq.cups"], ["usr/bin/lprm", "lprm.cups"],
                     ["usr/bin/lpstat", "lpstat.cups"], ["usr/bin/cancel", "cancel.cups"], ["usr/bin/lpc", "lpc.cups"],
                     ["usr/share/man/man1/cancel.1.gz", "cancel-cups.1.gz"], ["usr/share/man/man1/lp.1.gz", "lp-cups.1.gz"],
                     ["usr/share/man/man8/lpc.8.gz", "lpc-cups.8.gz"], ["usr/share/man/man1/lpq.1.gz", "lpq-cups.1.gz"],
                     ["usr/share/man/man1/lpr.1.gz", "lpr-cups.1.gz"], ["usr/share/man/man1/lprm.1.gz", "lprm-cups.1.gz"],
                     ["usr/share/man/man1/lpstat.1.gz", "lpstat-cups.1.gz"]] {
            if !exists(join_path(tree, dirname(pair[0]) + "/" + pair[1])) { throw "printing: cups-client no longer ships /" + dirname(pair[0]) + "/" + pair[1]; }
            put_link(tree, pair[0], pair[1]);
        }
    } else {
        enable_service(tree, "", "cupsd");
        enable_service(tree, "", "avahi-daemon");
        let entry = "usr/share/applications/cups.desktop";
        let text = tree_text(tree, entry);
        if !text.contains("\nNoDisplay=") { put(tree, entry, text.replace("[Desktop Entry]\n", "[Desktop Entry]\nNoDisplay=true\n"), 0o644); }
    }
}
