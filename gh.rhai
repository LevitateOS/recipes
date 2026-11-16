const RECIPE_API = 1;
// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream gh_2.103.3_checksums.txt at the pinned release below.
// Nothing is compiled.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 17432576,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Works with GitHub issues, pull requests, releases and workflows from the terminal. Network operations require an account and access to GitHub as appropriate.",
    homepage: "https://cli.github.com",
    license: "MIT",
    adds: #{ programs: ["gh"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release and checks it against its SHA-256 digest.",
        install: "Puts gh, its manual pages and its licence in place; nothing is compiled.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "gh", version: "2.103.3", description: "GitHub command-line client" };
const UPSTREAM = #{ github: "cli/cli", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/cli/cli/releases/download/v2.103.3/gh_2.103.3_linux_amd64.tar.gz",
        sha256: "4c806978ffce1cec70853302a56d70ac6da4f19bae7adca4e1a8ab00633dd91d",
    },
};

// One source: its single top folder (gh_2.103.3_linux_amd64/) is left out. The program
// needs its mode; the manual pages go whole.
const FILES = [
    ["bin/gh",              "bin/gh", 0o755],
    ["LICENSE",             "share/licenses/gh/LICENSE"],
    ["share/man/man1/",     "share/man/man1/"],
];
