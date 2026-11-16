const RECIPE_API = 1;
// Upstream's static x86_64 Linux musl release works on both OS variants. The
// archive's SHA-256 is published with the release. No compiler is involved.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 8388608,
    timeout_secs: 300,
};

// What a front end shows about this recipe: the author's words. Nothing here
// is enforced; NEEDS is.
const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Searches the files under a folder for a text pattern, fast. It skips what .gitignore hides, and binary files, unless told otherwise.",
    homepage: "https://github.com/BurntSushi/ripgrep",
    license: "MIT OR Unlicense",
    adds: #{ programs: ["rg"], menu: [] },
    steps: #{
        download: "Downloads upstream's static release archive and checks it against the digest published with the release.",
        install: "Puts rg, its manual page and its licences in place; nothing is compiled.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "ripgrep", version: "15.2.0", description: "Fast recursive text search with rg" };
const UPSTREAM = #{ github: "BurntSushi/ripgrep" };

const SOURCES = #{
    release: #{
        url: "https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep-15.2.0-x86_64-unknown-linux-musl.tar.gz",
        sha256: "33e15bcf1624b25cdd2a55813a47a2f95dbe126268203e76aa6a585d1e7b149c",
    },
};

// One source: paths are inside it; its single top folder is left out.
const FILES = [
    ["rg",          "bin/rg", 0o755],
    ["doc/rg.1",    "share/man/man1/rg.1"],
    ["COPYING",     "share/licenses/ripgrep/COPYING"],
    ["LICENSE-MIT", "share/licenses/ripgrep/LICENSE-MIT"],
    ["UNLICENSE",   "share/licenses/ripgrep/UNLICENSE"],
];
