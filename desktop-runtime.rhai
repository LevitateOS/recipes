// The shared-library runtime that upstream desktop builds carry (Electron and
// Chromium programs, Zed): a pinned Fedora package set, never the build image's,
// so its libraries come with the glibc they were built against. LevitateOS
// self-contained packages design, "Programs somebody else linked", point 1.
//
// The pins below are generated, not typed: from the Fedora release the
// LevitateOS locks use, the seed packages and every package whose shared
// library one of them links against (strong `libfoo.so.N()(64bit)` requires,
// resolved like `cargo xtask base lock`; programs, daemons and data that only a
// scriptlet or a program needs are not followed). Every SHA-256 and size is the
// repository primary metadata's, and every RPM was checked against it and the
// Fedora signing key when generated. Regenerate with the generator kept beside
// the work that wrote this recipe (`lock.py --recipe desktop-runtime.rhai`);
// it rewrites only the block between the markers and the version.
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
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ sdk: "directory" },
    network: ["dl.fedoraproject.org:443"],
    network_max_bytes: 100663296,
    memory_mib: 4096,
    storage_max_objects: 65536,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "library",
    category: "development",
    details: "The runtime upstream desktop builds carry: GTK 3, GLib, Pango, Cairo, HarfBuzz, fontconfig and FreeType, NSS and NSPR, X11 and xcb, xkbcommon, GBM and DRM, CUPS, ALSA, AT-SPI, D-Bus, libsecret and libnotify with the glibc they were built for, from a pinned Fedora package set. It adds the loader, iconv modules, one UTF-8 locale, compiled GSettings schemas and glycin's image loaders. Electron, Chromium and Zed packages name it under build_deps and carry what they load.",
    homepage: "https://fedoraproject.org",
    license: "LGPL-2.1-or-later AND LGPL-3.0-or-later AND GPL-2.0-or-later AND MPL-2.0 AND MIT AND BSD-3-Clause AND Apache-2.0",
    steps: #{
        acquire: "Downloads each pinned Fedora RPM and checks its SHA-256.",
        build: "Extracts the RPMs without scriptlets, keeps the shared libraries and the data they read at run time, compiles the GSettings schemas and checks that every library and loader finds all it links against inside lib.",
        install: "Publishes the sdk directory for recipes that name this under build_deps.",
    },
};

// BEGIN GENERATED PINS
// Generated on 2026-11-13 from the Fedora 45 release and updates
// repositories' primary metadata: the seeds below and every package whose
// shared library one of them links against. Each RPM was checked against its
// repository SHA-256 and size and the Fedora signing key. Do not edit: rerun
// the generator (see the recipe header).
// Seeds: glibc glibc-common libgcc libstdc++ gtk3 glib2 pango cairo
//   cairo-gobject harfbuzz fontconfig freetype gdk-pixbuf2 librsvg2 atk
//   at-spi2-atk at-spi2-core dconf dbus-libs nss nspr nss-util nss-softokn
//   nss-softokn-freebl libX11 libX11-xcb libXcomposite libXdamage libXext
//   libXfixes libXrandr libXtst libXScrnSaver libXi libXcursor libxcb
//   libxkbcommon libxkbcommon-x11 libxshmfence mesa-libgbm libdrm
//   libwayland-client libwayland-cursor libwayland-egl libva cups-libs alsa-lib
//   libsecret libnotify expat libuuid systemd-libs.
// Taken for some files only (requires not followed): glycin-loaders.
const FEDORA_RELEASE = 45;
const PINNED_ON = "2026-11-13";
const PINNED_BYTES = 59198372;
// [name, NEVRA, URL, SHA256, bytes]
const PINS = [
    ["alsa-lib", "alsa-lib-1.2.16.1-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/alsa-lib-1.2.16.1-2.fc45.x86_64.rpm", "1563c75f83862048ce9690687f06f38c73d1a23148a8b331086bb8762fcc59e3", 580394],
    ["at-spi2-atk", "at-spi2-atk-2.62.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/a/at-spi2-atk-2.62.1-1.fc45.x86_64.rpm", "aa4e59a6e26bd0ed648b5f57e94fbbd9dea82173584cad79cf74ca6b0d989ad7", 92025],
    ["at-spi2-core", "at-spi2-core-2.62.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/a/at-spi2-core-2.62.1-1.fc45.x86_64.rpm", "3c55cf4902dc43c7e122a0875fae806f8409d74006e48337bdd20289be3439d9", 410264],
    ["atk", "atk-2.62.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/a/atk-2.62.1-1.fc45.x86_64.rpm", "b242900b57d565c1b68bbd666f62453ca4086e90e6120d5fe2193cc5e527dfd9", 85039],
    ["avahi-glib", "avahi-glib-0.9~rc2-9.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/avahi-glib-0.9~rc2-9.fc45.x86_64.rpm", "5c212a9572865bff5d6ddceba1e521d888c860f1dfb14a0f382813a675b13399", 15534],
    ["avahi-libs", "avahi-libs-0.9~rc2-9.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/a/avahi-libs-0.9~rc2-9.fc45.x86_64.rpm", "5c7c20754931df98db1f512567a46a2ba6de70b59d181e216e78bb4ce9ad76c8", 72798],
    ["bzip2-libs", "bzip2-libs-1.0.8-24.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/b/bzip2-libs-1.0.8-24.fc45.x86_64.rpm", "0c4338556b818394570eef963fd183ab2bde7babe277de146f355c7595d36d8a", 44548],
    ["cairo", "cairo-1.18.6-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/cairo-1.18.6-1.fc45.x86_64.rpm", "28f57588c221504308bf8027ba3f5ad36b185bf45bdfe7a1c599b1688e25c180", 775811],
    ["cairo-gobject", "cairo-gobject-1.18.6-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/cairo-gobject-1.18.6-1.fc45.x86_64.rpm", "844b0c08cb2cd801e1762a2ce04273f8e27e60ad1fda8e9199d8c97ab9e9f257", 17096],
    ["colord-libs", "colord-libs-1.4.8-5.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/colord-libs-1.4.8-5.fc45.x86_64.rpm", "e9f503998e265aea75327f1cfcbb15735866b3c6028837d62680ed9757b02043", 240186],
    ["cups-libs", "cups-libs-2.4.19-4.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/c/cups-libs-2.4.19-4.fc45.x86_64.rpm", "b5d6664200c9d3eea3082d357ed7295bbe17613d6d0479c5a29f76f2342bf6cc", 276932],
    ["dbus-libs", "dbus-libs-1.16.2-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/d/dbus-libs-1.16.2-6.fc45.x86_64.rpm", "ad55fbe37d0829382dd668cdec82799fbdcd07c2d7f168f1875439f084dda21d", 159296],
    ["dconf", "dconf-51.0-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/d/dconf-51.0-1.fc45.x86_64.rpm", "4a8689590be8ddfc8cf0a40e391b51e030a2cc360e44a1db739c5929144f0878", 118532],
    ["expat", "expat-2.9.0-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/e/expat-2.9.0-1.fc45.x86_64.rpm", "8e94a14880241d9eff840418124dcee0f862bd18356c85a5212fea4abed93773", 139468],
    ["fontconfig", "fontconfig-2.18.3-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/f/fontconfig-2.18.3-2.fc45.x86_64.rpm", "d1b8e44920f91a83dd323cfe4bae0dc981c5bd9242b7f4dbf51d068ac7666dc2", 391618],
    ["freetype", "freetype-2.14.3-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/f/freetype-2.14.3-3.fc45.x86_64.rpm", "9ee315c852f962e074293d8c4c44566cee1c7ed0b37aa9bafca75439104fc8f3", 454197],
    ["fribidi", "fribidi-1.0.18-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/f/fribidi-1.0.18-1.fc45.x86_64.rpm", "0b8fbaf8bc77652aaa78c928a4826daedfcf417b00bc754c8909da0eb533a04d", 107526],
    ["gdk-pixbuf2", "gdk-pixbuf2-2.44.8-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gdk-pixbuf2-2.44.8-3.fc45.x86_64.rpm", "26ad92539a2c8fa8ef7493a9bd999f180d969d9b426d357659ace233bb2493f2", 522844],
    ["glib2", "glib2-2.90.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/glib2-2.90.1-1.fc45.x86_64.rpm", "b60cf429338776312f0937ac512ecdb595b00c0642d22075c31f6c86410f46d0", 3365226],
    ["glibc", "glibc-2.44-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/glibc-2.44-2.fc45.x86_64.rpm", "8d6ec366a92f423acdc112c722b6ee9f81723fbcc6d60615401a09ec7fd0b007", 2581371],
    ["glibc-common", "glibc-common-2.44-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/glibc-common-2.44-2.fc45.x86_64.rpm", "df314456af481691c0212028dfd000a51a8ee9c51a3ef2fc4e67d136ec457e5c", 426498],
    ["glycin-libs", "glycin-libs-2.2.6-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/glycin-libs-2.2.6-1.fc45.x86_64.rpm", "053c3c73d185af3cc23c2c8070572925c304cb32955d5f09c2c0f0f39f887514", 1851765],
    ["glycin-loaders", "glycin-loaders-2.2.6-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/g/glycin-loaders-2.2.6-1.fc45.x86_64.rpm", "6f3028ba3123bc6266f44f36555d536db047a1a602634d2b87f3cff9ad8e3e94", 3561779],
    ["gmp", "gmp-6.3.0-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gmp-6.3.0-6.fc45.x86_64.rpm", "434884021f2e95f464950b6af962c79e7b3e9f3a89a17bc6a3e6307a555746f7", 329507],
    ["gnutls", "gnutls-3.8.13-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gnutls-3.8.13-3.fc45.x86_64.rpm", "69284865678b6478dd1d78afaad3549f4276800ce9b9e17c8d8bfe1035ddbd57", 1491440],
    ["graphite2", "graphite2-1.3.14-22.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/graphite2-1.3.14-22.fc45.x86_64.rpm", "08cd675bdea4dab2021ee29f8d5a25407b5a94cec78cfa98d889c1b43a32ae6f", 97074],
    ["gtk3", "gtk3-3.24.52-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/g/gtk3-3.24.52-6.fc45.x86_64.rpm", "2e2d4e236a95d858d093d3c2a57f367536ae5c00c37f826616221d9d4cd2c0c5", 6364926],
    ["harfbuzz", "harfbuzz-15.0.0-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/h/harfbuzz-15.0.0-2.fc45.x86_64.rpm", "df2bf709d332629f0b5f586678eb31e6652a997ba0eb11c7c64c113ecce869a7", 1406248],
    ["json-glib", "json-glib-1.10.8-11.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/j/json-glib-1.10.8-11.fc45.x86_64.rpm", "37bfec1cf8da0d04c1f391f45b941d177984d9dd6dece61b5f3524249ba560c7", 180354],
    ["keyutils-libs", "keyutils-libs-1.6.3-8.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/k/keyutils-libs-1.6.3-8.fc45.x86_64.rpm", "37c056b41062fa9b62355a03ac63cf923776625410f98b81a62ecef7f68b8037", 32230],
    ["krb5-libs", "krb5-libs-1.22.2-11.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/k/krb5-libs-1.22.2-11.fc45.x86_64.rpm", "f3516bdce9ab3a99c9d8eafe9ca347ccbf922283e2d975549c27f96965139fde", 822997],
    ["lcms2", "lcms2-2.16-8.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/lcms2-2.16-8.fc45.x86_64.rpm", "80d7003e93a85b7a3b14798cde18478254e1d17545d13b035dc9400d54b148fc", 194883],
    ["libX11", "libX11-1.8.13-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libX11-1.8.13-3.fc45.x86_64.rpm", "b810820916a0008209a061b22e7369f7ef1d12ac7fa1c729399b5683b0194076", 693616],
    ["libX11-xcb", "libX11-xcb-1.8.13-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libX11-xcb-1.8.13-3.fc45.x86_64.rpm", "1f2b1b7f8fa4103c60887965d642ffe40fd88d2cdccd7da0ce4ef237e916a5b8", 11099],
    ["libXScrnSaver", "libXScrnSaver-1.2.5-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXScrnSaver-1.2.5-2.fc45.x86_64.rpm", "d44beb03c706b5327a622527860cc30d2fb6657df178fff3bf9a76459e5907ee", 25708],
    ["libXau", "libXau-1.0.12-5.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXau-1.0.12-5.fc45.x86_64.rpm", "288187ea953c9f0f7443b3f310dea7af7643d6b7042055be519e459280c6a0ca", 34349],
    ["libXcomposite", "libXcomposite-0.4.6-8.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXcomposite-0.4.6-8.fc45.x86_64.rpm", "876cc77b626e373acb37ca5781c5003d23b2deb9fb3969564e53e3a2c8582349", 24578],
    ["libXcursor", "libXcursor-1.2.3-5.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXcursor-1.2.3-5.fc45.x86_64.rpm", "b830944dc798993a5ccfab2d2711f47db17d017dbd4c9aae17bd450c0a9049a5", 32978],
    ["libXdamage", "libXdamage-1.1.6-8.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXdamage-1.1.6-8.fc45.x86_64.rpm", "b51024119acaa682dd84b685e3f97c1880ae82c7877d47a9f6f4a096e5b0e043", 23700],
    ["libXext", "libXext-1.3.6-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXext-1.3.6-6.fc45.x86_64.rpm", "598de1986395e8b81dcd1f8606c4698e4a306152e606959ed62beaa8b9fca4a3", 41074],
    ["libXfixes", "libXfixes-6.0.1-8.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXfixes-6.0.1-8.fc45.x86_64.rpm", "31a29f5339a23927cacfb6c9b63659e377a54edf67741789cb5f4169ba24f11c", 19575],
    ["libXft", "libXft-2.3.8-11.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXft-2.3.8-11.fc45.x86_64.rpm", "c9cdd5f05a848c33d4b897211d6f3926cfb9e24b09903003a03aedc67e6f0162", 75468],
    ["libXi", "libXi-1.8.4-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libXi-1.8.4-1.fc45.x86_64.rpm", "01e5591ab5698f4b7fb8a8669b932b98dca3d30ddf88d9cb09960eb3755534f6", 43198],
    ["libXinerama", "libXinerama-1.1.5-11.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXinerama-1.1.5-11.fc45.x86_64.rpm", "4c62d41e83cbb6f28bbff72038399ac938015e58e7f662decd39986984a0461f", 14505],
    ["libXrandr", "libXrandr-1.5.4-8.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXrandr-1.5.4-8.fc45.x86_64.rpm", "2a3a82ede051dc57d495ef9a901fe8e2a7baf0ca492976c67bf735584b1e125b", 28373],
    ["libXrender", "libXrender-0.9.12-5.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXrender-0.9.12-5.fc45.x86_64.rpm", "d3bd1a05bb6bf9714e4a1b663e202d088ad33e2820c317fdb3d66bb462b9d13f", 28430],
    ["libXtst", "libXtst-1.2.5-5.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libXtst-1.2.5-5.fc45.x86_64.rpm", "084df3eb056b33ef669a4e0bc154be1da283b4b7afd396f5d8df35cb1e1e0bf2", 21424],
    ["libblkid", "libblkid-2.42.4-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libblkid-2.42.4-1.fc45.x86_64.rpm", "731b02839a01b9b92486cecf3d10e3bb2043a4790ff126103b639d16a648e28e", 137214],
    ["libbrotli", "libbrotli-1.2.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libbrotli-1.2.1-1.fc45.x86_64.rpm", "ab95c31b5c0d88605b0d03fe78663d8521524d078f12fba1d9ef260a4febdf75", 355571],
    ["libcloudproviders", "libcloudproviders-0.4.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libcloudproviders-0.4.1-1.fc45.x86_64.rpm", "1e3d8d78712fd2cb82e0ac42e68805ad5acae72acff8448de1b4a45d1414e138", 47832],
    ["libcom_err", "libcom_err-1.47.4-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libcom_err-1.47.4-2.fc45.x86_64.rpm", "95fde4bcc30c61dd5474687e2d27bb3deb4ad072dbc31581ef9f2b95df023532", 27245],
    ["libdatrie", "libdatrie-0.2.14-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdatrie-0.2.14-3.fc45.x86_64.rpm", "1270ae27a6ad48f91a4594f9254a206b76e9a27c5fc71d7d4ceb8eb4764699fa", 33656],
    ["libdav1d", "libdav1d-1.5.4-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdav1d-1.5.4-1.fc45.x86_64.rpm", "23af72944a38e2ca18ecd5356f7c2083f9c695f224fd45d3a868b0349e7cd3f8", 680542],
    ["libdrm", "libdrm-2.4.134-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libdrm-2.4.134-2.fc45.x86_64.rpm", "b6b6575c734d899dd25c2c6af93ce14195f2143467973f4544865371b6fc74f9", 170712],
    ["libepoxy", "libepoxy-1.5.10-13.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libepoxy-1.5.10-13.fc45.x86_64.rpm", "a897d3d251d0489da6ec30fb187903040ad91b9074547733bed7307b6b222a84", 235391],
    ["libevent", "libevent-2.1.13-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libevent-2.1.13-1.fc45.x86_64.rpm", "c39698953327e53a5de2f703d4c6d8063e3580cc74dee3e14125319bfc204c6b", 296244],
    ["libffi", "libffi-3.5.2-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libffi-3.5.2-3.fc45.x86_64.rpm", "e8c4cf4b1747f677b98e9f195c14c6abc8d70f1154d0d03f4d5cdeb110a77698", 42861],
    ["libgcc", "libgcc-16.2.1-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libgcc-16.2.1-3.fc45.x86_64.rpm", "57fc410c4b5939d5f85d42f90c5f0ab3514dbb74c965de1de7e3ac0d1374d606", 142903],
    ["libglvnd", "libglvnd-1.7.0-10.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libglvnd-1.7.0-10.fc45.x86_64.rpm", "8d055193c8a2da0d04a7ae2d858333bfe46fd573f7483cfab732c75ed1cac256", 116711],
    ["libglvnd-glx", "libglvnd-glx-1.7.0-10.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libglvnd-glx-1.7.0-10.fc45.x86_64.rpm", "352aa61d8b1f88cc4a61f2cfec06e4454c3bd7129b112785eeef6da019cf30c9", 132848],
    ["libgusb", "libgusb-0.4.9-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libgusb-0.4.9-6.fc45.x86_64.rpm", "347eb22bc7dcc796d3adacd6a2a9e5e1331581f8fd87300c45bcb5efad34ea29", 66257],
    ["libicu", "libicu-78.3-9.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libicu-78.3-9.fc45.x86_64.rpm", "0d9a97887c37d0a635679f38731f4973d034c188f0d5aa13c0b88397ce1603dd", 11664975],
    ["libidn2", "libidn2-2.3.8-4.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libidn2-2.3.8-4.fc45.x86_64.rpm", "292b62009f71cc0bebfd8f1087397d507a4932ae3d081d8a1fb1b79f34705569", 179393],
    ["libmount", "libmount-2.42.4-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libmount-2.42.4-1.fc45.x86_64.rpm", "caa1091d72eb831047655ab27b834d194e2690993af619444d0139b11e51a200", 183759],
    ["libnghttp2", "libnghttp2-1.69.0-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libnghttp2-1.69.0-6.fc45.x86_64.rpm", "4ad405fa966df0d1ba6602d4a7d205b9bbf0e54d369a9b96ce26d45c0a91e168", 79006],
    ["libnotify", "libnotify-0.8.9-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libnotify-0.8.9-1.fc45.x86_64.rpm", "e0863d445dedd48d06a2a89cec44cb0ed67b2c871083c157a7a0df1ac432e0a1", 58079],
    ["libpciaccess", "libpciaccess-0.16-18.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libpciaccess-0.16-18.fc45.x86_64.rpm", "1992e2f0336e4c3b9b7d7f442b58ea527fc9d65d879b18790d58206fe5e2c49b", 27814],
    ["libpng", "libpng-1.6.59-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libpng-1.6.59-1.fc45.x86_64.rpm", "81e1d7cb71d001c9e96acb50687622bb801a86b4d0618896618dfc291d97a4d6", 132286],
    ["libpsl", "libpsl-0.23.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libpsl-0.23.1-1.fc45.x86_64.rpm", "82762074632ee1e59a01ebd14ca1ab9afbebeae8167b50350eebcccebbaffabc", 69193],
    ["librsvg2", "librsvg2-2.63.2-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/librsvg2-2.63.2-2.fc45.x86_64.rpm", "e8d1f3e73a17514fef606dcd40d9e0a13314cb44666a0fae076ffe779db1af78", 1963603],
    ["libseccomp", "libseccomp-2.6.1-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libseccomp-2.6.1-3.fc45.x86_64.rpm", "a10e3b932cb5eb364ec5123af8cec38ae05a8b5bde9c620f1f631c88dcc71c27", 77460],
    ["libsecret", "libsecret-0.21.8.2-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libsecret-0.21.8.2-2.fc45.x86_64.rpm", "dac8f70040c76e14766db4206fb1636122de3d05c6f883b720f07d3c63353356", 184950],
    ["libselinux", "libselinux-3.11-5.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libselinux-3.11-5.fc45.x86_64.rpm", "6420804a2eea7da60854ae14098c1b5c76bb44cda550abe2cf7962208097f23b", 106608],
    ["libsoup3", "libsoup3-3.8.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libsoup3-3.8.1-1.fc45.x86_64.rpm", "7784d52cb197bae7a2e99e290d25c81ebc812eb454ffa0ef7de12b5de42fbdf6", 433412],
    ["libstdc++", "libstdc++-16.2.1-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/l/libstdc++-16.2.1-3.fc45.x86_64.rpm", "c4256a01fab863cecadd3aaf24b015902ac4f3b841924550d788017e28aa2d9a", 1052840],
    ["libstemmer", "libstemmer-3.1.1-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libstemmer-3.1.1-2.fc45.x86_64.rpm", "f779c6fe472fc19505c402353fd04422e75b4ff88431aad0811f88d519b08947", 157548],
    ["libtasn1", "libtasn1-4.21.0-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libtasn1-4.21.0-2.fc45.x86_64.rpm", "d61fcf0d0690a5ab8de48578e5e5d09356c8cf7ae0d729704f680b090ecfdc78", 77769],
    ["libthai", "libthai-0.1.30-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libthai-0.1.30-3.fc45.x86_64.rpm", "1b06eb1bbbe9aa597d475ed48652bfa8a105db7d96e5e68dfb5ffeb395f2a391", 221250],
    ["libtinysparql", "libtinysparql-3.12.0-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libtinysparql-3.12.0-2.fc45.x86_64.rpm", "a705983abde9d287aa05bcfa77939650f3458e1673c64aeee47fccff433fb39b", 370059],
    ["libunistring", "libunistring-1.1-12.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libunistring-1.1-12.fc45.x86_64.rpm", "6b59f73f3bb61694af9009c8925324b82dba7f957937eeadf6ed4ea58fc376a9", 558879],
    ["libusb1", "libusb1-1.0.30-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libusb1-1.0.30-2.fc45.x86_64.rpm", "1921b9c3f45047544675199f5608e7297cb7b25b53316fced850d35a56a3a9bc", 85814],
    ["libuuid", "libuuid-2.42.4-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libuuid-2.42.4-1.fc45.x86_64.rpm", "402222d9876b2dbebeffc85c995ce06669c70d1a12082cd67003e17ace1ddf5a", 28317],
    ["libva", "libva-2.24.1-2.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libva-2.24.1-2.fc45.x86_64.rpm", "55ef29cebe2feaf237f5a1606d4d2a6ce83347e5115c60957c6ee4a21a2cc2c4", 125771],
    ["libverto", "libverto-0.3.2-13.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libverto-0.3.2-13.fc45.x86_64.rpm", "ca11dc4d365f61ec2cc5a463b629311c0f58f97903497c9f760e0b410f96fbc8", 21476],
    ["libwayland-client", "libwayland-client-1.26.0-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libwayland-client-1.26.0-3.fc45.x86_64.rpm", "aafd3738215ce5bbc66b1f9866cb790a494044e5aeb6c165b5d7e0a4e080e89e", 36310],
    ["libwayland-cursor", "libwayland-cursor-1.26.0-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libwayland-cursor-1.26.0-3.fc45.x86_64.rpm", "375ed25fbbda9d7d3aac7e639c76907fbc5fa49e9823caf68521e78bb1849ac6", 19798],
    ["libwayland-egl", "libwayland-egl-1.26.0-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libwayland-egl-1.26.0-3.fc45.x86_64.rpm", "6fd3cad2afb6347a5e8e4f746a42d74fdf17606abf022c6d572b3b51031c4222", 12769],
    ["libxcb", "libxcb-1.17.0-8.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxcb-1.17.0-8.fc45.x86_64.rpm", "200d8970f468df1c3867e4273343d83958c0e8592f663e777bdc572e9257f725", 243606],
    ["libxkbcommon", "libxkbcommon-1.13.1-4.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxkbcommon-1.13.1-4.fc45.x86_64.rpm", "c86a7e7df72ba81657ff838ec33af1ea2b52ad49f9ad1511407108685e9435f9", 189226],
    ["libxkbcommon-x11", "libxkbcommon-x11-1.13.1-4.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxkbcommon-x11-1.13.1-4.fc45.x86_64.rpm", "b18dce51b548ad9736b246aef3fddc66071731771adcdc569f7317d736c78ea0", 23322],
    ["libxml2", "libxml2-2.15.4-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxml2-2.15.4-1.fc45.x86_64.rpm", "7c21dbf8e1dde792c35687b9a340b398b4640b1e2633a87cf6026975fd659456", 693013],
    ["libxshmfence", "libxshmfence-1.3.2-9.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libxshmfence-1.3.2-9.fc45.x86_64.rpm", "31c2eb73ba93fe602eb9a90a8ff8f1278419c7f26d7d98b7d38a512f8b93f0a6", 13401],
    ["libzstd", "libzstd-1.5.7-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/libzstd-1.5.7-6.fc45.x86_64.rpm", "d637ecf99fffca9746ffe29a8b5f9db56a16a86dff6d637365e072f460f364a7", 372586],
    ["lzo", "lzo-2.10-17.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/l/lzo-2.10-17.fc45.x86_64.rpm", "fb84f83c9896ce93bd77a0796be99a9254e63fadf13001b59693b3128407ea2f", 72246],
    ["mesa-libgbm", "mesa-libgbm-26.2.6-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/m/mesa-libgbm-26.2.6-1.fc45.x86_64.rpm", "cd717527e5ffb482994477565501e8a4cfc366eb5a12642ba134225a3f229a4a", 21418],
    ["ncurses-libs", "ncurses-libs-6.6-3.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/ncurses-libs-6.6-3.fc45.x86_64.rpm", "bc8d79cdd67d96248c93bd1a3eec1e499ec2d1f96cb6922a709df6df06d5cd38", 351947],
    ["nettle", "nettle-4.0-5.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/nettle-4.0-5.fc45.x86_64.rpm", "c6e93f21d9b7e16078f2f057f3fd1ebcd913d02a030480550a396b2a774c46b4", 439963],
    ["nspr", "nspr-4.39.0-10.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nspr-4.39.0-10.fc45.x86_64.rpm", "c8b47fb596dea3ed875b57eb693a8a36055ef7e9d3d44ab3f3174b6f281f146f", 148390],
    ["nss", "nss-3.133.0-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nss-3.133.0-1.fc45.x86_64.rpm", "f0ccd09fee50f4986feb2395d9c0cf17965e361c89f5861f8125ef308f3831b8", 786585],
    ["nss-softokn", "nss-softokn-3.133.0-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nss-softokn-3.133.0-1.fc45.x86_64.rpm", "55fc3748d385412983e85339d7cdae3fec0ca5af5c2ea7dfd5e3e1524a4320b0", 461888],
    ["nss-softokn-freebl", "nss-softokn-freebl-3.133.0-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nss-softokn-freebl-3.133.0-1.fc45.x86_64.rpm", "f90a333ad288d1fa88a67631fd42bbedf39b2a751228e9a213e48bb288176d73", 400281],
    ["nss-util", "nss-util-3.133.0-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/n/nss-util-3.133.0-1.fc45.x86_64.rpm", "a4bb05c1c7c7d83dd29df260ade877e45f431f1921798d3da8201d0dd824e82a", 93534],
    ["openssl-libs", "openssl-libs-4.0.3-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/o/openssl-libs-4.0.3-1.fc45.x86_64.rpm", "4f8ece27fdbdbf94ced234b088e1f9eb6f1e60cf6732a898c2d8ad156dbc86ae", 2456529],
    ["p11-kit", "p11-kit-0.26.5-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/p11-kit-0.26.5-1.fc45.x86_64.rpm", "422c985080ab36378c80394d0293133b4608b1195a5f9e5737ab76c30ef65409", 573464],
    ["pango", "pango-1.58.2-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pango-1.58.2-1.fc45.x86_64.rpm", "98dffb38486d324625ac221cc6eac1343c37829645d58d3a204dc58934806b16", 377482],
    ["pcre2", "pcre2-10.49-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/p/pcre2-10.49-1.fc45.x86_64.rpm", "178b22ce6b2215257854742b8de5c37d78f50aa4db364d7088a3fc6dd3fbdc7d", 286761],
    ["pixman", "pixman-0.46.2-4.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/p/pixman-0.46.2-4.fc45.x86_64.rpm", "1901e43f205f236d487166d0ad27f9c2250c0f940399665606dfbe41e9ffc827", 303814],
    ["readline", "readline-8.3-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/r/readline-8.3-6.fc45.x86_64.rpm", "f47c0a94e9f775fa5711bada265880af7dc7d3de6404b817c94bc4bf9a8522ea", 234270],
    ["sqlite-libs", "sqlite-libs-3.53.4-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/s/sqlite-libs-3.53.4-1.fc45.x86_64.rpm", "55d417e2be9eb4e20d2adb8fb55fdb3e71bb1fc17321f98347216f4a29070bc8", 831591],
    ["systemd-libs", "systemd-libs-262.1-1.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/updates/45/Everything/x86_64/Packages/s/systemd-libs-262.1-1.fc45.x86_64.rpm", "c1af6d9a736f0337e14e219cff0f8fb9ed8a282bcf658c62efe6e8061f8692ab", 986849],
    ["zlib-ng-compat", "zlib-ng-compat-2.3.3-6.fc45.x86_64", "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/z/zlib-ng-compat-2.3.3-6.fc45.x86_64.rpm", "1bab05fecdd71fc4a946852d83405f238c89cccb63987c0941c7f2f0184a99e2", 92600],
];
// END GENERATED PINS

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

if PINNED_BYTES > NEEDS.network_max_bytes {
    throw "the pinned RPMs (" + PINNED_BYTES + " bytes) exceed NEEDS.network_max_bytes";
}

let ctx = #{
    name: "desktop-runtime",
    version: "45.20261113",
    description: "Libraries and data carried by upstream desktop builds",
    downloads: join_path(RUNTIME.paths.build, "downloads"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sdk: join_path(RUNTIME.paths.build, "sdk"),
    closure_check: join_path(RUNTIME.paths.temp, "closure-check.py"),
    record: "share/desktop-runtime/pins",
    // Folders under /usr/lib64 that hold modules something in the set loads.
    module_dirs: ["gconv", "gio/modules", "gtk-3.0/3.0.0/printbackends"],
    glycin_loaders: ["glycin-image-rs", "glycin-svg"],
};
ctx.pins = PINS;
ctx.loaders_cache = LOADERS_CACHE;
ctx.environment = ENVIRONMENT;
// The record of what the sdk was made from: one line per pinned RPM.
ctx.pins_record = "";
for pin in PINS {
    ctx.pins_record += pin[3] + "  " + pin[1] + "\n";
}
// Setup stages the checker in owned temporary storage.
write_file(ctx.closure_check, CLOSURE_CHECK);

fn rpm_path(ctx, pin) {
    join_path(ctx.downloads, pin[1] + ".rpm")
}

fn check_sdk(ctx, root) {
    let record = join_path(root, ctx.record);
    if !is_file(record) {
        return needs_work(ctx, "assemble the desktop runtime");
    }
    if read_file(record) != ctx.pins_record {
        return needs_work(ctx, "the pinned package set changed");
    }
    for name in ["lib/ld-linux-x86-64.so.2", "lib/libc.so.6", "lib/libgtk-3.so.0", "lib/libnss3.so",
                 "lib/locale/C.utf8/LC_CTYPE", "share/glib-2.0/schemas/gschemas.compiled",
                 "lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"] {
        if !is_file(join_path(root, name)) {
            return needs_work(ctx, "missing " + name);
        }
    }
    log(trim(exec_output("python3", ["-I", ctx.closure_check, root])));
    ready(ctx)
}

fn is_acquired(ctx) {
    for pin in ctx.pins {
        let path = rpm_path(ctx, pin);
        if !is_file(path) { return needs_work(ctx, "download " + pin[1]); }
        verify_sha256(path, pin[3]);
    }
    ready(ctx)
}

fn acquire(ctx) {
    mkdir(ctx.downloads);
    let done = 0;
    for pin in ctx.pins {
        progress(done, ctx.pins.len(), "packages");
        download(pin[2], rpm_path(ctx, pin), pin[3], true);
        done += 1;
    }
    progress(done, ctx.pins.len(), "packages");
    ctx
}

fn is_built(ctx) {
    check_sdk(ctx, ctx.sdk)
}

fn build(ctx) {
    for dir in [ctx.unpacked, ctx.sdk] {
        if exists(dir) { rm(dir); }
    }
    mkdir(ctx.unpacked);
    let done = 0;
    for pin in ctx.pins {
        progress(done, ctx.pins.len(), "packages");
        let archive = rpm_path(ctx, pin);
        verify_sha256(archive, pin[3]);
        target_extract_rpm(archive, ctx.unpacked);
        done += 1;
    }
    progress(done, ctx.pins.len(), "packages");

    let u = ctx.unpacked;
    let lib = join_path(ctx.sdk, "lib");
    let share = join_path(ctx.sdk, "share");
    mkdir(lib);
    // Every shared library and its soname links, flat; /lib64 holds libgcc_s.
    exec_checked("find", [join_path(u, "usr/lib64"), join_path(u, "lib64"), "-maxdepth", "1",
        "-name", "*.so*", "(", "-type", "f", "-o", "-type", "l", ")",
        "-exec", "cp", "-a", "-t", lib, "{}", "+"]);
    for dir in ctx.module_dirs {
        mkdir(join_path(lib, dirname(dir)));
        exec_checked("cp", ["-a", join_path(u, "usr/lib64/" + dir), join_path(lib, dir)]);
    }
    let gconv_cache = join_path(lib, "gconv/gconv-modules.cache");
    if exists(gconv_cache) { rm(gconv_cache); }

    mkdir(join_path(lib, "locale"));
    exec_checked("cp", ["-a", join_path(u, "usr/lib/locale/C.utf8"), join_path(lib, "locale/C.utf8")]);

    mkdir(join_path(lib, "gdk-pixbuf-2.0/2.10.0"));
    write_file(join_path(lib, "gdk-pixbuf-2.0/2.10.0/loaders.cache"), ctx.loaders_cache);

    let loaders = join_path(lib, "glycin-loaders/2+");
    let conf = join_path(share, "glycin-loaders/2+/conf.d");
    mkdir(loaders);
    mkdir(conf);
    for name in ctx.glycin_loaders {
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
    write_file(join_path(share, "desktop-runtime/environment"), ctx.environment);
    write_file(join_path(ctx.sdk, ctx.record), ctx.pins_record);
    rm(u);
    ctx
}

fn is_installed(ctx) {
    if !is_dir(ctx.sdk) {
        return needs_work(ctx, "publish the desktop runtime");
    }
    ctx.outputs.sdk = ctx.sdk;
    check_sdk(ctx, ctx.sdk)
}

fn install(ctx) {
    // The checked sdk is already in owned storage; publish it without a second copy.
    ctx.outputs.sdk = ctx.sdk;
    ctx
}

fn remove(ctx) {
    if exists(ctx.sdk) { rm(ctx.sdk); }
    ctx.outputs = #{};
    ctx
}
