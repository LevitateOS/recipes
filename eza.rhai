const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Binary archive SHA-256: upstream release notes, sha256sum table.
// Documentation archive SHA-256 values computed from downloads on 2026-11-11; no upstream checksum published.
// Missing licence texts come from the same pinned upstream tag; their SHA-256 values were computed on 2026-11-11.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 1835008,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Lists files with colours, Git status and tree views. It can display permissions, timestamps and other file details.",
    homepage: "https://github.com/eza-community/eza",
    license: "EUPL-1.2 AND MIT AND CC-BY-4.0",
    adds: #{ programs: ["eza"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release, its manual pages, completions and licence texts, checking every SHA-256.",
        install: "Puts eza, its manual pages, shell completions and licences in place; nothing is compiled.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "eza", version: "0.23.5", description: "Directory listing with file details" };
const UPSTREAM = #{ github: "eza-community/eza", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/eza-community/eza/releases/download/v0.23.5/eza_x86_64-unknown-linux-musl.tar.gz",
        sha256: "e06eebab74b73d6b7d51a796a353824b001bea82df077706382e100815d28904",
    },
    man: #{
        url: "https://github.com/eza-community/eza/releases/download/v0.23.5/man-0.23.5.tar.gz",
        sha256: "cbdae2ad79ae0ef1fd6a06f4644c90cef79a56353bc3bb7cf4663bb2831420f9",
    },
    completions: #{
        url: "https://github.com/eza-community/eza/releases/download/v0.23.5/completions-0.23.5.tar.gz",
        sha256: "8ca5a250d28c3c7ebd0077aca203701a17d1ea7c92621d9e274b93965e3c9291",
    },
    licence: #{
        url: "https://raw.githubusercontent.com/eza-community/eza/v0.23.5/LICENSE.txt",
        sha256: "57fb42fbcd0b037ce528ed8f72f1ec095d67bc6825ecf1448ff39be1fe68a4b4",
    },
    licence_cc: #{
        url: "https://raw.githubusercontent.com/eza-community/eza/v0.23.5/LICENSES/CC-BY-4.0.txt",
        sha256: "d557539df68e771cc1eedcc91d13f70fca930e508d11eedcafa4b15db49e3744",
    },
    licence_eupl: #{
        url: "https://raw.githubusercontent.com/eza-community/eza/v0.23.5/LICENSES/EUPL-1.2.txt",
        sha256: "57fb42fbcd0b037ce528ed8f72f1ec095d67bc6825ecf1448ff39be1fe68a4b4",
    },
    licence_mit: #{
        url: "https://raw.githubusercontent.com/eza-community/eza/v0.23.5/LICENSES/MIT.txt",
        sha256: "b85dcd3e453d05982552c52b5fc9e0bdd6d23c6f8e844b984a88af32570b0cc0",
    },
};

// Each archive's single top folder (target/) is left out. Every entry goes to its own
// place, so each is listed.
const FILES = [
    ["release/eza",                                          "bin/eza", 0o755],
    ["man/man-0.23.5/eza.1",                                 "share/man/man1/eza.1"],
    ["man/man-0.23.5/eza_colors-explanation.5",              "share/man/man5/eza_colors-explanation.5"],
    ["man/man-0.23.5/eza_colors.5",                          "share/man/man5/eza_colors.5"],
    ["completions/completions-0.23.5/_eza",                  "share/zsh/site-functions/_eza"],
    ["completions/completions-0.23.5/_eza.ps1",              "share/eza/completions/_eza.ps1"],
    ["completions/completions-0.23.5/eza",                   "share/bash-completion/completions/eza"],
    ["completions/completions-0.23.5/eza.fish",              "share/fish/vendor_completions.d/eza.fish"],
    ["completions/completions-0.23.5/eza.nu",                "share/eza/completions/eza.nu"],
    ["licence",                                              "share/licenses/eza/LICENSE.txt"],
    ["licence_cc",                                           "share/licenses/eza/CC-BY-4.0.txt"],
    ["licence_eupl",                                         "share/licenses/eza/EUPL-1.2.txt"],
    ["licence_mit",                                          "share/licenses/eza/MIT.txt"],
];
