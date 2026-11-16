const RECIPE_API = 1;
// RPM SHA-256 values: Rocky 10.2 AppStream/BaseOS primary repository metadata.
// These C++ components match the shared compiler image GCC 14.3.1-4.4.el10.
// This is a native x86_64 extension of that image, not a replacement C toolchain.
// COPYING3 and COPYING.RUNTIME are pinned upstream texts, hashed on 2026-11-11.
// Each archive's checksum covers its contents; Recipe records each placed file's checksum.
// Retain GCC image support paths after relocating the C++ frontend.
const CXX_LAUNCHER = `#!/bin/sh
set -eu
tool_bin=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec "$tool_bin/g++-real" -B/usr/libexec/gcc/x86_64-redhat-linux/14/ -B/usr/lib/gcc/x86_64-redhat-linux/14/ "$@"
`;
const NEEDS = #{
    outputs: #{ tools: "directory" },
    network: ["dl.rockylinux.org:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 22937600,
    memory_mib: 4096,
    storage_max_objects: 131072,
    timeout_secs: 600,
};

// Build dependencies are hidden library entries until the catalog has a toolchain kind.
const ABOUT = #{
    kind: "library",
    category: "development",
    details: "Adds the matching Rocky GCC C++ frontend, standard library and headers to the shared Recipe build image. It requires that image to provide GCC 14.3.1, its C headers and linker.",
    homepage: "https://gcc.gnu.org",
    license: "GPL-3.0-or-later AND (GPL-3.0-or-later WITH GCC-exception-3.1)",
    steps: #{
        download: "Downloads the pinned RPMs and licence texts and checks their SHA-256 values.",
        build: "Checks the shared GCC 14.3.1 image, drops the i686 libraries and replaces the C++ drivers with launchers.",
        install: "Publishes a private tools directory for recipes that name this under build_deps.",
    },
};

// No UPSTREAM and no latest(): the version is not free to move. It has to equal
// the GCC of the build image (Rocky Linux's gcc 14.3.1-4.4.el10), so it moves
// only when the image does.
const PACKAGE = #{ name: "gxx", version: "14.3.1-4.4.el10", description: "C++ frontend and headers for the GCC 14 build image" };

// The three RPMs keep their top folder (usr/): they merge into one tree.
const SOURCES = #{
    frontend: #{
        url: "https://dl.rockylinux.org/pub/rocky/10.2/AppStream/x86_64/os/Packages/g/gcc-c++-14.3.1-4.4.el10.x86_64.rpm",
        sha256: "3c7fdc3cef30a2f293e6f02e4fbf71019e9ff6db43e00e04d11127ea4363f6c4",
        format: "rpm",
        strip: false,
    },
    headers: #{
        url: "https://dl.rockylinux.org/pub/rocky/10.2/AppStream/x86_64/os/Packages/l/libstdc++-devel-14.3.1-4.4.el10.x86_64.rpm",
        sha256: "7ce2f001978b0891c83c011e70443d318beaaf289cc670ae09d7aa25f6cab359",
        format: "rpm",
        strip: false,
    },
    runtime: #{
        url: "https://dl.rockylinux.org/pub/rocky/10.2/BaseOS/x86_64/os/Packages/l/libstdc++-14.3.1-4.4.el10.x86_64.rpm",
        sha256: "342c4128ad2e04b518871c3029132405d0a8a36a94c0449262d08cc8350e62ba",
        format: "rpm",
        strip: false,
    },
    copying3: #{
        url: "https://raw.githubusercontent.com/gcc-mirror/gcc/releases/gcc-14.3.0/COPYING3",
        sha256: "8ceb4b9ee5adedde47b31e975c1d90c73ad27b6b165a1dcd80c7c545eb65b903",
    },
    copying_runtime: #{
        url: "https://raw.githubusercontent.com/gcc-mirror/gcc/releases/gcc-14.3.0/COPYING.RUNTIME",
        sha256: "9d6b43ce4d8de0c878bf16b54d8e7a10d9bd42b75178153e3af6a815bdc90f74",
    },
};

// The three RPMs whole (usr/...), then the two licence texts.
const FILES = [
    ["frontend/", ""],
    ["headers/", ""],
    ["runtime/", ""],
    ["copying3", "share/licenses/gxx/COPYING3"],
    ["copying_runtime", "share/licenses/gxx/COPYING.RUNTIME"],
];

fn build(src, out) {
    if trim(exec_output("gcc", ["-dumpfullversion"])) != "14.3.1" ||
        trim(exec_output("gcc", ["-dumpmachine"])) != "x86_64-redhat-linux" {
        throw "gxx requires the shared Rocky x86_64 GCC 14.3.1 compiler image";
    }
    if exists(join_path(out, ".recipe-target-metadata.json")) {
        rm(join_path(out, ".recipe-target-metadata.json"));
    }
    // The native toolchain does not include the i686 development libraries.
    rm(join_path(out, "usr/lib/gcc/x86_64-redhat-linux/14/32"));
    exec_checked("mv", [join_path(out, "usr/bin/g++"), join_path(out, "usr/bin/g++-real")]);
    for name in ["usr/bin/c++", "usr/bin/x86_64-redhat-linux-g++", "usr/bin/x86_64-redhat-linux-c++"] {
        rm(join_path(out, name));
    }
    for name in ["usr/bin/g++", "usr/bin/c++", "usr/bin/x86_64-redhat-linux-g++", "usr/bin/x86_64-redhat-linux-c++"] {
        write_file(join_path(out, name), CXX_LAUNCHER);
        chmod(join_path(out, name), 0o755);
    }
}

// The link checks are gone with the checksum list: verify only reads files.
fn verify(out) {
    for path in ["usr/bin/g++", "usr/bin/g++-real", "usr/bin/c++", "usr/lib64/libstdc++.so.6",
                 "usr/lib/gcc/x86_64-redhat-linux/14/libstdc++.so", "usr/libexec/gcc/x86_64-redhat-linux/14/cc1plus",
                 "share/licenses/gxx/COPYING3", "share/licenses/gxx/COPYING.RUNTIME"] {
        if !is_file(join_path(out, path)) { throw "the toolchain has no " + path; }
    }
}
