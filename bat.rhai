const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 4259840,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Displays files with syntax highlighting and line numbers. It can show Git changes beside the text.",
    homepage: "https://github.com/sharkdp/bat",
    license: "MIT OR Apache-2.0",
    adds: #{ programs: ["bat"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "bat", version: "0.26.1", description: "File viewer with syntax highlighting" };
const UPSTREAM = #{ github: "sharkdp/bat", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-x86_64-unknown-linux-musl.tar.gz",
        sha256: "0dcd8ac79732c0d5b136f11f4ee00e581440e16a44eab5b3105b611bbf2cf191",
    },
};

// One source: its top folder is left out, so paths start inside it.
const FILES = [
    ["bat",                                   "bin/bat", 0o755],
    ["bat.1",                                 "share/man/man1/bat.1"],
    ["LICENSE-APACHE",                        "share/licenses/bat/LICENSE-APACHE"],
    ["LICENSE-MIT",                           "share/licenses/bat/LICENSE-MIT"],
    ["autocomplete/_bat.ps1",                 "share/bat/completions/_bat.ps1"],
    ["autocomplete/bat.bash",                 "share/bash-completion/completions/bat"],
    ["autocomplete/bat.fish",                 "share/fish/vendor_completions.d/bat.fish"],
    ["autocomplete/bat.zsh",                  "share/zsh/site-functions/_bat"],
];
