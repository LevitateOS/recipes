const RECIPE_API = 1;
// desktop-libs: a Recipe group, installed into the system root (`recipe --system install desktop-libs`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: desktop-libs.pins beside this file (the pinned packages and
// the group's version), written by `cargo xtask base groups levitate` (glibc:
// Fedora RPMs) and `cargo xtask base groups acorn` (musl: Alpine APKs) from the
// seeds below. A package more than one group needs belongs to desktop-libs.
//
// Its seeds are empty on purpose: the generator gives it every package two or
// more groups' closures need.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "kojipkgs.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
    runtime: "minimal",
};

const ABOUT = #{
    kind: "library",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "What two or more of the desktop groups need, kept in one place so each group can be removed without taking another's libraries with it: Qt, the KDE Frameworks on LevitateOS, GTK, Mesa's libraries, codecs and the like. Its packages are chosen by the generator, not named by hand: every package more than one group's closure needs.",
    homepage: "https://levitateos.org",
    license: "LGPL-2.1-or-later AND LGPL-3.0-only AND GPL-2.0-or-later AND MIT AND BSD-3-Clause",
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "desktop-libs", description: "Libraries more than one desktop group needs" };   // version: desktop-libs.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{ glibc: [], musl: [] };

// Accounts the packages' files or daemons need that their own
// usr/lib/sysusers.d does not make (sysusers.d `g`/`u` lines). Fedora packages
// ship sysusers.d files; Alpine packages make theirs in install scripts, which
// never run, so the AcornOS lines are written here from those scripts.
const ACCOUNTS = #{ musl: ["g camera -"] };

let deps = [];

fn configure(tree) {
    if PACKAGE_FORMAT != "apk" { return; }
    // Alpine's fonts.conf lists only /var/cache/fontconfig, where Recipe keeps
    // no files, so the root effects recipe's font caches would be lost. This
    // adds Fedora's directory, /usr/lib/fontconfig/cache, which fontconfig
    // reads (every listed cache directory is read) and which the effects run
    // writes (the first writable one is written). fonts.conf includes conf.d
    // before its own <cachedir> lines, so this one comes first; a user's
    // fc-cache on the read-only root skips it and writes the next writable
    // one (/var/cache/fontconfig, else the user's own).
    if is_file(join_path(tree, "etc/fonts/fonts.conf")) {
        put(tree, "etc/fonts/conf.d/00-system-cache.conf",
            "<?xml version=\"1.0\"?>\n<!DOCTYPE fontconfig SYSTEM \"urn:fontconfig:fonts.dtd\">\n<fontconfig>\n\t<!-- The caches the root effects recipe builds, owned by system-effects. -->\n\t<cachedir>/usr/lib/fontconfig/cache</cachedir>\n</fontconfig>\n", 0o644);
    }
    if is_file(join_path(tree, "usr/bin/pinentry-curses")) && !exists(join_path(tree, "usr/bin/pinentry")) {
        put_link(tree, "usr/bin/pinentry", "pinentry-curses");
    }
}
