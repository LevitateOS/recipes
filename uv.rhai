const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream uv-x86_64-unknown-linux-musl.tar.gz.sha256 at the pinned release below.
// Missing licence texts come from the same pinned upstream tag; their SHA-256 values were computed on 2026-11-11.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 21364736,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Manages Python projects, environments and packages. The companion uvx command runs tools in isolated Python environments.",
    homepage: "https://docs.astral.sh/uv",
    license: "MIT OR Apache-2.0",
    adds: #{ programs: ["uv", "uvx"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "uv", version: "0.13.7", description: "Python project and package manager" };
const UPSTREAM = #{ github: "astral-sh/uv" };

const SOURCES = #{
    release: #{
        url: "https://github.com/astral-sh/uv/releases/download/0.13.7/uv-x86_64-unknown-linux-musl.tar.gz",
        sha256: "287491da03f2a785c70fa75b13e1f849918c2f2b5415fe84876b8214eeb792f9",
    },
    licence_apache: #{
        url: "https://raw.githubusercontent.com/astral-sh/uv/0.13.7/LICENSE-APACHE",
        sha256: "c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4",
    },
    licence_mit: #{
        url: "https://raw.githubusercontent.com/astral-sh/uv/0.13.7/LICENSE-MIT",
        sha256: "860e3d7a86b84e6a7012c7a635fc64df475cebc6cce34dfeb73a5982ec58176c",
    },
};

// release: its top folder uv-x86_64-unknown-linux-musl/ is left out.
const FILES = [
    ["release/uv",          "bin/uv", 0o755],
    ["release/uvx",         "bin/uvx", 0o755],
    ["licence_apache",      "share/licenses/uv/LICENSE-APACHE"],
    ["licence_mit",         "share/licenses/uv/LICENSE-MIT"],
];
