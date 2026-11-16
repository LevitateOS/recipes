const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream SHA256SUMS at the pinned release below.
// Missing licence texts come from the same pinned upstream tag; their SHA-256 values were computed on 2026-11-11.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 37158912,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Copies and synchronises files between local storage and cloud services. It also supports checking file contents and managing remote directories.",
    homepage: "https://rclone.org",
    license: "MIT",
    adds: #{ programs: ["rclone"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "rclone", version: "1.76.0", description: "File synchronisation for cloud storage" };
const UPSTREAM = #{ github: "rclone/rclone", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/rclone/rclone/releases/download/v1.76.0/rclone-v1.76.0-linux-amd64.zip",
        sha256: "b00f00b3266c3764413afe599d3ec316f6f43b3e0ea8a0bc1d186d2133e46df7",
    },
    licence: #{
        url: "https://raw.githubusercontent.com/rclone/rclone/v1.76.0/COPYING",
        sha256: "8cd2e9e750b90a04b7d82dbbca3930c696ae0309d7c10464f90a44f45754cd04",
    },
};

// release: its top folder rclone-v1.76.0-linux-amd64/ is left out.
const FILES = [
    ["release/rclone",   "bin/rclone", 0o755],
    ["release/rclone.1", "share/man/man1/rclone.1"],
    ["licence",          "share/licenses/rclone/COPYING"],
];
