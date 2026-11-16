const RECIPE_API = 1;
// xlibre: a Recipe group, installed into the system root (`recipe --system install xlibre`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library and the groups it needs (deps).
// Generated: xlibre.pins beside this file (the pinned packages and the group's
// version), written by `cargo xtask base groups levitate` (glibc: Fedora RPMs)
// and `cargo xtask base groups acorn` (musl: Alpine APKs) from the seeds below.
// A package more than one group needs belongs to desktop-libs.
//
// The X server itself (Xorg, its setuid wrapper, /usr/bin/X, the modesetting
// and libinput drivers, the server's other modules and its xorg.conf.d
// snippets) is not in a package: the OS builder compiles it from pinned
// XLibre source (distro/builder/os-recipes/xlibre.rhai) and publishes the
// tree as the LevitateOS/prebuilt release `display-server-<key16>`. This
// recipe pins that archive (SOURCES.prebuilt below, as rec-apps pins the
// desktop apps) and Recipe puts the files FILES lists into the same system
// tree as the packages. Nothing generates SOURCES.prebuilt: when a new
// display-server prebuilt is published (the XLibre pins or the Alpine build
// root changed), move it to the newest `display-server-<key16>` release by
// hand: its asset's URL and the SHA-256 GitHub shows for it, and
// NEEDS.network_max_bytes to cover its size (1469755 bytes today; Recipe adds
// the pins' bytes).
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443", "github.com:443", "release-assets.githubusercontent.com:443", "objects.githubusercontent.com:443"],
    network_max_bytes: 2097152,
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

const ABOUT = #{
    kind: "system",
    category: "drivers-codecs",
    libc: ["musl"],
    systems: ["acornos"],
    details: "The XLibre X server, its libinput driver and what they load at run time: the keymap compiler and keymaps, the cursor and fixed fonts, Mesa's EGL and GBM for glamor and the libraries the server links. The server itself, with its setuid wrapper, /usr/bin/X and the modesetting and libinput drivers, is the OS builder's pinned prebuilt tree, compiled from pinned XLibre source.",
    homepage: "https://github.com/X11Libre",
    license: "MIT AND X11 AND LGPL-2.1-or-later",
    steps: #{
        download: "Takes each pinned package and the pinned display-server prebuilt by their SHA-256, from the install medium's cache or the distribution's mirror and GitHub.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, adds the X server's files from the prebuilt, the wrapper setuid root, and writes the tree into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "xlibre", description: "The XLibre display server and its run-time parts" };   // version: xlibre.pins

// What this group installs, by name; the generator adds what they need.
// LevitateOS (glibc, Fedora 45): none, so there is no glibc build.
// AcornOS (musl, Alpine 3.24): the seeds below.
const PACKAGES = #{
    musl: ["xkbcomp", "font-cursor-misc", "font-misc-misc", "libxfont2", "libxcvt"],
};

let deps = ["desktop-libs"];

// The display-server prebuilt: the LevitateOS/prebuilt release
// `display-server-<key16>` that `prebuilt publish display-server acorn`
// makes; the SHA-256 is the digest GitHub publishes for the asset. Moved by
// hand to each new release (see the header). Its paths start at usr/, so its
// top folder is kept (strip: false).
const SOURCES = #{
    prebuilt: #{
        url: "https://github.com/LevitateOS/prebuilt/releases/download/display-server-56df0167e337c893/display-server-acorn.tar.gz",
        sha256: "76374e35feae26a044e4f5e5bd1045403473d6f0bf85454025dccf177008bfe5",
        strip: false,
        libc: "musl",
    },
};

// What the system tree takes from the prebuilt tree, the builder's
// installed-files list (the modules are under usr/lib/xorg/modules/xlibre-25).
// Xorg.wrap is setuid root as in Alpine's package; the prebuilt keeps that
// mode in its target metadata, which a plain unpack does not carry, so it is
// set here (in a system tree the mode goes into the target metadata).
// /usr/bin/X (the link the display manager starts) and /var/lib/xkb are made
// in configure.
const FILES = [
    ["prebuilt/usr/bin/Xorg",                                                "usr/bin/Xorg", 0o755],
    ["prebuilt/usr/bin/gtf",                                                 "usr/bin/gtf", 0o755],
    ["prebuilt/usr/libexec/Xorg",                                            "usr/libexec/Xorg", 0o755],
    ["prebuilt/usr/libexec/Xorg.wrap",                                       "usr/libexec/Xorg.wrap", 0o4555],
    ["prebuilt/usr/lib/xorg/protocol.txt",                                   "usr/lib/xorg/protocol.txt", 0o644],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/drivers/modesetting_drv.so",   "usr/lib/xorg/modules/xlibre-25/drivers/modesetting_drv.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/input/libinput_drv.so",        "usr/lib/xorg/modules/xlibre-25/input/libinput_drv.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/extensions/libglx.so",         "usr/lib/xorg/modules/xlibre-25/extensions/libglx.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/libglamoregl.so",              "usr/lib/xorg/modules/xlibre-25/libglamoregl.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/libexa.so",                    "usr/lib/xorg/modules/xlibre-25/libexa.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/libfbdevhw.so",                "usr/lib/xorg/modules/xlibre-25/libfbdevhw.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/libint10.so",                  "usr/lib/xorg/modules/xlibre-25/libint10.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/libshadow.so",                 "usr/lib/xorg/modules/xlibre-25/libshadow.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/libshadowfb.so",               "usr/lib/xorg/modules/xlibre-25/libshadowfb.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/libvgahw.so",                  "usr/lib/xorg/modules/xlibre-25/libvgahw.so", 0o755],
    ["prebuilt/usr/lib/xorg/modules/xlibre-25/libwfb.so",                    "usr/lib/xorg/modules/xlibre-25/libwfb.so", 0o755],
    ["prebuilt/usr/share/X11/xorg.conf.d/10-quirks.conf",                    "usr/share/X11/xorg.conf.d/10-quirks.conf", 0o644],
    ["prebuilt/usr/share/X11/xorg.conf.d/40-libinput.conf",                  "usr/share/X11/xorg.conf.d/40-libinput.conf", 0o644],
];

// After Recipe has unpacked the packages and placed FILES: the link the
// display manager starts (SDDM runs /usr/bin/X), to the wrapper script, as
// the server's own install makes it; and where the server writes the keymaps
// xkbcomp compiles: empty, a state seed (the server's -Dxkb_output_dir).
fn configure(tree) {
    put_link(tree, "usr/bin/X", "Xorg");
    mkdir(join_path(tree, "var/lib/xkb"));
    target_mode(tree, "var/lib/xkb", 0o755);
}
