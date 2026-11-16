const RECIPE_API = 1;
// Upstream's Linux x86_64 release, published whole as a private tools
// directory. Archive SHA-256: upstream cmake-4.4.5-SHA-256.txt; it covers
// every file in the archive, and Recipe records each placed file's checksum.
const NEEDS = #{
    outputs: #{ tools: "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 74776576,
    memory_mib: 4096,
    storage_max_objects: 131072,
    timeout_secs: 1800,
};

// Build dependencies are hidden library entries until the catalog has a toolchain kind.
const ABOUT = #{
    kind: "library",
    category: "development",
    details: "Configures projects and generates build rules inside the Recipe sandbox. This upstream Linux build uses the shared build image C library.",
    homepage: "https://cmake.org",
    license: "BSD-3-Clause",
    steps: #{
        download: "Downloads the pinned release archive and checks its SHA-256.",
        install: "Publishes the whole release as a private tools directory for recipes that name this under build_deps.",
    },
};

const PACKAGE = #{ name: "cmake", version: "4.4.5", description: "CMake build configuration tools" };
const UPSTREAM = #{ github: "Kitware/CMake", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/Kitware/CMake/releases/download/v4.4.5/cmake-4.4.5-linux-x86_64.tar.gz",
        sha256: "ed85135c5a5135b45e50423cb406dea04ca3338da0b8ef3c9ede963559680be0",
    },
};

// Everything in the release (its top folder cmake-4.4.5-linux-x86_64/ is
// left out), at the top of the tools directory.
const FILES = [["", ""]];

// The run-the-program check (`cmake --version`) is gone: verify only reads.
fn verify(out) {
    for program in ["bin/cmake", "bin/ctest", "bin/cpack"] {
        if !is_file(join_path(out, program)) { throw "the release has no " + program; }
    }
}
