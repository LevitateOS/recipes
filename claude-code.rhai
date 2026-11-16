const RECIPE_API = 1;
// Claude Code 2.1.323, Bun-compiled x86_64 Linux CLI, glibc variant (dynamic, glibc <= 2.26). A single file, not an archive.
// SHA-256: Anthropic's GPG-signed manifest.json for 2.1.323 (https://downloads.claude.ai/claude-code-releases/2.1.323/manifest.json),
// verified against our own download; the installed file is that same file, so one digest serves as both.
// Proprietary: (c) Anthropic PBC, all rights reserved, subject to Anthropic's Commercial Terms. The recipe fetches the
// file from Anthropic at install time; nothing is redistributed.
// libc: one source per C library (SOURCES, by libc); Recipe fetches only this system's. The musl build is
// .../2.1.323/linux-x64-musl/claude, sha256 8ba3c07a4531a04843048d1ecd4abad2c41fd9a5a52476789a23280ed227d399.
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["downloads.claude.ai:443"],
    network_max_bytes: 398458880,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    libc: ["glibc", "musl"],
    details: "Runs Anthropic's Claude Code coding agent in the terminal. Needs a Claude account or API key and network access to Anthropic. Proprietary software under Anthropic's Commercial Terms. Upstream updates itself; Recipe manages updates here, so set DISABLE_AUTOUPDATER=1 in your environment. This recipe does not change user environment. The build matches the system's C library: glibc on LevitateOS, musl on AcornOS.",
    homepage: "https://claude.com/product/claude-code",
    license: "proprietary (Anthropic Commercial Terms, all rights reserved)",
    adds: #{ programs: ["claude"], menu: [] },
    steps: #{
        download: "Downloads the pinned file from Anthropic and checks it against the digest in Anthropic's signed release manifest.",
        install: "Puts the claude command in bin.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "claude-code", version: "2.1.323", description: "Claude Code terminal coding agent" };
// No UPSTREAM: the release is not on GitHub, and no latest() is written for it.

const SOURCES = #{
    glibc: #{
        url: "https://downloads.claude.ai/claude-code-releases/2.1.323/linux-x64/claude",
        sha256: "604d29a6869409106b6a1110bdadcc8b72e8654a5a865d23258f938a696e348e",
        libc: "glibc",
    },
    musl: #{
        url: "https://downloads.claude.ai/claude-code-releases/2.1.323/linux-x64-musl/claude",
        sha256: "8ba3c07a4531a04843048d1ecd4abad2c41fd9a5a52476789a23280ed227d399",
        libc: "musl",
    },
};

// Each source is one plain file, named by its source name; the entry of the other C library's source is left out with it.
const FILES = [
    ["glibc", "bin/claude", 0o755],
    ["musl", "bin/claude", 0o755],
];
