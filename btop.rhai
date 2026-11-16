const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// The archive's digest covers every file in it; nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 1376256,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Shows processor, memory, disk, network and process activity in the terminal. This static release does not include GPU monitoring.",
    homepage: "https://github.com/aristocratos/btop",
    license: "Apache-2.0",
    adds: #{ programs: ["btop"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and checks it against its SHA-256 digest.",
        install: "Puts btop, its licence and its themes in place; nothing is compiled.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "btop", version: "1.4.8", description: "Interactive system resource monitor" };
const UPSTREAM = #{ github: "aristocratos/btop", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/aristocratos/btop/releases/download/v1.4.8/btop-x86_64-unknown-linux-musl.tar.gz",
        sha256: "af589cf82cc9ea9c29ce050b9239a13bef2d1492256d476156e1054a42ce89ad",
    },
};

// One source: its single top folder (btop/) is left out. The binary needs its mode;
// the themes folder goes whole.
const FILES = [
    ["bin/btop",  "bin/btop", 0o755],
    ["LICENSE",   "share/licenses/btop/LICENSE"],
    ["themes/",   "share/btop/themes/"],
];
