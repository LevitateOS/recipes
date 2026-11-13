// Antigravity (Google's agent-first desktop application, "Antigravity App" 2.31.2), x86_64 Linux tarball: an Electron
// 44.9.1 program (glibc, RPATH $ORIGIN) that carries its own Chromium libraries (libffmpeg.so, libvulkan.so.1,
// SwiftShader) but links GTK, NSS, X11, GLib and the C library from the host. This recipe is the first trial of
// "Programs somebody else linked" (docs/recipe-self-contained-packages.md): it builds on the desktop-runtime recipe,
// and carry_libraries rewrites the program and its bundled libraries to the runtime's loader and libraries, so it
// runs on LevitateOS without the host providing any of them.
// Archive SHA-256: computed from our own download. Google publishes no checksum for this tarball, so the pin below is
// trust on first use of the bytes the pinned URL served on 2026-11-13 (size 189909829).
// Every file of the tree is pinned separately below, computed from that archive; nothing is compiled. The pins are of
// the upstream bytes, checked at unpack time; files the carry step rewrites (elf: true) change after install and are
// then only checked for presence.
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
const RECIPE_API = 2;
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
        acquire: "Downloads the pinned Antigravity tarball from Google's storage. Google publishes no checksum for it; the digest is of the bytes first downloaded.",
        build: "Unpacks the tarball and checks every file against its own digest; nothing is compiled.",
        install: "Puts the application under lib/antigravity without its setuid helper, adds the desktop runtime's data, rewrites the program and its libraries to the carried C library and libraries, and adds a starter, a menu entry and an icon.",
    },
    keeps: [],
};

let build_deps = ["desktop-runtime"];

let ctx = #{
    name: "antigravity",
    version: "2.31.2",
    description: "Antigravity agent-first desktop application",
    package_root: join_path(RUNTIME.paths.output, "package"),
    downloads: join_path(RUNTIME.paths.build, "downloads"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    archive_name: "Antigravity.tar.gz",
    url: "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.31.2-6470801290035200/linux-x64/Antigravity.tar.gz",
    sha256: "20be3cab21a2aeba9dca3eee9a212f0308cf34b22fb4a8a98b0dedf18ee63413",
    top: "Antigravity-x64",
    // app.asar is an uncompressed archive: 8 bytes, the header pickle (294840 bytes), then the files;
    // icon.png sits at 8 + 294840 + 4929891, and the asar header records the digest below.
    icon_offset: 5224739,
    icon_size: 48633,
    icon_sha256: "b27f0e4a6f14f491ba31bb24533a1f43c677362b12a0744a53fdd09d7c785317",
    // The runtime's data the program needs, relative to the runtime's sdk (the same place in the package).
    runtime_data: ["lib/gconv", "lib/locale", "lib/gio", "lib/gtk-3.0", "lib/gdk-pixbuf-2.0", "lib/glycin-loaders",
                   "share/glycin-loaders", "share/glib-2.0/schemas"],
    files: [
        #{ path: "LICENSE.electron.txt", mode: 0o644, sha256: "5154e165bd6c2cc0cfbcd8916498c7abab0497923bafcd5cb07673fe8480087d" },
        #{ path: "LICENSES.chromium.html", mode: 0o644, sha256: "3375e2a9bd7bc631738fde10be6548a76efe8cf5e4b8826b8140ba8b0c4d6353" },
        #{ path: "antigravity", mode: 0o755, sha256: "3ba9114b7fbaafaf548f72c5d1bc86b7dc81098a85361784359c2c1199625bfc", elf: true },
        #{ path: "chrome_100_percent.pak", mode: 0o644, sha256: "891176da5eee33b54352fdb1407a8e09a2bd48c7eb2077311e75787de33a095e" },
        #{ path: "chrome_200_percent.pak", mode: 0o644, sha256: "b3ce9953a50959e9c1a018d6512742f48cee0dbf53644ea952909418bd7c2b3e" },
        #{ path: "chrome_crashpad_handler", mode: 0o755, sha256: "a4b5bdd06ab497169b49c4996e6e2604faa0dce574af1ba1119a065c5bcf836f", elf: true },
        #{ path: "icudtl.dat", mode: 0o644, sha256: "da53f0b69843aaa43315f0f210a67e4a874b0be338f3dae08ff57b8afe76ab0d" },
        #{ path: "libffmpeg.so", mode: 0o755, sha256: "7524ec42a70d58982841d5cf79d35924fbf7441dff6756ff4cf6797a545bcfed", elf: true },
        #{ path: "libvk_swiftshader.so", mode: 0o755, sha256: "9002fb11a11c5754331624e6a80e1ef719dbd210ed60c24f43b3cf82f59ecf23", elf: true },
        #{ path: "libvulkan.so.1", mode: 0o755, sha256: "fca03687772755d18885878031650d602283418b1e41d962571d3e398ab3f6b9", elf: true },
        #{ path: "locales/af.pak", mode: 0o644, sha256: "9abd48c6c1f34e14dcad66131a9cc8624b4e850ebf692b05a66fb18d5c537588" },
        #{ path: "locales/am.pak", mode: 0o644, sha256: "28545e9a72220ddca39f7d7b36eacb3b661a3cc40d212b7e56be21d90f5ee71b" },
        #{ path: "locales/ar.pak", mode: 0o644, sha256: "267687bf1ed07628b03f02d095b253141a4cbc6b80f0bfec6007ca0556260e5f" },
        #{ path: "locales/bg.pak", mode: 0o644, sha256: "96741df7a895b1d4894db0fd5e5db4f761849eb0e5ebadf6f3f27daf16723ebe" },
        #{ path: "locales/bn.pak", mode: 0o644, sha256: "eaa31ac7166ef4c5c61bf6e4a9b0a0b4cb1825e1b57e5a45f76faa65dc0d113f" },
        #{ path: "locales/ca.pak", mode: 0o644, sha256: "3f86be184e95323c14604836b8eaf8935fc24f9cd2308cb207be26c318d8f287" },
        #{ path: "locales/cs.pak", mode: 0o644, sha256: "cffb35f66f25ef7dac62b05213dfa787ecddf2533518c02276d8fbe828f541e8" },
        #{ path: "locales/da.pak", mode: 0o644, sha256: "14cfcdfecb80d8575d273d8ec03317ae51c3e2c976c862ab774f9af9c7c4557b" },
        #{ path: "locales/de.pak", mode: 0o644, sha256: "7d4874ca52ac298dbc4c01d91c1c6a549008dbefc2d0c8f52154d872dce4979f" },
        #{ path: "locales/el.pak", mode: 0o644, sha256: "114158bd5f674169564173a12612922259a8acc50076c228c2214659924ee018" },
        #{ path: "locales/en-GB.pak", mode: 0o644, sha256: "550775b16b4716e610232e6b06e35a95c4c6ce2dedbd2a26747f8dc8f08d8aeb" },
        #{ path: "locales/en-US.pak", mode: 0o644, sha256: "e37db76f0a15a4b2a3cbd365bd4f06b0d8dc91fb9a83c03b7cd38503c23c044b" },
        #{ path: "locales/es-419.pak", mode: 0o644, sha256: "aaacff94a6407a7d487a455889a544f6107107cccb82393a27e9bf593d1b943d" },
        #{ path: "locales/es.pak", mode: 0o644, sha256: "b3256546e28dffff82c3d00abae9ad2141cf7bb940e5e39620f6ae30b488dcea" },
        #{ path: "locales/et.pak", mode: 0o644, sha256: "41f78768a3ef702356653ab005522a20407e0dbbe7b0ea323683072520f11191" },
        #{ path: "locales/fa.pak", mode: 0o644, sha256: "365520460dd4b662f8dfa14969eb066b7c1c98ae255ecfd705c1692a1ed784f1" },
        #{ path: "locales/fi.pak", mode: 0o644, sha256: "fb7379246632c90a58a8f7155e390ca583f9d73b6c6ae26baf9bf4878be184df" },
        #{ path: "locales/fil.pak", mode: 0o644, sha256: "7c6c76af71a7d60733a01014c19d9544409d5facd6001fb9058fc8ae8062cf54" },
        #{ path: "locales/fr.pak", mode: 0o644, sha256: "95b11fc7368d9f4367534e89456cceda009468abe2423821a11fe1dd1a7b4604" },
        #{ path: "locales/gu.pak", mode: 0o644, sha256: "309dcf4484d9479eeb68dcc7d745f17dfa0ffc4e6b112751de704ce62e8aecbe" },
        #{ path: "locales/he.pak", mode: 0o644, sha256: "5764ba9a2261b2ded07f3c3afa8f003594b29f58c73b322f1d89479907a97ca2" },
        #{ path: "locales/hi.pak", mode: 0o644, sha256: "b4d36beed004905461637b0c60eacc6d8eca49ba47ba262ed04d68c88b826bf4" },
        #{ path: "locales/hr.pak", mode: 0o644, sha256: "6937159b11ac75bee2c8046a5150596acee10a7c10c75a2469a752175f9e9e99" },
        #{ path: "locales/hu.pak", mode: 0o644, sha256: "d6add186bc8bd342ef5d35cba5261c8c847ecb529697b7c003016435997c9fdc" },
        #{ path: "locales/id.pak", mode: 0o644, sha256: "06c550187e7dd49cf0210ac9bcf4401c10e96ed777ccc8fd07e914a9337de9b7" },
        #{ path: "locales/it.pak", mode: 0o644, sha256: "b02a5de9de434266991a9e37a6bcced44b65ae3c164e4920a736eb350f745ecb" },
        #{ path: "locales/ja.pak", mode: 0o644, sha256: "4b51a3023136f05ae2c0b8e041e262eed3f6d5fa87c782892cba36e10d904b3c" },
        #{ path: "locales/kn.pak", mode: 0o644, sha256: "875859c2b88312ff3644c6cadd65dd8b5057e336a0a2bea512fbffa7c85695a7" },
        #{ path: "locales/ko.pak", mode: 0o644, sha256: "8c98d075840cb4800016c6df141183b3ec69cfe20df38ea759f2274259a86666" },
        #{ path: "locales/lt.pak", mode: 0o644, sha256: "b7e01915d9f1131743aaa7b1c262c7ef685c10d8621f2437e46ebefe980a6efc" },
        #{ path: "locales/lv.pak", mode: 0o644, sha256: "22fc0a3e04e7772c7df2f4c74e928ceb4046edc8c1688dbc4f04676f00944952" },
        #{ path: "locales/ml.pak", mode: 0o644, sha256: "fffb1b403dd4a62f0116fb39a961a73dd0766049bdc23118c90f4360971e225b" },
        #{ path: "locales/mr.pak", mode: 0o644, sha256: "0f5879b812517af23c9655347b08852c8e8f5c399b288466a8ec717d397e94d6" },
        #{ path: "locales/ms.pak", mode: 0o644, sha256: "ce1f9c8cfe5b2705b281d3480e0df992ab36f3518956100564eb9edae5d03dbb" },
        #{ path: "locales/nb.pak", mode: 0o644, sha256: "36c2e3f5d4e920e8e0411878df2cbd4a92bd9e553e9e427b3aae355bfb9fc955" },
        #{ path: "locales/nl.pak", mode: 0o644, sha256: "5cceeeff48b3aad830116126f8f15b3bfddf682bbdf986b3a266e0e72ff463d1" },
        #{ path: "locales/pl.pak", mode: 0o644, sha256: "35e0d1578baa9c9441c83383aade35d69c03bc2307783c639c01b156015a11a8" },
        #{ path: "locales/pt-BR.pak", mode: 0o644, sha256: "907226d904de6a571a80289ef6a8072bad867b1f63ec37fcd735c30763af970d" },
        #{ path: "locales/pt-PT.pak", mode: 0o644, sha256: "540b4f6c0d58d8f0315a8e4fbee49e41b6fbfe2b9c2065b8f28b069619c132ba" },
        #{ path: "locales/ro.pak", mode: 0o644, sha256: "b7c3b4af988ec26f8f3a3fa789cdbe46712a14497e47cba6266c9f0e808e57f7" },
        #{ path: "locales/ru.pak", mode: 0o644, sha256: "b011f8c753fa33f9aa91732590ca13a791824a7fd94a8f35c41330fe346de11a" },
        #{ path: "locales/sk.pak", mode: 0o644, sha256: "8c743c91af3dd53fd5c36e88061a62dddb2b91687ec779e7958774f436486dac" },
        #{ path: "locales/sl.pak", mode: 0o644, sha256: "a692040613f2fe76800c33d000a9a62277b1fc98bd056ce7f4f5ee06f6b0ec9d" },
        #{ path: "locales/sr.pak", mode: 0o644, sha256: "92bac4af059cea0f2f72293fde0cc665b8554c00653b26611cfcc6e98b4971e8" },
        #{ path: "locales/sv.pak", mode: 0o644, sha256: "54cf311648f8688effc4cfd70a580b85b837e67dd9e5f194d9f761202a27ebba" },
        #{ path: "locales/sw.pak", mode: 0o644, sha256: "3475068a7e3b8205444f914d7d29421fb45b87c008594984f3e7b04cff22b2d3" },
        #{ path: "locales/ta.pak", mode: 0o644, sha256: "e4053fb503c08d94b7364b10a74abc04506d15f67ad74b9ea66185999ea177df" },
        #{ path: "locales/te.pak", mode: 0o644, sha256: "4955104544daf89da718e7f584ad66fe35dd4ca219c245697de2929acb317ec8" },
        #{ path: "locales/th.pak", mode: 0o644, sha256: "2272de996ac5c553cf01f406e6f708cb98ad419708355fb4969cb91ec8031e56" },
        #{ path: "locales/tr.pak", mode: 0o644, sha256: "f690918f136d8c5bad9853c358670e60475999d0faafb36d36001c4fa7ec4f8b" },
        #{ path: "locales/uk.pak", mode: 0o644, sha256: "26ddf342bb13d674df20162ff1a955edc56e6ffc64bc846953e7b2be8827fe80" },
        #{ path: "locales/ur.pak", mode: 0o644, sha256: "203e225739beb9879eebb08d08d9aa17b80f02320049f03d453156ff53170da8" },
        #{ path: "locales/vi.pak", mode: 0o644, sha256: "4dcf8fe139c4355a8999137098532662e5af79d7b464c6e2faab686605d7ad8d" },
        #{ path: "locales/zh-CN.pak", mode: 0o644, sha256: "aec678d57f7644157d8d7d1007cd03c9efbc7ef54488df2f856989179a563e42" },
        #{ path: "locales/zh-TW.pak", mode: 0o644, sha256: "deba23736da06f4e2633cbecab98e7b9c3ae8b6b7245c08b89f63581fa47f1f4" },
        #{ path: "resources.pak", mode: 0o644, sha256: "7fee8f5de6db250469244546544dfc3b7585f6bbaa0a1f9608ac8b4a884db9cd" },
        #{ path: "resources/app-update.yml", mode: 0o644, sha256: "7f5e7ecae74c2a2483979d085b39f59df66a908988d46d73dea8eefc038de2ba" },
        #{ path: "resources/app.asar", mode: 0o644, sha256: "94452cf0ce71bb4c21cfbdd51b31c0c6404e7aeb99539bdecce8954175b9dbaf" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/LICENSE", mode: 0o644, sha256: "58d1e17ffe5109a7ae296caafcadfdbe6a7d176f0bc4ab01e12a689b0499d8bd" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/McpContext.js", mode: 0o644, sha256: "39e41d2e578aa983fa7a3ded08ac9438af7dd8423a29829f746c0fe9e9cb70b3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/McpPage.js", mode: 0o644, sha256: "829f11b3cb4c7b87dbb4f5b6a3f62583f4fc05746daee21e629287247debb340" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/McpResponse.js", mode: 0o644, sha256: "8f4189b21fe26726cf64137a74542efd4927c21dd4c2794924af95fdaf64d761" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/SlimMcpResponse.js", mode: 0o644, sha256: "eb5be8144643e1aa3c3ab335c974fcd7dfd60088102bf90c9dca11d59ffe669c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/TextSnapshot.js", mode: 0o644, sha256: "f3496989b93d174723fcf394628fabc36936b37e6a815fd85cbe20fba46d5ea0" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/ToolHandler.js", mode: 0o644, sha256: "49dd8d88257394e778573e3449af6e03fdc2fab73cc8370af26205aeecd8ab7d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/bin/check-latest-version.js", mode: 0o644, sha256: "247d4494a1ef9904bf9cdc1166e94a6253ded7586e0f622668dbd102cfc64534" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/bin/chrome-devtools-mcp-main.js", mode: 0o644, sha256: "5ca0e81196ab6b6e1481629a2dcae7f416b3b38f74555e3138ad5cdbb055e809" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/bin/chrome-devtools-mcp.js", mode: 0o755, sha256: "9f380d06e1ac05b257e27e708c0cc4b4ba190e285ed6eb6c8aa50978d98a12c5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/bin/chrome-devtools.js", mode: 0o755, sha256: "c380c15c89425bfe8e0aeb7720bf3996d681752413ef77cb3a33f769a8c70dc5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/browser.js", mode: 0o644, sha256: "17f861505810a9d25784fd71bf0592966f513c420b57a728b344280e97fe596c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/collectors/PageCollector.js", mode: 0o644, sha256: "371f37137e63a1951df86998e7235b16ec164e8aa76d61838960ebeff90593e0" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/collectors/ServiceWorkerCollector.js", mode: 0o644, sha256: "19b54696f20e20af47636beafe3c2d3ff2963ace13a0ffef1857ad9197ac1b29" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/config/browser-options.js", mode: 0o644, sha256: "d172515ff92e0efdda98e84581c46e2db97ba0ff3536507bf3a9da022dcd1887" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/config/category-options.js", mode: 0o644, sha256: "8d4c2b6a5b22839226e8b7cd32ee552f949d75f61e7b354ddd75f3a50e46de33" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/config/cli-options.js", mode: 0o644, sha256: "05011d9cc5fecae6f359c4aff3272eedb35796cf2e6cbf53db39fe52a49dbffb" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/config/mcp-options.js", mode: 0o644, sha256: "2fc554986209b3cfadcbe70552994111aadedf2e159b3de61a12b96233f18f67" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/daemon/client.js", mode: 0o644, sha256: "fc6500be58f2de1c941d66171a43fa8bf796cbea9420575bd8b299ff4e66f1a1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/daemon/daemon.js", mode: 0o644, sha256: "eab00479391fece6afe0d45afe564bf0e9e8b4f461d7ec5c9f9bfe9aefacf7fa" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/daemon/types.js", mode: 0o644, sha256: "2d0e820cabc31fdeabd4a00a4b6806f08ffc9e97e981fe40cc2abc3836e9407a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/daemon/utils.js", mode: 0o644, sha256: "6769ad4523dfe5f65b7650117135393918146866ccb5f7d583afc271512e7f7b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/devtools/DevtoolsUtils.js", mode: 0o644, sha256: "de03730a2a94bc1bf43b7d17748e79490e74b145e31c607e91bf8e67b8c46fa5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/devtools/McpHostBindingAdapter.js", mode: 0o644, sha256: "ec6eba6406bd14745ab322c327c3fe4c6ba43e6b4b2383fe650c1d1f1b215c38" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/devtools/issueDescriptions.js", mode: 0o644, sha256: "5bd1c6a0a2518dda8a5e6a7bb461f3a871bbec6dfd0e8e0a380c6ad9b7ecf1ee" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/formatters/ConsoleFormatter.js", mode: 0o644, sha256: "971722391a311526ceb5c795a4979cec62c7069ed58d4d5cba0ea00b4509b4ae" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/formatters/HeapSnapshotFormatter.js", mode: 0o644, sha256: "84ba8b00985f3b9f4efe8af2554d7daf92238ce964461a7c59b2d59e7d144a26" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/formatters/IssueFormatter.js", mode: 0o644, sha256: "296c785b043a02c2373ecdc4177bda931693fc3a8b882397591a6db941647d86" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/formatters/NetworkFormatter.js", mode: 0o644, sha256: "8ae5d8987daa37172896a45675e5fdf9e3ac55773f8a759f93875c978defaa78" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/formatters/SnapshotFormatter.js", mode: 0o644, sha256: "2be8f74a70dc801dd077efc90c4dbf99d40cc7dc912ffe20873abca505644e78" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/index.js", mode: 0o644, sha256: "793dd988623744d46395e586500b5405fd17694cc4bef98d6593bee01563374a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/processors/HeapSnapshotManager.js", mode: 0o644, sha256: "6f0a6878d4ca6eb203880fd2c2a7a9578a307241831b3d08ffd1c57ba54e3aa3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/processors/PerformanceTrace.js", mode: 0o644, sha256: "7377499898929e62b33402e45caa2d9e57be330f413a5d4f504b27642fbfddad" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/ClearcutLogger.js", mode: 0o644, sha256: "bd0507a2097640d2b5d2f50c9e36f81760bd074300c68844198846458e893e09" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/WatchdogClient.js", mode: 0o644, sha256: "9ca5a30a7e53d0e67f6e6bdbc1855b16dba593453bbcdae881a998028d136373" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/errors.js", mode: 0o644, sha256: "edda94916c9423b10c496bcf26d475f69a73c128999aba0897e7bcf9f9763737" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/flagUtils.js", mode: 0o644, sha256: "dd7c4ef62421c212b07d8e949bc91dd2f5b9fe8adf0dae482984bd4059e8ebff" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/metricsRegistry.js", mode: 0o644, sha256: "0770bc35b834d76ce7ecd78ffc946cfd733583c0ded7528f98883a31375fbba8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/persistence.js", mode: 0o644, sha256: "468d6492a2019f3372ed9339e178a46ac390adaefdb4a9e73a51173a3d823e54" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/transformation.js", mode: 0o644, sha256: "97e3d94a1d5b1d171ec1fa09e4b0592aa35039dcc762246bc4ab948fc606b003" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/types.js", mode: 0o644, sha256: "3834d9e153ecfba3dd2a9bb0e555bdf6a8da99e2c51e23e07297dfc18fb4eb8d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/watchdog/ClearcutSender.js", mode: 0o644, sha256: "b6aae5a36c6ba0967eef74f783056c7c5d14e20944b2cfb53c12c9836d03e7af" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/telemetry/watchdog/main.js", mode: 0o644, sha256: "d1b11b6a6cf149a488a7c54e0a2585d2e358db6a4d0918e1f7acd92090ed79db" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/THIRD_PARTY_NOTICES", mode: 0o644, sha256: "975febf536bb1c83c031a7888b90bdf1ffe8dc46000e0698eac364491dca8ac4" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/bundled-packages.json", mode: 0o644, sha256: "22f29bc10d8f5c29b6ab6681dcf202a826ad3e3545bcd392bfd3948631783d68" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/devtools-formatter-worker.js", mode: 0o644, sha256: "46c0de591aa67869a8c4271b953382ba34f93b3a29ccc9c64f502f0652c43512" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/devtools-heap-snapshot-worker.js", mode: 0o644, sha256: "fceb6034d9fe21600b8015b7fee37b47a357b00d2477b9f0c5b35c5e1827cae8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/index.js", mode: 0o644, sha256: "fc6ae43cb8f6007eba4b0f269290ec8fea6db7670686d17967b4812d90d2cc10" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/CoepCoopSandboxedIframeCannotNavigateToCoopPage.md", mode: 0o644, sha256: "3582188fd1f2d2d72d5cc1e2d465077d124945c1199ec63194618ba22c0dc1db" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/CoepCorpNotSameOrigin.md", mode: 0o644, sha256: "fb746b95bf0313dd18126bc3e1b472a25a6a6ee694fceec0c4f09d725b1e7720" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/CoepCorpNotSameOriginAfterDefaultedToSameOriginByCoep.md", mode: 0o644, sha256: "c4cc63b488caa8cd6994dc7fe547f0eae7c0fd1d37298e08609d5653d6f269bc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/CoepCorpNotSameSite.md", mode: 0o644, sha256: "79179185dcb561319827841b1c2fe9f8445cd304dd29937ae703f5182a2c951b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/CoepFrameResourceNeedsCoepHeader.md", mode: 0o644, sha256: "2fada58a07ba51493ccc8dc956279d352c80a6373ffb94202cc4495e07e72ce4" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/CompatibilityModeQuirks.md", mode: 0o644, sha256: "3b1eba77974ad4668b80be0670e1f61f2fa8f14096aaf1adcca156b91c04f815" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/CookieAttributeValueExceedsMaxSize.md", mode: 0o644, sha256: "7dbda0bd8e63ddcfcda1b51d93dae2a2247cae6460c1fe14d2fa039ee4c62fb3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/LowTextContrast.md", mode: 0o644, sha256: "e01a221a142b065c7df8b003ca4bd3e8cebd5011b5ed0b07c0bf82559446e981" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/SameSiteNoneInsecureErrorRead.md", mode: 0o644, sha256: "b67e947eda241cb40d2ecc22cc05da582011638745d7ee8694676318ce846985" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/SameSiteNoneInsecureErrorSet.md", mode: 0o644, sha256: "d86a0aa6f1759bb9bceb3205c190e2c0c54467c24113cf9d49a8ad4c7fb20f94" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/SameSiteNoneInsecureWarnRead.md", mode: 0o644, sha256: "d9c7b33be03aa8eb27ab7c979ccbdff300a01018d9cdfea5acd6ca22f7afdc94" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/SameSiteNoneInsecureWarnSet.md", mode: 0o644, sha256: "66caace5636f687c95747bf0df18cac755270ec87d5f070324e81106d9deea04" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/SameSiteUnspecifiedLaxAllowUnsafeRead.md", mode: 0o644, sha256: "b3e6548ad1d1c8fc0dd323f58be0e85d97f45db8a85d06862da2606c2eef9cca" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/SameSiteUnspecifiedLaxAllowUnsafeSet.md", mode: 0o644, sha256: "1fbefc2a7ac414719971ba1b9c060f5d4c880d9d8fbb84069db0403e12703398" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/bounceTrackingMitigations.md", mode: 0o644, sha256: "a707191364630b824b2755dfffcd4ddca4c0c12f2bc03df38e1f56f137097afc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/clientHintMetaTagAllowListInvalidOrigin.md", mode: 0o644, sha256: "af37cca14ef910e166f689de6482edb6b6f67f380fba293d14ebfbc1af3e82bb" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/clientHintMetaTagModifiedHTML.md", mode: 0o644, sha256: "1bdcc86b6bf9426c353d5b0c57c2f616ffb4eb729114f53ea3e95d166cafe778" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistEmbeddingRequirementNotSatisfied.md", mode: 0o644, sha256: "e9bfb6c3c8b0f298069c44080c6422d9dfd2c8668a6947bd4f2c244e3366931a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistIFrameAttributeLoosensEmbeddingRequirement.md", mode: 0o644, sha256: "ff0f709b5df2a15b8a4e0e18df1b042a1e1244842a4d9941058f68a22f8aa2ab" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistInvalidAllowConnectionAllowlistFrom.md", mode: 0o644, sha256: "7e2f69eeb6210dd44b374c747fa2be0c3df8ab7bb780ffecf38fe4fb7e116628" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistInvalidAllowlistItemType.md", mode: 0o644, sha256: "04d151f2d70399212fb5a29b1d0c44ff35748821811f9c704e03b53ca0c49c1b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistInvalidHeader.md", mode: 0o644, sha256: "1c5100ca7d91629c105e785922cab75543fa2ac9a9edee292cb0ebeaa36bfbd0" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistInvalidUrlPattern.md", mode: 0o644, sha256: "53ebd062e3d9d31d1d9c0b91a40c684b523aceb59c5b30fe3340a1bd0ccb070b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistItemNotInnerList.md", mode: 0o644, sha256: "a73938f202fba6d5f1a9797b6e3b06933519424e2747af6d2eaa12b459a26171" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistMoreThanOneList.md", mode: 0o644, sha256: "2b9c0cb49220b91b5f6399131aef776afcdfa281b0c908057ddecf3e8513fbdc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/connectionAllowlistReportingEndpointNotToken.md", mode: 0o644, sha256: "b122db2bf1513916b08a5fbb31c38bdeeb11235e2d6d094c9e37d9e9c810c27b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieCrossSiteRedirectDowngrade.md", mode: 0o644, sha256: "42c3ff4213559e5ccaf4893b76de3cb2b11bf132e6834099987f38c030c1e47c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieExcludeBlockedWithinRelatedWebsiteSet.md", mode: 0o644, sha256: "9806fc17deb3b1308b718157823f1363a523c70b01a8fad321363c44b64a04d8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieExcludeDomainNonAscii.md", mode: 0o644, sha256: "f3e945226678843bfd0bd9d75d1ab9a50529798ba117e9c141e169160850693b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieExcludePortMismatch.md", mode: 0o644, sha256: "26d8bbb2295dd69085fd1023821c3e1f4f44a87923eed9862bfdd0e1d0480e3d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieExcludeSchemeMismatch.md", mode: 0o644, sha256: "3803a1d5dfaedbde0bb5fc9c37d0122ad13663ec9f37f059006d1ca86298eac3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieExcludeThirdPartyPhaseoutRead.md", mode: 0o644, sha256: "34f45001a4a5a3a2b83c9d271dd72174171bae1bd86445f2d660ca483bdb2e1b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieExcludeThirdPartyPhaseoutSet.md", mode: 0o644, sha256: "46e028b9eef362b311141b1b4a3ad377e92e86d8b9c7749aaca2c5ad63b20000" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieWarnDomainNonAscii.md", mode: 0o644, sha256: "947dd6d5e7daf17f433b1fcaa2dfcdbe96304cccc2f5adaca19365acdd57bdd5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieWarnMetadataGrantRead.md", mode: 0o644, sha256: "3f437c58f9d7019488ea67c5f4cfc355e38cd3bf1adffcb53470f8df2959529d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieWarnMetadataGrantSet.md", mode: 0o644, sha256: "2940e4345bad4a862983a9984bd417073b588c68ebbf16221315959c5a010d41" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieWarnThirdPartyPhaseoutRead.md", mode: 0o644, sha256: "9b8295fa4656f31bf0a42b18a78ad797b4017e26406180b496a749d7efa95c00" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cookieWarnThirdPartyPhaseoutSet.md", mode: 0o644, sha256: "303db16c18700334eaeaa8f0a994908e392c2527d3286ee5005d5081491b8a6c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsAllowCredentialsRequired.md", mode: 0o644, sha256: "067c0c0bb5f576ab31d57eeba21b0c4c5424de20b1be212706d43e4cede09eda" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsDisabledScheme.md", mode: 0o644, sha256: "f93b602afa1d2b57b4dcd144abfed20071197b3f9105d733a58fa7a19f7a0352" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsDisallowedByMode.md", mode: 0o644, sha256: "cde8dcad47eb7ea7a098845daa31102ba65fd63cf11dec3e52a6fddc52c0a0da" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsHeaderDisallowedByPreflightResponse.md", mode: 0o644, sha256: "5d84852ef01601c2648a253cfa6ef90e3f80cf585d4405f856726e742af4d9bc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsInvalidHeaderValues.md", mode: 0o644, sha256: "a8d21093f6eb445f52b22cc05d169e25509ec624aee4a6227dc8f79ac333352c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsLocalNetworkAccessPermissionDenied.md", mode: 0o644, sha256: "9112c77a52b11a5e7a53a94fc6cfe8deed3e006d4c6dec6d8c6451f24f4e8ce6" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsMethodDisallowedByPreflightResponse.md", mode: 0o644, sha256: "3526c6ffec7acdc92e960e62396fd25ae76e80fe3ff9b370fced5031fcc586f2" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsNoCorsRedirectModeNotFollow.md", mode: 0o644, sha256: "38ff062d2ff452d226c1a08dc30f6ec1b2bfd7804e58944e2707d9d695bec68a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsOriginMismatch.md", mode: 0o644, sha256: "976fdc2605e7174f6786f2cc3ab59333d3d231309e3c3aeb2a8a8866cdd91259" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsPreflightResponseInvalid.md", mode: 0o644, sha256: "1d40fa22f435246e7b54fb0516ebbb85fb85e77c08abf720df4578729108ddd5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsRedirectContainsCredentials.md", mode: 0o644, sha256: "274efbd8aede09f4c7c91db3c9ee3e28a11dea1e3764dc30e5cd168cc2e663f8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/corsWildcardOriginNotAllowed.md", mode: 0o644, sha256: "1e423693c06656849f205ba0da9216073c7f278b10e38d33b3c26f49ad6540e8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cspEvalViolation.md", mode: 0o644, sha256: "57fcf6688da79eed9eaf0a8332fffe264ad7ac5f352be4caf3be2b11e7510d05" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cspInlineViolation.md", mode: 0o644, sha256: "4647e1cf785b01cd30c2cd6a40521517f97a0e71d2dd45d5b360cbad7b14a4c0" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cspTrustedTypesPolicyViolation.md", mode: 0o644, sha256: "3ad28ed8aff635c2f6cafc24f8a06244d865befe78426a5c8f340f870e29a787" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cspTrustedTypesSinkViolation.md", mode: 0o644, sha256: "fd0f1ce1dbf1ecbf2148ed14b49ea67cc03c1771c03c33b1669afaf6ca936750" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/cspURLViolation.md", mode: 0o644, sha256: "bca8824a308cbc866321b234b9403d8679fd25ce36a657d1e36b267cfb346661" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/deprecation.md", mode: 0o644, sha256: "d60bcd2546a8e3bb2df5882bcc358aecf439b23349269b5ef9d391f2e171c9a8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestAccountsEmptyList.md", mode: 0o644, sha256: "8f210508e7ffdc48697c4cc7305b5c302450717c300fade9f8fc8fdf1a1a7bdd" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestAccountsHttpNotFound.md", mode: 0o644, sha256: "8d7d9172f0766edb8473bd45fbee33ca45c7bcf01e16b153f17ac7eb8d1d23b3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestAccountsInvalidContentType.md", mode: 0o644, sha256: "022ee79deac5e60fab5d0ce5f678217fb76fa7c9fd7ba38fec86f88e4054c895" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestAccountsInvalidResponse.md", mode: 0o644, sha256: "ba0eb74bba8e4e4572989fad08a37e4f2133558b95d7d6a5c5e4620db323ec45" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestAccountsNoResponse.md", mode: 0o644, sha256: "b96810111b1992ca65abf2d3b8d4f9b000c34a6405d3633224996ad02317413a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestDnsFetchFailed.md", mode: 0o644, sha256: "9b64ff500576a4109e025727ecdac17d13fb843a79b4ab113a2fe78f7f4c6d3d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestDnsInvalidRecord.md", mode: 0o644, sha256: "78de3ecd132cd8489c446c1fb424ac6ae348f710335b4e32f4ecc2dffc654ee3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestEmailVerificationWellKnownHttpNotFound.md", mode: 0o644, sha256: "eb6252a3e48545343c8854b9970d6d6e6cc26487192f25291baf800e47bdd820" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestEmailVerificationWellKnownInvalidContentType.md", mode: 0o644, sha256: "56ccaad6967603ec6154e1b1a1c22b94b1df7aa74cdf12987511473fc7945e17" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestEmailVerificationWellKnownInvalidResponse.md", mode: 0o644, sha256: "4236cff2cf3f8cb1c0270a97637f7dca115e15279e2f47b517c0465946768145" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestEmailVerificationWellKnownNoResponse.md", mode: 0o644, sha256: "b655926e848c42e21a35dd87e1585b040ea3709dca3db85b428e089d5696ad1a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestInvalidEmail.md", mode: 0o644, sha256: "0abff21492cc3f8f7050a05c6e2450c56426c5c9c4726e8058a08cb7023888fe" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestJwksHttpNotFound.md", mode: 0o644, sha256: "65db2accd355e5e635a2e9f171ada4615daca53d1ed0717030e22bb35f391380" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestJwksInvalidResponse.md", mode: 0o644, sha256: "02361f4ba13277888c2e6bd7478a952f0d2ebed7c195507728e0dbafa8e4e8a3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestKeyBindingSigningFailed.md", mode: 0o644, sha256: "04ff9209386ba3d7c873c3c7e73fbfead601ceeb99ee1f497aa6f40f482aec4a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestRpOriginIsOpaque.md", mode: 0o644, sha256: "8c8572713d50f615e4c4df7e73470d01448aa9480019515cef13398939ce73bc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenHttpNotFound.md", mode: 0o644, sha256: "8ad418bb09db968142a608f0a234aaa6a8e1ff3ff02d49eef3bfd4346383c0d1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenInvalidContentType.md", mode: 0o644, sha256: "2bb755ac8e4ac2c5904687307603ac717520482c4073905fba46e736d3bec5a6" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenInvalidResponse.md", mode: 0o644, sha256: "30c4768be1014ed274848a0d88c0d7c5414b2d965c4a75a581276d6e261eb2ac" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenInvalidSdJwt.md", mode: 0o644, sha256: "af0e80a447dccdab46ea34d94544e13dc2c70e8209d582e27bd955933bc834ed" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenMalformedSdJwt.md", mode: 0o644, sha256: "988c4ae7447c53137eac1ddc495975b7dbb911a29d6a641004335dcd0c90d7e3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenNoResponse.md", mode: 0o644, sha256: "2cf88085e7829ddb66d664a6a18ba9f901df0816744d8dfffc1879e434a0735e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbInvalidAudience.md", mode: 0o644, sha256: "9532defd825bc95bc9b8932c552abfe5a96c27a2ff38c1619525909ce11b5032" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbInvalidIssuedAt.md", mode: 0o644, sha256: "e33c88c822748afb8c7f3f81bb5dab5f0eb2c3cc78d15a0e07429fa56d0b5e0a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbInvalidNonce.md", mode: 0o644, sha256: "63ace3bbfc7e20f74e8912b1af6dc2da9cf7ea078973fc277e0da32a9df091e5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbInvalidSdHash.md", mode: 0o644, sha256: "a135180d2728cbfc1ae93be18d1e7513c7f277d0458e377f3d7d261c7fe83892" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbInvalidTyp.md", mode: 0o644, sha256: "cf58726c5c197788f3e423734299a5a486efb20ec5116d0eb7a9df1dc06c0c71" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbMissingAud.md", mode: 0o644, sha256: "3fc32dbac24f07c049a44b18419d619ce81e052a05171cb070f2a3e9a5b1218f" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbMissingCnf.md", mode: 0o644, sha256: "31bd073f6fd8c1060d0af4f260c2988c004f659340e7ef06676bf7533f8ff3d3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbMissingIat.md", mode: 0o644, sha256: "a10b16d00bcf1323344b8821f009c4460ffd2ee0bf137703bfc3c9ffe8277b1c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbMissingNonce.md", mode: 0o644, sha256: "1ff67de2f2186c8b9d842697828f25407053bbcc91a6b1177a9b2988e82d2aca" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbMissingSdHash.md", mode: 0o644, sha256: "0f2914020f479f7544779c2fbc76359c9b52094b5c783e17d9d76d262c7199ec" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationKbSignatureFailed.md", mode: 0o644, sha256: "49f3cddc5e33b37e0a0efee8ce7b6c2e2f7052a69d99fd7a61b569ec5f9f7159" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtInvalidEmail.md", mode: 0o644, sha256: "44e7b57c155474c649938e218fd3c3c96f17cc1a38c15731fb3338c64e7bd147" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtInvalidEmailVerified.md", mode: 0o644, sha256: "af72b33c53005edbbc0541d4a438087158ed976d9264e5270ce32bebd893d9c1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtInvalidHolderKey.md", mode: 0o644, sha256: "846e7c80e326eb4947fd286197d1a679b407b847a166b9328b81cb7f3af7641a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtInvalidIssuedAt.md", mode: 0o644, sha256: "43b3b547cb92711aa0a6f896ad32c66a5ecf2c24d83f18bfbacb451499aaa11c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtInvalidIssuer.md", mode: 0o644, sha256: "69f08d9d1bace92d1361db661a0cb49f265d95378f254be86369b9487614cd8b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtJwksMissingKeys.md", mode: 0o644, sha256: "8de5d3ca3a4ba9620ab59542339fa949f9cbc783f0e72d5381da381c840ba968" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtMissingCnf.md", mode: 0o644, sha256: "d470a6d0aaf11a8f61541d6321fb2b9a7dd96e496173396eab8bc116c06faa92" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtMissingEmail.md", mode: 0o644, sha256: "f051fa56b17dc3417a6e5275693b8a2f0f8b2fe262eec28c29bf91c04e0774c2" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtMissingIat.md", mode: 0o644, sha256: "8ed394a524b71843eda6f472b1e16a6ef2de402b2fb6fc7c9521e7b8ae18a12b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtMissingIss.md", mode: 0o644, sha256: "ee73d9eeaa4f00c070757464857ce509d9f6caa8146d92705ba99c47ba429c07" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtSignatureFailed.md", mode: 0o644, sha256: "4ed09397e36b6c8423c7b95ae664c48e59edbe8f320a0fd068b9215befd7478e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestTokenVerificationSdJwtUnsupportedHeaderAlg.md", mode: 0o644, sha256: "f0f063d2e156573ba1232e17582ece3c0ddccb77892f84483f6e53dd9facb03c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestUserLoggedOut.md", mode: 0o644, sha256: "ce7fd59b237e944d256cd4df25376b9d0fba7d38b3016d4d7409e210b7658839" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownAccountsEndpointCrossOrigin.md", mode: 0o644, sha256: "040c5bd5e97b29e8b5ea2991c8414eb07ff725075392b2af9a544144668d6a48" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownHttpNotFound.md", mode: 0o644, sha256: "3882109caecdfa7b930300f598d90024798bbaf483fb48c0eb8e4cc0a75f4783" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownInvalidContentType.md", mode: 0o644, sha256: "43c88d0671157e2f683e4006459f61fa176bfb7e83cde05e553328c0625c8bca" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownInvalidResponse.md", mode: 0o644, sha256: "7a2ad5146e545311dbcf06ab778e245bab2e6075c6357a1055606fe794ddf736" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownIssuanceEndpointCrossOrigin.md", mode: 0o644, sha256: "8782c43e6079e5f38d98e27e5d25f8ac942fde7e7b1d3fe6bb44785ab7274e83" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownListEmpty.md", mode: 0o644, sha256: "20acb26d06b7aec039a84d97b0d97fe3cb0e4fc16e085863d2ed91edd4ee3a06" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownMissingAccountsEndpoint.md", mode: 0o644, sha256: "050ef0a86d7927ce5478d7b392745907cb9ec8278e5c7cbab8853f90c91e2da8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownMissingIssuanceEndpoint.md", mode: 0o644, sha256: "5b1b918a5b9b9d97e94b7723be4dde7caf9b79d8d1fe34ea086a4d5ae3093ad3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownNoResponse.md", mode: 0o644, sha256: "e41178a7efed55b9075e0bebf4c679ba078d68888bb66cc44d21253ef1185913" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/emailVerificationRequestWellKnownUnsupportedSigningAlgorithm.md", mode: 0o644, sha256: "1c0bf4ad85a45e64c05ea1e7c5b317fcaa82ed21ce57411a48e69f28bb19f931" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestAccountsBlockedByConnectionAllowlist.md", mode: 0o644, sha256: "52bf6cbb071dbb97a5b4b463344b682787d757972a736650d5ed639229f0547a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestAccountsHttpNotFound.md", mode: 0o644, sha256: "0bfb198f6ba3621f57667e8bf264b1af54ef525c9f259cfb739a3f1544951d52" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestAccountsInvalidResponse.md", mode: 0o644, sha256: "679d3524d968c3b9e5ed1f2381973f846e34572a80bc3d6c65752903c94fd57b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestAccountsNoResponse.md", mode: 0o644, sha256: "5f6b0d1ca9a6b6b6b79dcb163b45230f7584f29a367a98654bc94c58e8e21a0e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestApprovalDeclined.md", mode: 0o644, sha256: "ebebcc534c9909ab3e50d7ef40bc6982901f79cc0dd65d02aacbaa6c143996c6" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestCanceled.md", mode: 0o644, sha256: "5c73d2798e99d1e19cc28835dae56233a511a7f83eb8de97563c89fbfe30dda6" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestConfigBlockedByConnectionAllowlist.md", mode: 0o644, sha256: "f58c26e627cb58ef41521c603b9d7eba3dea90d90c1e6b510fb74faf3b7821ae" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestErrorFetchingSignin.md", mode: 0o644, sha256: "4ecec5b1ae0d414eaddeda83aa4618ebc9c0105a42dcce2c81f39320c1164300" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestErrorIdToken.md", mode: 0o644, sha256: "587f4a62f9b075c4e646fd5a5feaa35b7f0faa05310ca9120d30c660cbe90a00" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestIdTokenBlockedByConnectionAllowlist.md", mode: 0o644, sha256: "61455ee027b4d9b32eaace5eba5e512e4c7b99ab362b750212f603b8ca2f0e23" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestIdTokenHttpNotFound.md", mode: 0o644, sha256: "a4780a4c46b309eb7d83fc6529209e70fde75feea0d1f69df11f1c61566ad9d2" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestIdTokenInvalidRequest.md", mode: 0o644, sha256: "74fb4c8968c1c724537c4b308dda4445d0f56f687f47847efd8ac6c2f0d9e96b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestIdTokenInvalidResponse.md", mode: 0o644, sha256: "c43a51670fcf8d8e20b4c82fa347875f7877ee03670f46ba2e012e149068af7a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestIdTokenNoResponse.md", mode: 0o644, sha256: "6d64de8cf184cf3fa3a6412fe2a279a81da199ac33578257b3d0d368ed9b760c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestInvalidSigninResponse.md", mode: 0o644, sha256: "5d280ad82f9f73ea061efb0fd4a7503c268dd99fbf979b0993e30d892dff0a23" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestManifestHttpNotFound.md", mode: 0o644, sha256: "0d4092df6268c358677806f5a52babb38fce2b8d3930059fc3a50ef890f14d49" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestManifestInvalidResponse.md", mode: 0o644, sha256: "85752b050c14a99943f356391398dca293e1f460473621d0673cb040af288e5b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestManifestNoResponse.md", mode: 0o644, sha256: "d73c10e97eaae1ddc5cb849a462d4d36dc85e1397754eca543ba22b15c3c571d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestTooManyRequests.md", mode: 0o644, sha256: "34b5aa00e9735361301ad0a790479ed339fad6c2f3682540d469144a41b1eb79" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthRequestWellKnownBlockedByConnectionAllowlist.md", mode: 0o644, sha256: "e80659cb7e08dd38a9d73aec0a82262687c9146826dba05b203f8457ff1bd3c8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestInvalidAccountsResponse.md", mode: 0o644, sha256: "3e422e3c96b42123f01f231d7d256ed9a747fd1b5f069745d8aa0bc6a77af338" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestInvalidConfigOrWellKnown.md", mode: 0o644, sha256: "ef40a9fe80819af36e352c692ad5789dd3e2e86436ca4e7799a423bc51383713" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestNoAccountSharingPermission.md", mode: 0o644, sha256: "441de9f12e0b0aa3a016d55a7f12b94f0568027d92a1281e5176519347389fcc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestNoApiPermission.md", mode: 0o644, sha256: "b5da9d5ac1ad1aa9c0efce8550ad676635347d2870bf6c392cad775fa496a654" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestNoReturningUserFromFetchedAccounts.md", mode: 0o644, sha256: "25099845d280e3021acdb8bb9ca54e17d6a1d8d8640cdafdc4df405b6c112143" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestNotIframe.md", mode: 0o644, sha256: "123eb50132215a1c610e7d127ebe2074f61e4896d42081dc4a0f5484a4b6f212" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestNotPotentiallyTrustworthy.md", mode: 0o644, sha256: "bd46fc104d4f3c7a35a0b37f6dbb3fdfa584bd1d5b9b2e3611174182d7cc2157" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestNotSameOrigin.md", mode: 0o644, sha256: "9a943b70036c4b118514467d8846ca00ebef86406ee1ced9326abe29705636aa" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/federatedAuthUserInfoRequestNotSignedInWithIdp.md", mode: 0o644, sha256: "41162907a35aa687139194b38c3030944c4e57ef31ddab9d876ec3e85a71bfc3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/fetchingPartitionedBlobURL.md", mode: 0o644, sha256: "657c878f31e1ced0f52884734c1e34b347938f6daf86a2b25aa38e10ae9ac0c0" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericBackUINavigationWouldSkipAd.md", mode: 0o644, sha256: "125b35e2457b5c381da8c3fab3df19da089450af8630c869ab5e9e037c87ca82" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormAriaLabelledByToNonExistingIdError.md", mode: 0o644, sha256: "a97d803359f5ae0f6e6448e2522c2abc75a9f8bb02566b0ac85780c9412729b4" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormAutocompleteAttributeEmptyError.md", mode: 0o644, sha256: "3ef57d6c5c6776d0fdc3d231b6e935844718e5e8b35b84c9b9a3efb18367fa06" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormDuplicateIdForInputError.md", mode: 0o644, sha256: "f18e6702a8388f0351275c762ca348c91b6c9475ad09b002ff53d0afe5add96c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormEmptyIdAndNameAttributesForInputError.md", mode: 0o644, sha256: "cdf4f5c2c6d9cf5c20232434e6a860e70a2d8b0ddd54ca153287f40bcec0a694" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormInputAssignedAutocompleteValueToIdOrNameAttributeError.md", mode: 0o644, sha256: "01f93e21935a4f518d54647976e4eef753157a76e5d54f29ca94ee9b7eae5170" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormInputHasWrongButWellIntendedAutocompleteValueError.md", mode: 0o644, sha256: "14b2259c74d2dd2f2d3ed99fe486dedb7feb65646b67b0409c8bb55ebb584733" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormInputWithNoLabelError.md", mode: 0o644, sha256: "179af913481b71b3c114c476226f5993c349c42a60c6e102a3445e15bea98c17" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormLabelForMatchesNonExistingIdError.md", mode: 0o644, sha256: "d823124796c642d41bd4c894c6c5c63add731970c992e4eefb74622b44b1a27e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormLabelForNameError.md", mode: 0o644, sha256: "b8be140de1287b64f788ffe176d456d59acbdd494195acfea2aacde9da3d8cfc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormLabelHasNeitherForNorNestedInputError.md", mode: 0o644, sha256: "3da39478293c7b1bd22fb5ffa87b1bc29b721c21e443d3914bdf318eab8a5cb9" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormModelContextMissingToolDescription.md", mode: 0o644, sha256: "67eebb1b014b871e8e58bc982c745d4c4677a2b9a4534d471af7948b757a9ea7" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormModelContextMissingToolName.md", mode: 0o644, sha256: "762d7fcffd6bd3a8616a9548ea7c17d42e2de7ceed56c4df82417f2f9d730669" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormModelContextParameterMissingName.md", mode: 0o644, sha256: "e278451d0ec8c46a797505dabec2115f02f50c198aff1b415bfe59656ba2f2f9" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormModelContextParameterMissingTitleAndDescription.md", mode: 0o644, sha256: "4a834d6168bda671551a5f0105acb0649eea8be4678ff64d165354c67440a6ef" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericFormModelContextRequiredParameterMissingName.md", mode: 0o644, sha256: "ac5c826c319f2a7533eb0bed27e0a83b06351e32ec30874d701f411cfc586c89" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericNavigationEntryMarkedSkippable.md", mode: 0o644, sha256: "58ce93cf354776a1f026bfc9d80d3d8c98a04cbd4310896edc8f79b1f6349230" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/genericResponseWasBlockedByORB.md", mode: 0o644, sha256: "b5b766499df139bc5d98cfa22ccdc43f58dd99b3bf8b91a57f2d2e3cd7fe1da6" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/heavyAd.md", mode: 0o644, sha256: "45d6b2e239e3e54c8f127151aeec67ba480ef748a6bcfe9a276a1d8f03109b04" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/lazyLoadImageZeroSize.md", mode: 0o644, sha256: "5b68987d10a26ffff2f17e68b0a3d48feda5301803a33ae6dd4e07f41bb078fa" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/mixedContent.md", mode: 0o644, sha256: "5d4cd65a894905a032ab6d953c38c2b74ecf377e26ab0cf687dfa85c123260a5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/navigatingPartitionedBlobURL.md", mode: 0o644, sha256: "86ce0be2a82b41eb240b7c4fa43d51fb678328e7a42870835d0b541011dc6866" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementActivationDisabled.md", mode: 0o644, sha256: "7c0a680a6059fe89ce53387cca7eefbc25c51784bba805f9d69ab7a61a15b9fc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementActivationDisabledWithOccluder.md", mode: 0o644, sha256: "a03a3ea01d3438dddf493eab1c7de76b632f3c05c92e37197f103e8e3430d772" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementActivationDisabledWithOccluderParent.md", mode: 0o644, sha256: "8ec1a08bc81d7241a0f88f59c0017bed1e949c394e3147538d2e90cef3954bff" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementCspFrameAncestorsMissing.md", mode: 0o644, sha256: "aa41dc371ecdf99f249461da4e5e41259b5c53e89ce35e429026e85eb5f42482" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementFencedFrameDisallowed.md", mode: 0o644, sha256: "76f137b8d759a180b329e38f127db852b13aac62c291bfc9666dd1aec9cd81e1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementFontSizeTooLarge.md", mode: 0o644, sha256: "be2ebfd49dcb0a2edd9bdd7cbfdc1b27e14c3c1497c3dee6ea8e8b16ed5ae147" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementFontSizeTooSmall.md", mode: 0o644, sha256: "5064caf9e7d631570cc2c0a823f23d67a1f574f60020521b9ab5ab13aac9c8b5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementGeolocationDeprecated.md", mode: 0o644, sha256: "0a769e2074573c9518d47b777ba4488d9fdccd30fdda184b62a80e931d97d43a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementInsetBoxShadowUnsupported.md", mode: 0o644, sha256: "7d1d9468f341cbb98424227690b353a29e4762865fdf1d03fcc1b34e700b0cbd" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementInvalidDisplayStyle.md", mode: 0o644, sha256: "1805c75cd2af9c70009343329276b0ede5d29e984a4f0f503cb0107771bea530" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementInvalidSizeValue.md", mode: 0o644, sha256: "2f500c7e0a060dc6c1f65316633697bdcf893fff03246834163f48cb20e330d2" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementInvalidType.md", mode: 0o644, sha256: "ab9fc438920f813d3f384b445eb7e79a42b8d8f34046374a978dc5aa22ea4d55" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementInvalidTypeActivation.md", mode: 0o644, sha256: "108e049acb0262613d60e58da958ef79cdb2d4719a67010700fb1f5f0cc42aa1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementLowContrast.md", mode: 0o644, sha256: "2bbca6655ae900716815b7cc4711fd6e457c84ee84085156b1731c5d7600c75f" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementNonOpaqueColor.md", mode: 0o644, sha256: "9070fbd70e8698b397b8e165875c46f0b53f68f74558623f8dfb010ae28789b1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementPaddingBottomUnsupported.md", mode: 0o644, sha256: "a57265b2bb2114c5616d4ff22b8ff2689adb9b605314c7c79e1eef01f38c8264" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementPaddingRightUnsupported.md", mode: 0o644, sha256: "673eeef424d19abd2bff15e77c848b1caf8b766e9ee5afce68e6b2f69fb9f73c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementPermissionsPolicyBlocked.md", mode: 0o644, sha256: "febf50b4de141accd754b527af5fb4716cee032a9b3a7db907698fd38598c6f2" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementRegistrationFailed.md", mode: 0o644, sha256: "0dc0948932d2d0187e2feafdfe3e16be9d84dc5c0a1d468f2d8a9c000aadbf5f" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementRequestInProgress.md", mode: 0o644, sha256: "7278066196dc14e39b4bd849a91efa03dd12c10aa4a4bfc1086a89d94aaee5a3" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementSecurityChecksFailed.md", mode: 0o644, sha256: "a0558f596528bd45ead9b577925b2b09d281632a1ecd38abdadc8cd53ef2ec5b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementTypeNotSupported.md", mode: 0o644, sha256: "065ac91850cf35e4be91645c5d8334171c7e94d9692d2e52c0aa92de1a71ad97" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/permissionElementUntrustedEvent.md", mode: 0o644, sha256: "a0097b665e8b21f3e7cc33d153160c946957d2f148cbae42addb459b8f897771" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/placeholderDescriptionForInvisibleIssues.md", mode: 0o644, sha256: "6e8278328eb33c1ee4c81852d023efee81e8693c921f108e7fcbe7110b6b7c37" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/propertyRuleInvalidNameIssue.md", mode: 0o644, sha256: "8e2233e96a1c8ab25e6550d991e9c9d0c4999d42f5550e6bc12da6aa36268da2" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/propertyRuleIssue.md", mode: 0o644, sha256: "db80a66f32437454cda966140bfc0f6782c5dc418916b0bbd16f311fc6756288" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/selectElementAccessibilityDisallowedOptGroupChild.md", mode: 0o644, sha256: "4921aaa991b1d00cb56fe0139fe30dd1411ca3f4aa08967089f1ff9f7c127f9e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/selectElementAccessibilityDisallowedSelectChild.md", mode: 0o644, sha256: "7a181df4b1e9ac687f390b9379cbe5c2ade75cff9e14cb626585f9ff496a59ad" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/selectElementAccessibilityInteractiveContentAttributesSelectDescendant.md", mode: 0o644, sha256: "bbf862d9dad99ca6914034fede0d6b827c7b39926f401b1a257dbef6b58f7ab4" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/selectElementAccessibilityInteractiveContentLegendChild.md", mode: 0o644, sha256: "53c97ae6a5b4fae7dc960af02db48333b7fecb9b15b7a52b033cd59f79db3232" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/selectElementAccessibilityInteractiveContentOptionChild.md", mode: 0o644, sha256: "0d4ca993f9c773ab864a19bfa7573d9747f5ec6c58204d660e3a8f11fd3d311b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/selectElementAccessibilityNonPhrasingContentOptionChild.md", mode: 0o644, sha256: "1a93d4d845a1489e3c4835759434ccd66c04edbf1eda10f4ee3bd6a67d3cac5d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/selectivePermissionsIntervention.md", mode: 0o644, sha256: "04a4914d99fb6364f867adba8c0ef5167050c483889d3af477ea5f2dd936e89b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedArrayBuffer.md", mode: 0o644, sha256: "ce2da205337730f60f9758f5e19a55ebd510cbcb41b6aec6825b6129002798be" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryUseErrorCrossOriginNoCorsRequest.md", mode: 0o644, sha256: "8f70638d5c9e9b26e9651ea9282cb55a062623df62db0ff15eeb0f67ee430518" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryUseErrorDictionaryLoadFailure.md", mode: 0o644, sha256: "679afe8f7cf9f3fa74380f7be129f8cc59ca82459e3ff6c0433e25cf0ded3533" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryUseErrorMatchingDictionaryNotUsed.md", mode: 0o644, sha256: "70387b46127927bcc869f3c72799009a0612308efaba4f4c358796aa2daf2103" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryUseErrorUnexpectedContentDictionaryHeader.md", mode: 0o644, sha256: "bfa10f24ce206405a138400f09f5d472f3d436ffb8223cd61d4a4989824f819f" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorCossOriginNoCorsRequest.md", mode: 0o644, sha256: "f216a90ee4b56faa0dbe4852380652624ea78a63f2830df96201b59fa5ecd27e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorDisallowedBySettings.md", mode: 0o644, sha256: "79838155338d912d6489e89160259a39cd35a80010b7cac647b6691c045b5d07" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorExpiredResponse.md", mode: 0o644, sha256: "f6ab8406d5ece7107ceb19382d8296f7d1d33a86cfbb8ddcc7104867f73d8b7f" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorFeatureDisabled.md", mode: 0o644, sha256: "004da53f82df820650ce3ec29f2597dc30f2fc1b2d38394d1b7b9d85099938dd" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorInsufficientResources.md", mode: 0o644, sha256: "5639d01f050cf720d625e1bb1c39c58c047346f945d0ed8ba9324e45ebe5b4d6" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorInvalidMatchField.md", mode: 0o644, sha256: "a05195c09633c501f833bef808e79e3ee092449e0138946d93db49e96f3c4fdd" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorInvalidStructuredHeader.md", mode: 0o644, sha256: "ac217e95c664f24e0b07800098f435a6a03e79d1936afe03ee934436e628a738" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorInvalidTTLField.md", mode: 0o644, sha256: "d82a2fef3b1e5b24113ccd860241dbc91e6f69074ac52f588758db5b332d2e6e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNavigationRequest.md", mode: 0o644, sha256: "65bae063fb5f04bae93ee911c0d7e98ee94f9ec25f92111b2cc623ad9ee5e949" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNoMatchField.md", mode: 0o644, sha256: "5f79e6502e160c9a0314c65a2400746f622e4f77351f578da378f06839462a58" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNonIntegerTTLField.md", mode: 0o644, sha256: "1e9f50eab73847e93606125f0ada72880605fabe643bce78723d73b108196696" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNonListMatchDestField.md", mode: 0o644, sha256: "a4ed1b68b35712b9faf37ea4ab65886b56b4c5dbe38e83132c4f5b55d5a383b0" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNonSecureContext.md", mode: 0o644, sha256: "05967322f1276d5c9118002c40db404d4d25faea667773fc4da77c118f40a4a7" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNonStringIdField.md", mode: 0o644, sha256: "15e917c50820c54bbce9001e0a902b6bea3248cf50e03d7fba5557691123be20" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNonStringInMatchDestList.md", mode: 0o644, sha256: "06339e2c226148f79598b22f3dc75a5428c13c280944dbaf08165aae5ef53b42" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNonStringMatchField.md", mode: 0o644, sha256: "70ca0b73f628718a040ce61c58317cafc07f8bd99fc69a75657d2c04aa75e778" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorNonTokenTypeField.md", mode: 0o644, sha256: "9c1b26613feaa0ff7419aeaff68ebec250f88c128f330789652b2d11c18567c6" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorRequestAborted.md", mode: 0o644, sha256: "d756b261280a632fbadc83619639e72d4c4f0ac62659d5311bdce3ce57c81ae4" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorShuttingDown.md", mode: 0o644, sha256: "5b535c320f04e9070d114b8611abb705ea506ba56c751d8a88aa61e1edf8f3e7" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorTooLongIdField.md", mode: 0o644, sha256: "1c6fb6b1cfeb31363b0830ffd78321901671827468da1cfa4a2d2e2883aae552" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sharedDictionaryWriteErrorUnsupportedType.md", mode: 0o644, sha256: "ba2b6018786a9f13650f202872dbdbfb27e95a36c37212b88205e3a6ebdc8edd" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriInvalidSignatureHeader.md", mode: 0o644, sha256: "65d40e74ca153564956b72e5f3bf5bf0986587c04e5497f04a3a7ceef4d7a699" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriInvalidSignatureInputHeader.md", mode: 0o644, sha256: "6c0ed05252a5e461a3e57d68425112d6f25e14cf454d0627503295970fb5224f" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriMissingSignatureHeader.md", mode: 0o644, sha256: "92a662b426d4469789b83de1e12dec2311523c43ceae1712abcedf228bad561a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriMissingSignatureInputHeader.md", mode: 0o644, sha256: "18850b5d1fc83df897c1eddab9bf0fd3ad692a6d46ba669edf8e04c6fb82e6ca" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureHeaderValueIsIncorrectLength.md", mode: 0o644, sha256: "0de7b120ad9aed2956a352c116a09870c32cf3fa7e6f52602df6e07117e0484a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureHeaderValueIsNotByteSequence.md", mode: 0o644, sha256: "2382f16ff46c3c7153d5f0f9305c10bd472b4319bf6a02f9a750435ccfe02318" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureHeaderValueIsParameterized.md", mode: 0o644, sha256: "622608c759ed5438b51949409258ab38cfeac452f6cef9e8088789361ad79e39" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderInvalidComponentName.md", mode: 0o644, sha256: "60787792d172e5b63e60c5b7f078b79c536cf11281e176eba486e340097070c7" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderInvalidComponentType.md", mode: 0o644, sha256: "e81112f2f175287221546bebf95adcb2d10b2f2d52ae0f7cde280193547e3606" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderInvalidDerivedComponentParameter.md", mode: 0o644, sha256: "86186b3f3aed2dd73e60bb4b61c0b33137245d8e9c7cd8c459a02ed1faf68039" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderInvalidHeaderComponentParameter.md", mode: 0o644, sha256: "a30a096395663597b7f29b489a50b71b1bfb1e881f02c1a7a820bf83de7721b9" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderInvalidParameter.md", mode: 0o644, sha256: "2216efdaecf844efe064e4fcacc89f8d508d01b04720f342a4961ef4a01cb755" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderKeyIdLength.md", mode: 0o644, sha256: "7b421d1e4d37c9aa2fa9333bbdcbebf4610cd19116c8e71651f506b234a22938" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderMissingLabel.md", mode: 0o644, sha256: "ce5d5c52f678ccdf325ebe6e82cf2e7ef3fc7978e3c8ff60af8c38b14ce7d3f1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderMissingRequiredParameters.md", mode: 0o644, sha256: "7ce2ffe5bbc056ba668c11e20d0eee0bcefd50965c069a5c2d42b2f0a3750c1b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderValueMissingComponents.md", mode: 0o644, sha256: "2e47a2e13df47efd893fed9f074dd0028d3a1635823b184ae1613b68ea875a8e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriSignatureInputHeaderValueNotInnerList.md", mode: 0o644, sha256: "d1a9477d8c9bd2e9b138d4acd5dd9e52cfd84662400dee5052ce7f7f23eb4216" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriValidationFailedIntegrityMismatch.md", mode: 0o644, sha256: "f39a7ecf43a93acda191786073f1cb561da9eabd7b6764d0c9a31847095226e1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriValidationFailedInvalidLength.md", mode: 0o644, sha256: "db78c6e78d2c06b41eac7569e804937344a0561a24b5499ef0bd3987c78d55bc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriValidationFailedSignatureExpired.md", mode: 0o644, sha256: "349a320839b818ce25af4609dbae6ecad4616be730a3fa71c0bcd208a5c3bf39" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/sriValidationFailedSignatureMismatch.md", mode: 0o644, sha256: "fc6c414545c705b2ec67e9725f7ad0f1029cac12aa4d066db2d4297dd0e8bed7" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/stylesheetLateImport.md", mode: 0o644, sha256: "c56d7a93425c9de98e5a3e3bac99af92c23253484b2e538226648ab4a101bcbc" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/stylesheetRequestFailed.md", mode: 0o644, sha256: "4e27065ffadffd1630c762f189bc7ed842c52a1631225ae8baffd4598135f900" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/summaryElementAccessibilityInteractiveContentSummaryDescendant.md", mode: 0o644, sha256: "9fd7b4cc3e127912e961450bce4ee4662ad76cd28ea1317f32214005794c34af" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/unencodedDigestIncorrectDigestLength.md", mode: 0o644, sha256: "65a8113b347d2ffd072fa7b78975f3f7f4f21ae0704f7b090ce4b0f9cd4b5540" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/unencodedDigestIncorrectDigestType.md", mode: 0o644, sha256: "09b3830669152efb140606c2bd72a490b0b01f0600bb2f69cd0cefa124a7364b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/unencodedDigestMalformedDictionary.md", mode: 0o644, sha256: "0e3dcfe37a14d1d215e58c05eb5b0cb7e00e4fab8ec52af763737693030279e1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/issue-descriptions/unencodedDigestUnknownAlgorithm.md", mode: 0o644, sha256: "53b2a07c47d7a5e200a55f941d4b604393c6319afb826b3046bc79d5945c6b73" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/third_party/lighthouse-devtools-mcp-bundle.js", mode: 0o644, sha256: "7682ff891dfa484a9fb1bec0bde5c0c19d9aeb90c22752e09bf2b22bad0ea651" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/ToolDefinition.js", mode: 0o644, sha256: "99a99804c660b47d469b99d60bc5ce5c21571b6bd69ceea19da289dbbc5793c5" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/categories.js", mode: 0o644, sha256: "ae43237ae6f505fe3d17db5e683e64457c6556006c3629aa7fd4478cba1dae16" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/console.js", mode: 0o644, sha256: "c53e98a3fb97202b81ba46bb3420bc0e0b0691d14bdd86839de51e47f4543b25" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/emulation.js", mode: 0o644, sha256: "6bd13c4d0f99b357eb28ee0754e82987c67eeba271523598a6b56d43d4d3929c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/extensions.js", mode: 0o644, sha256: "df2a7bc09977066cb7266e5aaab66b5497ad646bfe99ddc965fba4ccf04de38b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/input.js", mode: 0o644, sha256: "924710a7a0d4de836ba477bf35e13a37eeee72879b29408fa544c0a8373da0e9" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/lighthouse.js", mode: 0o644, sha256: "8bc86eb6c95f643f6ba8c6eb22238a0d96decd9f6c8b85643bbf46eb1beb873e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/memory.js", mode: 0o644, sha256: "a1c27adb3eeddd51f627001a27c56786fc085cdfafddcf5580b12bfd8c4e45c6" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/network.js", mode: 0o644, sha256: "09e9e70b9d050101c08857acc115f885f5f68e4bda4fb4e7e4e829b53eca9e16" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/pages.js", mode: 0o644, sha256: "50983bd1b2f01ffa3273de3353e28fd44795d026f2b62bcc783e19156ee0147d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/performance.js", mode: 0o644, sha256: "af6a8522bca21e3d3b1ed59e54463f003d5201d260f3e6e35342534d74c0051d" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/pwa.js", mode: 0o644, sha256: "8c9819b7b7fbed430d42316639cb118f5bea19fa4b3ec769da54d50a8b08c030" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/screencast.js", mode: 0o644, sha256: "600c337ffcb5a67a5b77c21180d610a1583773bf2f19fdaa1742e67a76e64f1a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/screenshot.js", mode: 0o644, sha256: "dd300be39bbba7bd7fd094c1c3a50aee767ff3f301f2716d66b0fe01b1318065" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/script.js", mode: 0o644, sha256: "99a0a8c40209c71fb7ca2822fa7150f0550d76a4c032d465e927456501093279" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/slim/tools.js", mode: 0o644, sha256: "b5e79060cb4f11024145f2be87f0d327dcd8672f2db0c7e5f956328bdb65185a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/snapshot.js", mode: 0o644, sha256: "d48d0b8199d0a423f899fb706ef483854d6846833f31d566bfb37891a3e3fc5c" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/thirdPartyDeveloper.js", mode: 0o644, sha256: "383684e68e2277ccdf2a5d2741498d2c50885c34f25f3e5b129459e2301f4166" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/tools.js", mode: 0o644, sha256: "a0ec03e765330fe0a43153620610af4baafbc6c9dfb54ae2456b74b43f75f1cf" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/tools/webmcp.js", mode: 0o644, sha256: "c7548876413eab203aad1792bdce6f8185cff92ba4c0bc8337c754c5c8edd29e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/types.js", mode: 0o644, sha256: "501b149ac60d5de89e4a5ed419ed871e8e6bc8fe41c9438c1f8a4cc13ad1f689" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/WaitForHelper.js", mode: 0o644, sha256: "36d3abdabd07462b6af80eb983ebebb04e325ad707268cfcea879e663d958a97" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/bytes.js", mode: 0o644, sha256: "140ff0c843ec3b86f55b6fae93c18e9282e8a1590c65aed2a298d49fd92ce085" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/check-for-updates.js", mode: 0o644, sha256: "e8d5efcf2dd02ec58a8f0352a90344c8fd12229d5f48b2822bea6ebb2017a9cb" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/files.js", mode: 0o644, sha256: "ab671ba688dae27812068e4d34f7635993da1224c34d6fd0c83a9b2af7db2e16" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/id.js", mode: 0o644, sha256: "0628f6aded2cf9c19f4b8148edb5aef861105c073b4fdda184aa3dc1609fc317" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/keyboard.js", mode: 0o644, sha256: "9260fee633e3178ca4570601907694e37aef662ebbda38dd72136c96817e440b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/logger.js", mode: 0o644, sha256: "fc2fc98732abe55618d88ce32a727c610fc7e2796333f09d9e9319a42bb8d6df" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/pagination.js", mode: 0o644, sha256: "69de9c7fe65d25c04e83f98f8925b691968cd0921f441489084546ca92240909" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/polyfill.js", mode: 0o644, sha256: "d83f7d108f9eca738ea24888fdc55c4f7dcb0a0f1e16dfe7ff3475fad36d572a" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/utils/url.js", mode: 0o644, sha256: "251ef09ebce499f33e640b3a19b1602321738f4e9d6880e30747a8b4889547c7" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/build/src/version.js", mode: 0o644, sha256: "ff03658d3be60d9ad055f9794f6ee2c7bbebfcfcfdc8b884d2a23083d70c2bef" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/package.json", mode: 0o644, sha256: "592ef654a308edcba5fb3c2b302173650096a9487e4120b96e7adbe830429b9f" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/a11y-debugging/SKILL.md", mode: 0o644, sha256: "159587fc580e6112528bedcd89d8c69a52d2fbb54602f10c71d7d5ec8fdbf299" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/a11y-debugging/references/a11y-snippets.md", mode: 0o644, sha256: "93a02d8889738300461b63da77c1647d4d0156fd9b75107574fbed0a931c20ab" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/chrome-devtools-cli/SKILL.md", mode: 0o644, sha256: "46be445e0fcfac0996da0fc3b167dac4fb195ad7b56155dc34c8c0fea8c0a1b9" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/chrome-devtools-cli/references/installation.md", mode: 0o644, sha256: "e1517c49bfd8f22117fcd2cfb2193e082d0e8d0f96d0675619c346f48a1b6e32" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/chrome-devtools/SKILL.md", mode: 0o644, sha256: "b27f4b6d68f775b744e9718698444e9df7b68444ed375ea7509fd7086e76ca4b" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/cookie-debugging/SKILL.md", mode: 0o644, sha256: "eeb526491ce5de6f3881301886ed9c5a7fe3bd3f328e81ab39ab63510ccb0c60" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/debug-optimize-lcp/SKILL.md", mode: 0o644, sha256: "8898b35108b12f73cef83a08964ffff0ebfad429389ffd42cb49a423025657ae" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/debug-optimize-lcp/references/elements-and-size.md", mode: 0o644, sha256: "a99e9e5f93ad2e5b5b65e84abd2bb220e0560be66cc87059361f1d5f7ef2aed7" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/debug-optimize-lcp/references/lcp-breakdown.md", mode: 0o644, sha256: "c63bb071fa465c41464446100f4afc069118eab9092cbec0b284dd452404a947" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/debug-optimize-lcp/references/lcp-snippets.md", mode: 0o644, sha256: "b54d0c26e9df7eea1e58cc118bbbe1ef2037d097a146603ef31c17fe47a6b8b8" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/debug-optimize-lcp/references/optimization-strategies.md", mode: 0o644, sha256: "786691daf6216f1aacb0e2bafdc08ef8450067a392ab26814337ac9837c048c1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/memory-leak-debugging/SKILL.md", mode: 0o644, sha256: "895127ac55a3f2c4e0ca9be496e84165eee6408637c2bcc5516d69170a8de80e" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/memory-leak-debugging/references/common-leaks.md", mode: 0o644, sha256: "2d41e075d8d22e69bc420a9eb4bc180eb2466669ffd0939c201723d80b2673a1" },
        #{ path: "resources/app.asar.unpacked/node_modules/chrome-devtools-mcp/skills/troubleshooting/SKILL.md", mode: 0o644, sha256: "e534a7845f71cd4c1843d92da3002716af917821b95877bc8e8555d17267e30e" },
        #{ path: "resources/bin/language_server", mode: 0o755, sha256: "dd9737d3744d9f78e3a13be8ce0c7be8ca3f2cbcdaf702842305401dd31511d9", elf: true },
        #{ path: "resources/bin/webm_encoder", mode: 0o755, sha256: "44ef981d5f7d33ff6768d020bac89d6d112e62162a70fc2828866a0c71f306ef", elf: true },
        #{ path: "resources/default_app.asar", mode: 0o644, sha256: "0eb2491b0a9ac94790389d39c09dd5005c6c1f0665842943829bbd0193f6cc4f" },
        #{ path: "snapshot_blob.bin", mode: 0o644, sha256: "b4c7240ceffa99a3a8107f059fa938064307ef79acb99ce1413bc4974da2a7e8" },
        #{ path: "v8_context_snapshot.bin", mode: 0o644, sha256: "907a01d1045c52ef29864f69c147337ff287b4fcfbd815bb3666ded6136777e8" },
        #{ path: "version", mode: 0o644, sha256: "092757b5ce6c0196120820f0661c92f660748495faeef3f43049c33ea65fab4c" },
        #{ path: "vk_swiftshader_icd.json", mode: 0o644, sha256: "c9eef28b6b984fec220ef0abfecc40b502d46946706e47bfe97707027cb818bd" },
    ],
};
ctx.archive = join_path(ctx.downloads, ctx.archive_name);
ctx.tree = join_path(ctx.unpacked, ctx.top);
ctx.app = join_path(ctx.package_root, "lib/antigravity");

fn is_acquired(ctx) {
    if !is_file(ctx.archive) { return needs_work(ctx, "download Antigravity " + ctx.version); }
    verify_sha256(ctx.archive, ctx.sha256);
    ready(ctx)
}

fn acquire(ctx) {
    mkdir(ctx.downloads);
    download(ctx.url, ctx.archive, ctx.sha256);
    ctx
}

fn is_built(ctx) {
    for file in ctx.files {
        let path = join_path(ctx.tree, file.path);
        if !is_file(path) { return needs_work(ctx, "unpack Antigravity " + ctx.version); }
        verify_sha256(path, file.sha256);
    }
    ready(ctx)
}

fn build(ctx) {
    verify_sha256(ctx.archive, ctx.sha256);
    if exists(ctx.unpacked) { rm(ctx.unpacked); }
    mkdir(ctx.unpacked);
    extract(ctx.archive, ctx.unpacked);
    for file in ctx.files {
        verify_sha256(join_path(ctx.tree, file.path), file.sha256);
    }
    ctx
}

fn is_installed(ctx) {
    // Files the carry step rewrites no longer match the upstream digests: they are only looked for.
    for file in ctx.files {
        let path = join_path(ctx.app, file.path);
        if !is_file(path) { return needs_work(ctx, "install Antigravity " + ctx.version); }
        if !file.contains("elf") { verify_sha256(path, file.sha256); }
    }
    let starter = join_path(ctx.package_root, "bin/antigravity");
    if !is_file(starter) { return needs_work(ctx, "install Antigravity " + ctx.version); }
    verify_sha256(starter, STARTER_SHA256);
    for path in ["share/applications/antigravity.desktop", "share/icons/hicolor/512x512/apps/antigravity.png",
                 "lib/ld-linux-x86-64.so.2", "lib/locale", "lib/gconv", "share/glib-2.0/schemas"] {
        if !exists(join_path(ctx.package_root, path)) { return needs_work(ctx, "install Antigravity " + ctx.version); }
    }
    ctx.outputs["package"] = ctx.package_root;
    ready(ctx)
}

fn install(ctx) {
    let prefix = RUNTIME.paths.prefix;
    if type_of(prefix) != "string" { throw "antigravity must be installed with activation: its loader path is the profile's"; }
    let sdk = join_path(RUNTIME.paths.dependencies, "desktop-runtime/sdk");
    if exists(ctx.package_root) { rm(ctx.package_root); }

    // The application tree, without chrome-sandbox (it is not in ctx.files).
    for file in ctx.files {
        let path = join_path(ctx.app, file.path);
        mkdir(dirname(path));
        copy_file(join_path(ctx.tree, file.path), path);
        chmod(path, file.mode);
    }

    // The icon, read out of the uncompressed app.asar.
    let icon = join_path(ctx.package_root, "share/icons/hicolor/512x512/apps/antigravity.png");
    mkdir(dirname(icon));
    shell("tail -c +" + (ctx.icon_offset + 1) + " '" + join_path(ctx.tree, "resources/app.asar") + "' | head -c " + ctx.icon_size + " > '" + icon + "'");
    verify_sha256(icon, ctx.icon_sha256);
    chmod(icon, 0o644);

    // The runtime's data, before the carry step so that its modules and loader programs are rewritten too.
    for rel in ctx.runtime_data {
        let to = join_path(ctx.package_root, rel);
        mkdir(to);
        copy_tree_contents(join_path(sdk, rel), to);
    }
    // glycin runs its loaders by absolute path: the installed ones.
    for conf in glob_list(join_path(ctx.package_root, "share/glycin-loaders/*/conf.d/*")) {
        write_file(conf, replace(replace(read_file(conf), "@LIB@", prefix + "/lib"), "@SHARE@", prefix + "/share"));
    }

    let desktop = join_path(ctx.package_root, "share/applications/antigravity.desktop");
    mkdir(dirname(desktop));
    write_file(desktop, DESKTOP_ENTRY);
    chmod(desktop, 0o644);

    carry_libraries(ctx.package_root, prefix, [join_path(sdk, "lib")]);

    let starter = join_path(ctx.package_root, "bin/antigravity");
    mkdir(dirname(starter));
    write_file(starter, STARTER);
    chmod(starter, 0o755);
    ctx.outputs["package"] = ctx.package_root;
    ctx
}

fn remove(ctx) {
    if exists(ctx.package_root) { rm(ctx.package_root); }
    ctx.outputs = #{};
    ctx
}
