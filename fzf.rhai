const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream fzf_0.75.0_checksums.txt at the pinned release below.
// Missing licence texts come from the same pinned upstream tag; their SHA-256 values were computed on 2026-11-11.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 2818048,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Filters a list of lines with an interactive fuzzy search. It works with files, command history and other text supplied on standard input.",
    homepage: "https://github.com/junegunn/fzf",
    license: "MIT",
    adds: #{ programs: ["fzf"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "fzf", version: "0.75.0", description: "Interactive fuzzy finder" };
const UPSTREAM = #{ github: "junegunn/fzf", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/junegunn/fzf/releases/download/v0.75.0/fzf-0.75.0-linux_amd64.tar.gz",
        sha256: "0d6640f83582d991cf429754baad64b07e3a4e439a6019670f4b91da1314141c",
    },
    licence: #{
        url: "https://raw.githubusercontent.com/junegunn/fzf/v0.75.0/LICENSE",
        sha256: "a296f423c0d30ce3581435e78e7e36c5fe73984a882d8720c72e713b4593588b",
    },
};

const FILES = [
    ["release/fzf", "bin/fzf", 0o755],
    ["licence",     "share/licenses/fzf/LICENSE"],
];
