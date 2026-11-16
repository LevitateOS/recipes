const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream sha256sum.txt at the pinned release below.
// jq source archive (manual and licences only): upstream sha256sum.txt.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 5046272,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Filters and transforms JSON using a small expression language. It can select fields, combine records and format results.",
    homepage: "https://jqlang.org",
    license: "MIT",
    adds: #{ programs: ["jq"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "jq", version: "1.8.2", description: "Command-line JSON processor" };
const UPSTREAM = #{ github: "jqlang/jq", prefix: "jq-" };

const SOURCES = #{
    program: #{
        url: "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-linux-amd64",
        sha256: "b1c22172dd303f3be49e935aa56aa48a8b7a46e0bc838b4997d3bb451495870f",
    },
    docs: #{
        url: "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-1.8.2.tar.gz",
        sha256: "71b8d6e8f5fe81f6c6d0d110e3892251f6ce76ed095abd315e26e6e1193af3af",
    },
};

// Two sources: the program is one plain file; the docs archive's top folder jq-1.8.2/ is left out.
const FILES = [
    ["program",                        "bin/jq", 0o755],
    ["docs/jq.1",                      "share/man/man1/jq.1"],
    ["docs/COPYING",                   "share/licenses/jq/COPYING"],
    ["docs/vendor/oniguruma/COPYING",  "share/licenses/jq/oniguruma-COPYING"],
];
