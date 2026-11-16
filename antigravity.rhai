const RECIPE_API = 1;
// Antigravity (Google's agent-first desktop application, "Antigravity App" 2.31.2), x86_64 Linux tarball: an Electron
// 44.9.1 program (glibc, RPATH $ORIGIN) that carries its own Chromium libraries (libffmpeg.so, libvulkan.so.1,
// SwiftShader) but links GTK, NSS, X11, GLib and the C library from the host. This recipe is the first trial of
// "Programs somebody else linked" (docs/recipe-self-contained-packages.md): it builds on the desktop-runtime recipe,
// and carry_libraries rewrites the program and its bundled libraries to the runtime's loader and libraries, so it
// runs on LevitateOS without the host providing any of them.
// Archive SHA-256: computed from our own download. Google publishes no checksum for this tarball, so the pin below is
// trust on first use of the bytes the pinned URL served on 2026-11-13 (size 189909829). The archive's checksum covers
// every file in it; nothing is compiled.
// Left out: chrome-sandbox (a setuid helper; packages hold no setuid files, Chromium falls back to user namespaces).
// Kept: resources/app-update.yml (electron-updater reads it; whether the app tolerates its absence is unverified).
// The icon is icon.png inside app.asar (an uncompressed archive: the PNG is read by its offset and checked against
// the SHA-256 recorded in the asar header). The starter's own SHA-256 is pinned in STARTER_SHA256.
// Licence: no Google licence text ships in the tarball; the product is proprietary Google software. It bundles
// Electron (MIT, LICENSE.electron.txt), Chromium and its third parties (LICENSES.chromium.html) and
// chrome-devtools-mcp (Apache-2.0).
// C library: the build is linked against glibc, and the package brings its own glibc and loader, carried from the
// glibc desktop-runtime (ABOUT.libc and ABOUT.libc_carried). It was made and tried on LevitateOS; on a musl system
// (AcornOS) it has not been tried, and Recipe says so with the command that installs it anyway:
// recipe install --any-libc antigravity.
// No UPSTREAM: the tarball is on Google's storage, not a GitHub release, and no release page is known to read.
const STARTER = `#!/bin/sh
# Starts Antigravity from its package: finds the package through the profile's symlink, names the carried
# runtime's data to the libraries that read it, and runs the program itself (never through the loader:
# Chromium starts its helpers through /proc/self/exe, which must be the program).
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$(readlink -f -- "$0")")/.." && pwd)
lib="$root/lib"
share="$root/share"
export LOCPATH="$lib/locale"
export GCONV_PATH="$lib/gconv"
export GDK_PIXBUF_MODULE_FILE="$lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
export GIO_MODULE_DIR="$lib/gio/modules"
export GTK_PATH="$lib/gtk-3.0"
export GSETTINGS_SCHEMA_DIR="$share/glib-2.0/schemas"
export GLYCIN_DATA_DIR="$share"
printenv LANG >/dev/null || export LANG=C.UTF-8
exec "$lib/antigravity/antigravity" "$@"
`;
const STARTER_SHA256 = "5e233f8864b09da0bd6bd64cf82f690143fd90218b5c2cb6508d45c9d03e00c3";
const DESKTOP_ENTRY = `[Desktop Entry]
Type=Application
Name=Antigravity
Comment=Agent-first development application
Exec=antigravity %U
Icon=antigravity
Terminal=false
Categories=Development;
StartupWMClass=antigravity
`;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["storage.googleapis.com:443"],
    network_max_bytes: 201326592,
    memory_mib: 4096,
    storage_max_objects: 131072,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "app",
    category: "development",
    libc: ["glibc"],
    libc_carried: true,
    details: "Runs Antigravity, Google's agent-first desktop application for software development. It needs a Google account and network access to Google's services. Its build is linked against glibc, and it was made and tried on LevitateOS. It carries the desktop runtime (GTK, NSS, X11, GLib and the C library) inside its own package instead of using the host's, so the desktop image does not have to ship them; the package is about 600 MB. Its sandbox uses unprivileged user namespaces, since the setuid helper is not installed; a kernel without them stops it with an error. The program can check for newer versions through its bundled updater; updates are made by Recipe (recipe update antigravity), and the program's own update setting can be set to manual or none. The package is proprietary Google software.",
    homepage: "https://antigravity.google",
    license: "proprietary (Google terms; bundles Electron MIT, Chromium and Apache-2.0 parts)",
    adds: #{ programs: ["antigravity"], menu: ["Antigravity"] },
    steps: #{
        download: "Downloads the pinned Antigravity tarball from Google's storage. Google publishes no checksum for it; the digest is of the bytes first downloaded.",
        build: "Puts the application under lib/antigravity without its setuid helper, adds the desktop runtime's data, rewrites the program and its libraries to the carried C library and libraries, and adds a starter, a menu entry and an icon; nothing is compiled.",
        install: "Activates the package in the profile.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "antigravity", version: "2.31.2", description: "Antigravity agent-first desktop application" };

let build_deps = ["desktop-runtime"];

const SOURCES = #{
    release: #{
        url: "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.31.2-6470801290035200/linux-x64/Antigravity.tar.gz",
        sha256: "20be3cab21a2aeba9dca3eee9a212f0308cf34b22fb4a8a98b0dedf18ee63413",
    },
};

// The whole application (its top folder Antigravity-x64/ is left out) under lib/antigravity; build then removes
// chrome-sandbox.
const FILES = [
    ["", "lib/antigravity/"],
    ["antigravity", "lib/antigravity/antigravity", 0o755],
    ["chrome_crashpad_handler", "lib/antigravity/chrome_crashpad_handler", 0o755],
    ["libffmpeg.so", "lib/antigravity/libffmpeg.so", 0o755],
    ["libvk_swiftshader.so", "lib/antigravity/libvk_swiftshader.so", 0o755],
    ["libvulkan.so.1", "lib/antigravity/libvulkan.so.1", 0o755],
    ["resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/bin/chrome-devtools-mcp.js", "lib/antigravity/resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/bin/chrome-devtools-mcp.js", 0o755],
    ["resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/bin/chrome-devtools.js", "lib/antigravity/resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/bin/chrome-devtools.js", 0o755],
    ["resources/bin/language_server", "lib/antigravity/resources/bin/language_server", 0o755],
    ["resources/bin/webm_encoder", "lib/antigravity/resources/bin/webm_encoder", 0o755],
];

// app.asar is an uncompressed archive: 8 bytes, the header pickle (294840 bytes), then the files; icon.png sits at
// 8 + 294840 + 4929891, and the asar header records the digest below.
const ICON = #{
    offset: 5224739,
    size: 48633,
    sha256: "b27f0e4a6f14f491ba31bb24533a1f43c677362b12a0744a53fdd09d7c785317",
};
// The runtime's data the program needs, relative to the runtime's sdk (the same place in the package).
const RUNTIME_DATA = ["lib/gconv", "lib/locale", "lib/gio", "lib/gtk-3.0", "lib/gdk-pixbuf-2.0", "lib/glycin-loaders",
                      "share/glycin-loaders", "share/glib-2.0/schemas"];
// What every finished package holds; verify checks them.
const REQUIRED = ["lib/antigravity/antigravity", "share/applications/antigravity.desktop",
                  "share/icons/hicolor/512x512/apps/antigravity.png", "lib/ld-linux-x86-64.so.2", "lib/locale",
                  "lib/gconv", "share/glib-2.0/schemas"];

// FILES has put the application under lib/antigravity; this makes the rest of the package around it.
fn build(src, out) {
    if type_of(PREFIX) != "string" { throw "antigravity must be installed with activation: its loader path is the profile's"; }
    let sdk = DEPS["desktop-runtime"];
    let app = join_path(out, "lib/antigravity");

    // The setuid helper is left out.
    let sandbox = join_path(app, "chrome-sandbox");
    if exists(sandbox) { rm(sandbox); }

    // The icon, read out of the uncompressed app.asar.
    let icon = join_path(out, "share/icons/hicolor/512x512/apps/antigravity.png");
    mkdir(dirname(icon));
    shell("tail -c +" + (ICON.offset + 1) + " '" + join_path(app, "resources/app.asar") + "' | head -c " + ICON.size + " > '" + icon + "'");
    verify_sha256(icon, ICON.sha256);
    chmod(icon, 0o644);

    // The runtime's data, before the carry step so that its modules and loader programs are rewritten too.
    for rel in RUNTIME_DATA {
        let to = join_path(out, rel);
        mkdir(to);
        copy_tree_contents(join_path(sdk, rel), to);
    }
    // glycin runs its loaders by absolute path: the installed ones.
    for conf in glob_list(join_path(out, "share/glycin-loaders/*/conf.d/*")) {
        write_file(conf, replace(replace(read_file(conf), "@LIB@", PREFIX + "/lib"), "@SHARE@", PREFIX + "/share"));
    }

    let desktop = join_path(out, "share/applications/antigravity.desktop");
    mkdir(dirname(desktop));
    write_file(desktop, DESKTOP_ENTRY);
    chmod(desktop, 0o644);

    carry_libraries(out, PREFIX, [join_path(sdk, "lib")]);

    let starter = join_path(out, "bin/antigravity");
    mkdir(dirname(starter));
    write_file(starter, STARTER);
    chmod(starter, 0o755);
}

fn verify(out) {
    for path in REQUIRED {
        if !exists(join_path(out, path)) { throw "the package lacks " + path; }
    }
    if exists(join_path(out, "lib/antigravity/chrome-sandbox")) { throw "the package holds the setuid helper chrome-sandbox"; }
    verify_sha256(join_path(out, "bin/antigravity"), STARTER_SHA256);
}
