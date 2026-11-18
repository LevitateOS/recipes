// The shared-library runtime that upstream desktop builds carry (Electron and
// Chromium programs, Zed): a pinned Fedora package set, never the build image's,
// so its libraries come with the glibc they were built against. LevitateOS
// self-contained packages design, "Programs somebody else linked", point 1.
//
// The pins are generated, not typed, into desktop-runtime.pins beside this
// file: from the Fedora release the LevitateOS locks use, the seeds below and
// every package whose shared library one of them links against (strong
// `libfoo.so.N()(64bit)` requires, resolved like `cargo xtask base lock`;
// programs, daemons and data that only a scriptlet or a program needs are not
// followed). Every SHA-256 and size is the repository primary metadata's, and
// every RPM was checked against it and the Fedora signing key when generated.
// Regenerate with `recipes/generators/desktop-runtime-pins.py`; the pins
// file's `version` line is this recipe's version. The set is pinned whatever
// the host's C library: it brings its own glibc.
//
// What the sdk holds, for a consuming recipe:
//   lib/                       every shared library of the set, with the loader
//                              ld-linux-x86-64.so.2 and glibc's NSS stubs
//                              (files and dns live inside libc.so.6 since 2.34)
//   lib/gconv/                 glibc's iconv modules            GCONV_PATH
//   lib/locale/C.utf8/         the one UTF-8 locale             LOCPATH, LANG=C.UTF-8
//   lib/gio/modules/           dconf's GSettings backend        GIO_MODULE_DIR
//   lib/gtk-3.0/3.0.0/         GTK 3 print backends             GTK_PATH=lib/gtk-3.0
//   lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
//                              no modules on purpose            GDK_PIXBUF_MODULE_FILE
//   lib/glycin-loaders/2+/     glycin's image-rs and SVG loader programs
//   share/glycin-loaders/2+/conf.d/
//                              their configuration, Exec=@LIB@/... GLYCIN_DATA_DIR=share
//   share/glib-2.0/schemas/    GTK 3's schemas, compiled here   GSETTINGS_SCHEMA_DIR
//   share/desktop-runtime/environment
//                              those variables, with @LIB@ and @SHARE@ for the
//                              package's own lib/ and share/ once installed
//   share/licenses/            each package's licence texts
//
// Fedora 45's gdk-pixbuf decodes every format through glycin, built into the
// library, which runs the loader programs its conf.d names; the only classic
// module left (XPM) is covered by glycin-image-rs, so loaders.cache lists no
// module. It still has to be named, or gdk-pixbuf reads the host's cache and
// loads the host's modules. The consuming recipe copies what it needs into its
// package's lib/ and share/, replaces @LIB@ and @SHARE@ with the installed
// paths, and its starter exports the environment file's variables.
const RECIPE_API = 1;
const NEEDS = #{
    outputs: #{ sdk: "directory" },
    network: ["dl.fedoraproject.org:443", "kojipkgs.fedoraproject.org:443"],
    memory_mib: 4096,
    storage_max_objects: 65536,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "library",
    category: "development",
    libc: ["glibc"],
    libc_carried: true,
    details: "The runtime upstream desktop builds carry: GTK 3, GLib, Pango, Cairo, HarfBuzz, fontconfig and FreeType, NSS and NSPR, X11 and xcb, xkbcommon, GBM and DRM, CUPS, ALSA, AT-SPI, D-Bus, libsecret and libnotify with the glibc they were built for, from a pinned Fedora package set. Its build is linked against glibc, as LevitateOS has. It adds the loader, iconv modules, one UTF-8 locale, compiled GSettings schemas and glycin's image loaders. Electron, Chromium and Zed packages name it under build_deps and carry what they load.",
    homepage: "https://fedoraproject.org",
    license: "LGPL-2.1-or-later AND LGPL-3.0-or-later AND GPL-2.0-or-later AND MPL-2.0 AND MIT AND BSD-3-Clause AND Apache-2.0",
    steps: #{
        download: "Downloads each pinned Fedora RPM and checks its SHA-256.",
        build: "Extracts the RPMs without scriptlets, keeps the shared libraries and the data they read at run time, compiles the GSettings schemas and checks that every library and loader finds all it links against inside lib.",
        install: "Publishes the sdk directory for recipes that name this under build_deps.",
    },
};

const PACKAGE = #{ name: "desktop-runtime", description: "Libraries and data carried by upstream desktop builds" };   // version: desktop-runtime.pins

// The seeds, the same on every system (a plain list). glycin-loaders is taken
// for some files only: the generator follows none of its requires.
const PACKAGES = [
    "glibc", "glibc-common", "libgcc", "libstdc++",
    "gtk3", "glib2", "pango", "cairo", "cairo-gobject", "harfbuzz",
    "fontconfig", "freetype", "gdk-pixbuf2", "librsvg2",
    "atk", "at-spi2-atk", "at-spi2-core", "dconf",
    "dbus-libs", "nss", "nspr", "nss-util", "nss-softokn", "nss-softokn-freebl",
    "libX11", "libX11-xcb", "libXcomposite", "libXdamage", "libXext",
    "libXfixes", "libXrandr", "libXtst", "libXScrnSaver", "libXi", "libXcursor", "libxcb",
    "libxkbcommon", "libxkbcommon-x11", "libxshmfence", "mesa-libgbm", "libdrm",
    "libwayland-client", "libwayland-cursor", "libwayland-egl", "libva", "cups-libs", "alsa-lib",
    "libsecret", "libnotify", "expat", "libuuid", "systemd-libs",
    "glycin-loaders",
];

// Lists the files under lib/ that are ELF objects and fails naming each
// DT_NEEDED or program interpreter not found as a file directly in lib/.
const CLOSURE_CHECK = `import os, subprocess, sys
sdk = sys.argv[1]
lib = os.path.join(sdk, "lib")
missing = {}
objects = 0
for root, dirs, files in os.walk(lib):
    dirs.sort()
    for name in sorted(files):
        path = os.path.join(root, name)
        if os.path.islink(path) or not os.path.isfile(path):
            continue
        with open(path, "rb") as f:
            if f.read(4) != b"\x7fELF":
                continue
        objects += 1
        out = subprocess.run(["readelf", "-dlW", path], capture_output=True, text=True, check=True).stdout
        wants = []
        for line in out.splitlines():
            if "(NEEDED)" in line:
                wants.append(line.split("[", 1)[1].rstrip("]"))
            elif "Requesting program interpreter:" in line:
                wants.append(os.path.basename(line.split(":", 1)[1].strip().rstrip("]")))
        for want in wants:
            if not os.path.isfile(os.path.join(lib, want)):
                missing.setdefault(want, []).append(os.path.relpath(path, sdk))
if objects == 0:
    sys.exit("no ELF files under " + lib)
if missing:
    for want in sorted(missing):
        print("not in lib/: " + want + " (needed by " + ", ".join(missing[want]) + ")")
    sys.exit(1)
print("closure: " + str(objects) + " ELF files under lib/, every one finds all it loads in lib/")
`;

const LOADERS_CACHE = `# GdkPixbuf Image Loader Modules file, written by the desktop-runtime recipe.
# Fedora's gdk-pixbuf decodes every format through glycin, built into the
# library; no loader module is needed, and naming this file through
# GDK_PIXBUF_MODULE_FILE keeps gdk-pixbuf from loading the host's modules.
`;

const ENVIRONMENT = `# What a starter exports for the carried runtime. @LIB@ and @SHARE@ are the
# package's own lib/ and share/ folders once installed.
LOCPATH=@LIB@/locale
GCONV_PATH=@LIB@/gconv
GDK_PIXBUF_MODULE_FILE=@LIB@/gdk-pixbuf-2.0/2.10.0/loaders.cache
GIO_MODULE_DIR=@LIB@/gio/modules
GTK_PATH=@LIB@/gtk-3.0
GSETTINGS_SCHEMA_DIR=@SHARE@/glib-2.0/schemas
GLYCIN_DATA_DIR=@SHARE@
`;

// Folders under /usr/lib64 that hold modules something in the set loads.
const MODULE_DIRS = ["gconv", "gio/modules", "gtk-3.0/3.0.0/printbackends"];
const GLYCIN_LOADERS = ["glycin-image-rs", "glycin-svg"];
// The record of what the sdk was made from, in the sdk.
const RECORD = "share/desktop-runtime/pins";
// What every sdk holds; verify checks them.
const REQUIRED = ["lib/ld-linux-x86-64.so.2", "lib/libc.so.6", "lib/libgtk-3.so.0", "lib/libnss3.so",
                  "lib/locale/C.utf8/LC_CTYPE", "share/glib-2.0/schemas/gschemas.compiled",
                  "lib/gdk-pixbuf-2.0/2.10.0/loaders.cache", RECORD];

// Recipe has downloaded the pins (src.packages, in pin order); this recipe
// unpacks them itself, because the sdk keeps only part of them, flat.
fn build(src, out) {
    let u = join_path(WORK, "unpacked");
    if exists(u) { rm(u); }
    mkdir(u);
    let done = 0;
    let record = "";
    for pin in src.packages {
        progress(done, src.packages.len(), "packages");
        target_extract_rpm(pin.path, u);
        record += pin.sha256 + "  " + basename(pin.path) + "\n";
        done += 1;
    }
    progress(done, src.packages.len(), "packages");

    let lib = join_path(out, "lib");
    let share = join_path(out, "share");
    mkdir(lib);
    // Every shared library and its soname links, flat; /lib64 holds libgcc_s.
    exec_checked("find", [join_path(u, "usr/lib64"), join_path(u, "lib64"), "-maxdepth", "1",
        "-name", "*.so*", "(", "-type", "f", "-o", "-type", "l", ")",
        "-exec", "cp", "-a", "-t", lib, "{}", "+"]);
    for dir in MODULE_DIRS {
        mkdir(join_path(lib, dirname(dir)));
        exec_checked("cp", ["-a", join_path(u, "usr/lib64/" + dir), join_path(lib, dir)]);
    }
    let gconv_cache = join_path(lib, "gconv/gconv-modules.cache");
    if exists(gconv_cache) { rm(gconv_cache); }

    mkdir(join_path(lib, "locale"));
    exec_checked("cp", ["-a", join_path(u, "usr/lib/locale/C.utf8"), join_path(lib, "locale/C.utf8")]);

    mkdir(join_path(lib, "gdk-pixbuf-2.0/2.10.0"));
    write_file(join_path(lib, "gdk-pixbuf-2.0/2.10.0/loaders.cache"), LOADERS_CACHE);

    let loaders = join_path(lib, "glycin-loaders/2+");
    let conf = join_path(share, "glycin-loaders/2+/conf.d");
    mkdir(loaders);
    mkdir(conf);
    for name in GLYCIN_LOADERS {
        exec_checked("cp", ["-a", join_path(u, "usr/libexec/glycin-loaders/2+/" + name), join_path(loaders, name)]);
        let file = join_path(conf, name + ".conf");
        copy_file(join_path(u, "usr/share/glycin-loaders/2+/conf.d/" + name + ".conf"), file);
        replace_in_file(file, "Exec=/usr/libexec/glycin-loaders/2+/", "Exec=@LIB@/glycin-loaders/2+/");
        if contains(read_file(file), "/usr/libexec") { throw name + ".conf names another loader folder"; }
    }

    // GTK 3's settings schemas; Fedora compiles them in a scriptlet, so this
    // does it with the image's glib-compile-schemas (the format is GLib's
    // stable GVDB, read the same by the carried GLib).
    let schemas = join_path(share, "glib-2.0/schemas");
    mkdir(schemas);
    exec_checked("find", [join_path(u, "usr/share/glib-2.0/schemas"), "-maxdepth", "1",
        "-name", "*.gschema.xml", "!", "-name", "org.gtk.exampleapp.gschema.xml",
        "-exec", "cp", "-t", schemas, "{}", "+"]);
    exec_checked("glib-compile-schemas", ["--strict", schemas]);

    mkdir(join_path(share, "licenses"));
    copy_tree_contents(join_path(u, "usr/share/licenses"), join_path(share, "licenses"));

    mkdir(join_path(share, "desktop-runtime"));
    write_file(join_path(share, "desktop-runtime/environment"), ENVIRONMENT);
    write_file(join_path(out, RECORD), record);
    rm(u);

    // The closure check runs a program, so it is part of build (verify only reads).
    let check = join_path(WORK, "closure-check.py");
    write_file(check, CLOSURE_CHECK);
    log(trim(exec_output("python3", ["-I", check, out])));
}

fn verify(out) {
    for name in REQUIRED {
        if !is_file(join_path(out, name)) { throw "the sdk lacks " + name; }
    }
}
