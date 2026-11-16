const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 4063232,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Displays diffs with syntax highlighting and side-by-side views. It can serve as the pager for Git output.",
    homepage: "https://github.com/dandavison/delta",
    license: "MIT",
    adds: #{ programs: ["delta"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "delta", version: "0.20.1", description: "Syntax-highlighted pager for diffs" };
const UPSTREAM = #{ github: "dandavison/delta" };

const SOURCES = #{
    release: #{
        url: "https://github.com/dandavison/delta/releases/download/0.20.1/delta-0.20.1-x86_64-unknown-linux-musl.tar.gz",
        sha256: "69dcb4043f55c29118f408c6efd30115e0a4e0a6709253343b8c8fa814ab4a31",
    },
};

// One source: its top folder is left out, so paths start inside it.
const FILES = [
    ["delta",   "bin/delta", 0o755],
    ["LICENSE", "share/licenses/delta/LICENSE"],
];
