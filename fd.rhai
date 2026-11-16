const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 2228224,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Finds files and directories by name with simple defaults. It respects ignore files and can run a command for each match.",
    homepage: "https://github.com/sharkdp/fd",
    license: "MIT OR Apache-2.0",
    adds: #{ programs: ["fd"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "fd", version: "10.5.2", description: "Fast file finder" };
const UPSTREAM = #{ github: "sharkdp/fd", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/sharkdp/fd/releases/download/v10.5.2/fd-v10.5.2-x86_64-unknown-linux-musl.tar.gz",
        sha256: "7e2d07fa2b8807642aaec67b7e2972a9fbe4db26fcb340a7372392db42b26694",
    },
};

// One source: its top folder is left out, so paths start inside it.
const FILES = [
    ["fd",                              "bin/fd", 0o755],
    ["fd.1",                            "share/man/man1/fd.1"],
    ["LICENSE-APACHE",                  "share/licenses/fd/LICENSE-APACHE"],
    ["LICENSE-MIT",                     "share/licenses/fd/LICENSE-MIT"],
    ["autocomplete/_fd",                "share/zsh/site-functions/_fd"],
    ["autocomplete/_fd.ps1",            "share/fd/completions/_fd.ps1"],
    ["autocomplete/_fdfind",            "share/zsh/site-functions/_fdfind"],
    ["autocomplete/fd.bash",            "share/bash-completion/completions/fd"],
    ["autocomplete/fd.fish",            "share/fish/vendor_completions.d/fd.fish"],
    ["autocomplete/fdfind.bash",        "share/bash-completion/completions/fdfind"],
    ["autocomplete/fdfind.fish",        "share/fish/vendor_completions.d/fdfind.fish"],
];
