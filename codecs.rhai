const RECIPE_API = 1;
// codecs: the full FFmpeg codec library, installed into the system root
// (`recipe --system install codecs`) with a receipt, so it can be removed like
// any other recipe. LevitateOS only: AcornOS (musl) ships Alpine's full FFmpeg
// codecs already, so it needs and gets no such recipe; ABOUT.libc and
// ABOUT.systems say so, and there is no musl source.
//
// Why it exists (docs/desktop-todo.md, decision 4; docs/product-handoff.md,
// section 2.6): the desktop libraries group (desktop-libs) installs Fedora's
// cut-down FFmpeg, libavcodec-free 9.0.2-3.fc45, which leaves out H.264, HEVC
// and most AAC because of patents. Software of that kind is never in the image;
// the user chooses it, and this recipe fetches it from its own upstream.
//
// What it installs, and where it comes from (2026-11-16):
// - RPM Fusion free's `libavcodec-freeworld` 9.0.2-3.fc45 for x86_64,
//   https://download1.rpmfusion.org/free/fedora/releases/45/Everything/x86_64/os/Packages/l/libavcodec-freeworld-9.0.2-3.fc45.x86_64.rpm
//   (the frozen releases/45 tree; it holds the same 9.0.2-3 build the system's
//   libavcodec-free has, so no updates tree is needed). Licence tag GPLv3+.
//   6413044 bytes. SHA-256 of our own download: the package is signed with
//   RPM Fusion's key (V4 RSA/SHA256, key ID d651ff2e) but that signature was
//   not checked and no checksum was published for it, so the pin is trust on
//   first use of the bytes served on 2026-11-16. Fetched by this recipe on the
//   user's machine and never mirrored or redistributed by LevitateOS.
// - Its three kinds of files, placed exactly as the package places them: the
//   library libavcodec.so.63.1.102 and its link libavcodec.so.63 in
//   /usr/lib64/ffmpeg/, the build-id link into it, and
//   /etc/ld.so.conf.d/ffmpeg-lib64.conf, which names /usr/lib64/ffmpeg so the
//   dynamic loader finds this library before the cut-down one in /usr/lib64.
//   Recipe refuses to overwrite a file another package owns, so the library
//   lives in its own folder instead. The loader's cache is rebuilt by Recipe
//   after every system change, which makes the conf file take effect.
// - The libraries the full libavcodec needs on top of the cut-down one. The
//   cut-down libavcodec-free 9.0.2-3.fc45 and libavcodec-freeworld have the
//   same Requires except three libraries, checked with `rpm -qpR` on 2026-11-16:
//   libx264.so.165, libx265.so.217 and libvvenc.so.1.14. Each is pinned here,
//   whole, from RPM Fusion free's frozen releases/45 tree, at its own paths
//   (trust on first use of the bytes served on 2026-11-16, like the first):
//   x264-libs 0.165-10.20250608gitb35605ac.fc45 (660115 bytes, GPL-2.0-or-later
//   and Khronos), x265-libs 4.3-1.fc45 (1474694 bytes, tag "GPLv2+ and BSD"),
//   vvenc-libs 1.14.0-1.fc45 (1400435 bytes, BSD-3-Clause-Clear).
// - libnuma.so.1, which x265-libs needs and no glibc lock has (the numactl in
//   desktop-libs.pins is Alpine's): Fedora's numactl-libs 2.0.19-5.fc45 from
//   dl.fedoraproject.org, 32625 bytes, LGPL-2.1-only and GPL-2.0-only. It is a
//   Fedora package pinned here because this recipe is the only one that needs
//   it. (The library libavcodec also needs, liboapv.so.3, comes from
//   openapv-libs 0.3.0.0-1.fc45, which the base lock already has.)
//   The rest of the chain is in the locks: libstdc++, libgcc and glibc
//   (libmvec). Checked by package name, not by file list: no locked glibc
//   package is named like these four or provides their libraries.
// - The soname is libavcodec.so.63, the one libavformat-free 9.0.2-3 uses
//   (same FFmpeg version and release; this package also provides it and needs
//   libavutil.so.61 and libswresample.so.7 from the -free libraries, which are
//   9.0.2-3 as well).
//
// It must match the system's FFmpeg: the library is for FFmpeg 9.0.2 and the
// -free libraries around it are at that version. When a system release changes
// the FFmpeg in desktop-libs (see desktop-libs.pins), pin the matching
// libavcodec-freeworld build here (version, URL and SHA-256 together) and not
// before: a library of another version next to the system's would break every
// program that uses FFmpeg. The pins of the other libraries follow it.
//
// No UPSTREAM and no latest(): the version is not free to move. It has to
// follow the FFmpeg of the system release, and the only meaningful "newer" is
// what a system release brings.
//
// Hand-written: all of it. No pins file (it is not a group).
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["download1.rpmfusion.org:443", "dl.fedoraproject.org:443"],
    network_max_bytes: 12582912,
    memory_mib: 1024,
    storage_max_objects: 4096,
    timeout_secs: 600,
};

const ABOUT = #{
    kind: "system",
    category: "media",
    libc: ["glibc"],
    systems: ["levitateos"],
    details: "The full FFmpeg codec library, so H.264, HEVC (H.265), AAC and the other formats this build of FFmpeg decodes start to play. They play in the programs that use the system's FFmpeg: Firefox for web video, Qt and KDE players, and the video thumbnails in the file manager. This does not add hardware decoding. Programs that play only through GStreamer need GStreamer's own plug-ins, which this does not bring. The system's own FFmpeg leaves these formats out because they are covered by patents in some countries; whether to install them is your choice, and you are responsible for it where you live. It also adds the libraries the full codec library needs: x264 (H.264 encoding), x265 (HEVC encoding) and vvenc (VVC/H.266 encoding), for programs that encode video through FFmpeg. It is RPM Fusion's libavcodec-freeworld with those libraries and numactl-libs from Fedora, fetched by this recipe from RPM Fusion and Fedora; LevitateOS does not redistribute it. It is open source software (GPL-3.0-or-later and the licences of the added libraries). It is built for exactly the system's FFmpeg version (9.0.2) and must match it: when a system release changes FFmpeg, this recipe is updated to the matching build. Built for glibc and LevitateOS; AcornOS (musl) already ships the full codecs.",
    homepage: "https://rpmfusion.org",
    license: "GPL-3.0-or-later AND GPL-2.0-or-later AND Khronos AND BSD-3-Clause AND BSD-3-Clause-Clear AND LGPL-2.1-only AND GPL-2.0-only",
    adds: #{ programs: [], menu: [] },
    steps: #{
        download: "Downloads RPM Fusion's pinned libavcodec-freeworld, x264-libs, x265-libs and vvenc-libs packages from download1.rpmfusion.org and Fedora's numactl-libs from dl.fedoraproject.org, and checks their SHA-256 values.",
        install: "Unpacks the packages natively into one system tree, without running its scripts, and writes it into the system root with a receipt; the library goes into its own folder, /usr/lib64/ffmpeg, which the dynamic loader prefers.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "codecs", version: "9.0.2-3.fc45", description: "Full FFmpeg codecs: H.264, HEVC, AAC" };

let deps = ["desktop-libs"];

// RPM Fusion free's packages for x86_64 (glibc only, like the system).
const SOURCES = #{
    freeworld: #{
        url: "https://download1.rpmfusion.org/free/fedora/releases/45/Everything/x86_64/os/Packages/l/libavcodec-freeworld-9.0.2-3.fc45.x86_64.rpm",
        sha256: "ec274cdcf948f69a0719ae4300784d17bd96e20258532ef3cfd2f094fea5193b",
        format: "rpm",
        strip: false,
        libc: "glibc",
    },
    x264: #{
        url: "https://download1.rpmfusion.org/free/fedora/releases/45/Everything/x86_64/os/Packages/x/x264-libs-0.165-10.20250608gitb35605ac.fc45.x86_64.rpm",
        sha256: "d8e5e8b6893a38744320890ed9a4ffe4419d1dbf9c47b7947dfe2a7b9775d1cc",
        format: "rpm",
        strip: false,
        libc: "glibc",
    },
    x265: #{
        url: "https://download1.rpmfusion.org/free/fedora/releases/45/Everything/x86_64/os/Packages/x/x265-libs-4.3-1.fc45.x86_64.rpm",
        sha256: "8435ccd1e54ee6acd9dff4ba8042fa849e2a499133b9120867a002314aae7194",
        format: "rpm",
        strip: false,
        libc: "glibc",
    },
    vvenc: #{
        url: "https://download1.rpmfusion.org/free/fedora/releases/45/Everything/x86_64/os/Packages/v/vvenc-libs-1.14.0-1.fc45.x86_64.rpm",
        sha256: "12cfcbcb540fad6c45296011911046a0369671e31f280bea602ee52addb71276",
        format: "rpm",
        strip: false,
        libc: "glibc",
    },
    // Fedora's own package, pinned here because only this recipe needs it.
    numactl: #{
        url: "https://dl.fedoraproject.org/pub/fedora/linux/releases/45/Everything/x86_64/os/Packages/n/numactl-libs-2.0.19-5.fc45.x86_64.rpm",
        sha256: "42169a52b79a9342ee2038cb4c8b09a9d8c459f609edb192dda41a9d689c7390",
        format: "rpm",
        strip: false,
        libc: "glibc",
    },
};

// The four packages whole, at their own paths (etc/ and usr/).
const FILES = [
    ["freeworld/", ""],
    ["x264/", ""],
    ["x265/", ""],
    ["vvenc/", ""],
    ["numactl/", ""],
];
