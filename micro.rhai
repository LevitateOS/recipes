const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream micro-2.0.15-linux64-static.tar.gz.sha at the pinned release below.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 6029312,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Edits text in the terminal with familiar keyboard shortcuts and mouse support. It includes syntax highlighting and multiple buffers.",
    homepage: "https://micro-editor.github.io",
    license: "MIT",
    adds: #{ programs: ["micro"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "micro", version: "2.0.15", description: "Terminal text editor" };
const UPSTREAM = #{ github: "micro-editor/micro", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/micro-editor/micro/releases/download/v2.0.15/micro-2.0.15-linux64-static.tar.gz",
        sha256: "267d238eac1e26ed053d13d4d48bd421b87f9eb538b604f0b2f74a85598b6cc2",
    },
};

// One source: its top folder micro-2.0.15/ is left out, so paths start inside it.
const FILES = [
    ["release/micro",                 "bin/micro", 0o755],
    ["release/micro.1",               "share/man/man1/micro.1"],
    ["release/LICENSE",               "share/licenses/micro/LICENSE"],
    ["release/LICENSE-THIRD-PARTY",   "share/licenses/micro/LICENSE-THIRD-PARTY"],
];
