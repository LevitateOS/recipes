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

// The release tag is only a date, so UPSTREAM cannot give the recipe's form
// (<python version>+<date>). The newest release's SHA256SUMS lists every file,
// among them cpython-<version>+<date>-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz
// for the Python minor line this recipe pins; the answer is what stands
// between "cpython-" and "-x86_64-...".
fn latest() {
    let parts = PACKAGE.version.split(".");
    let head = "cpython-" + parts[0] + "." + parts[1] + ".";
    let tail = "-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz";
    let sums = http_get("https://github.com/astral-sh/python-build-standalone/releases/latest/download/SHA256SUMS");
    for line in sums.split("\n") {
        let name = line.trim().split(" ").pop();
        if name.starts_with(head) && name.ends_with(tail) {
            return name.sub_string(8, name.len() - 8 - tail.len());
        }
    }
    throw "the newest python-build-standalone release lists no " + head + "x file for " + tail;
}

// The run-the-program checks (`python3 --version`, the bundled-modules import)
// are gone: verify only reads. The links are followed, so a broken one fails.
fn verify(out) {
    for path in ["bin/python3.14", "bin/python", "bin/python3", "lib/libpython3.14.so"] {
        if !is_file(join_path(out, path)) { throw "the release has no " + path; }
    }
}
