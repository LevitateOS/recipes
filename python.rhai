const RECIPE_API = 1;
// Archive SHA-256: upstream SHA256SUMS for standalone Python release 20261026.
// The complete relocatable distribution, including extension libraries, is retained.
// The archive's checksum covers its contents; Recipe records each placed file's checksum.
const NEEDS = #{
    outputs: #{ tools: "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 42467328,
    memory_mib: 4096,
    storage_max_objects: 131072,
    timeout_secs: 600,
};

// Build dependencies are hidden library entries until the catalog has a toolchain kind.
const ABOUT = #{
    kind: "library",
    category: "development",
    details: "Provides CPython with its standard library and bundled extension modules for build scripts inside the Recipe sandbox. This standalone distribution uses the shared build image C library.",
    homepage: "https://www.python.org",
    license: "Python-2.0",
    steps: #{
        download: "Downloads the pinned release archive and checks its SHA-256.",
        install: "Publishes the whole distribution as a private tools directory for recipes that name this under build_deps.",
    },
};

const PACKAGE = #{ name: "python", version: "3.14.10+20261026", description: "Self-contained Python interpreter and standard library" };

const SOURCES = #{
    release: #{
        url: "https://github.com/astral-sh/python-build-standalone/releases/download/20261026/cpython-3.14.10%2B20261026-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz",
        sha256: "4d3c16c59ed0802a3d1d34d8bce504b15ceeaff39d62dadecc6a9fa803412aed",
        file: "cpython-3.14.10+20261026-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz",
    },
};

// Everything in the release (its top folder python/ is left out), at the top
// of the tools directory; its links (bin/python, bin/python3,
// lib/libpython3.14.so) come along.
const FILES = [["", ""]];

// The run-the-program checks (`python3 --version`, the bundled-modules import)
// are gone: verify only reads. The links are followed, so a broken one fails.
fn verify(out) {
    for path in ["bin/python3.14", "bin/python", "bin/python3", "lib/libpython3.14.so"] {
        if !is_file(join_path(out, path)) { throw "the release has no " + path; }
    }
}
