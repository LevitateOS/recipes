const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// The archive's digest covers every file in it; nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 851968,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Remembers directories you visit and helps you return to them by a short name. It supplies shell integration through its init command.",
    homepage: "https://github.com/ajeetdsouza/zoxide",
    license: "MIT",
    adds: #{ programs: ["zoxide"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and checks it against its SHA-256 digest.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "zoxide", version: "0.10.0", description: "Directory jumping based on usage" };
const UPSTREAM = #{ github: "ajeetdsouza/zoxide", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-x86_64-unknown-linux-musl.tar.gz",
        sha256: "2d93385b99f3e82cf2701609a1bffcad863fbeb75aa3fe7eb6be4d29be68b1ae",
    },
};

// One source: paths are inside the release. The man pages fold into one folder;
// the completions go to five places, so each one is listed.
const FILES = [
    ["zoxide",                              "bin/zoxide", 0o755],
    ["LICENSE",                             "share/licenses/zoxide/LICENSE"],
    ["man/man1/",                           "share/man/man1/"],
    ["completions/README.md",               "share/zoxide/completions/README.md"],
    ["completions/_zoxide",                 "share/zsh/site-functions/_zoxide"],
    ["completions/_zoxide.ps1",             "share/zoxide/completions/_zoxide.ps1"],
    ["completions/zoxide.bash",             "share/bash-completion/completions/zoxide"],
    ["completions/zoxide.elv",              "share/zoxide/completions/zoxide.elv"],
    ["completions/zoxide.fish",             "share/fish/vendor_completions.d/zoxide.fish"],
    ["completions/zoxide.nu",               "share/zoxide/completions/zoxide.nu"],
    ["completions/zoxide.ts",               "share/zoxide/completions/zoxide.ts"],
];
