const RECIPE_API = 1;
// Claude Code 2.1.323, Bun-compiled x86_64 Linux CLI, glibc variant (dynamic, glibc <= 2.26). A single file, not an archive.
// SHA-256: Anthropic's GPG-signed manifest.json for 2.1.323 (https://downloads.claude.ai/claude-code-releases/2.1.323/manifest.json),
// verified against our own download; the installed file is that same file, so one digest serves as both.
// Proprietary: (c) Anthropic PBC, all rights reserved, subject to Anthropic's Commercial Terms. The recipe fetches the
// file from Anthropic at install time; nothing is redistributed.
// libc: one source per C library (SOURCES, by libc); Recipe fetches only this system's. The musl build is
// .../2.1.323/linux-x64-musl/claude, sha256 8ba3c07a4531a04843048d1ecd4abad2c41fd9a5a52476789a23280ed227d399.
// Updater: the real program is placed at lib/claude-code/claude and bin/claude is a small launcher that exports
// DISABLE_AUTOUPDATER=1 (stops the background update check) and DISABLE_UPDATES=1 (also blocks `claude update` and
// `claude install`, so Recipe is the only way the program changes), then execs it. Both variables are documented at
// https://code.claude.com/docs/en/setup#disable-auto-updates ; the documented settings.json `env` key would write
// into the user's home, so the launcher is used instead. Packages hold no symlinks, so the launcher follows its own
// link (the profile's bin/claude links into the package) the way pi.rhai does.
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
    details: "Runs Anthropic's Claude Code coding agent in the terminal. Needs a Claude account or API key and network access to Anthropic. Proprietary software under Anthropic's Commercial Terms. Upstream updates itself; the claude command installed here is a launcher that turns the program's own updater off (DISABLE_AUTOUPDATER=1, DISABLE_UPDATES=1), and Recipe updates the program (recipe update claude-code). This recipe does not change user environment or configuration. The build matches the system's C library: glibc on LevitateOS, musl on AcornOS.",
    homepage: "https://claude.com/product/claude-code",
    license: "proprietary (Anthropic Commercial Terms, all rights reserved)",
    adds: #{ programs: ["claude"], menu: [] },
    steps: #{
        download: "Downloads the pinned file from Anthropic and checks it against the digest in Anthropic's signed release manifest.",
        build: "Writes the launcher bin/claude, which turns the program's own updater off; nothing is compiled.",
        install: "Puts the program under lib/claude-code and the launcher in bin.",
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
// The program goes to lib/claude-code/claude; bin/claude is the launcher `build` writes.
const FILES = [
    ["glibc", "lib/claude-code/claude", 0o755],
    ["musl", "lib/claude-code/claude", 0o755],
];

const LAUNCHER = `#!/bin/sh
set -eu
tool_root=$(CDPATH= cd -- "$(dirname -- "$(readlink -f -- "$0")")/.." && pwd)
export DISABLE_AUTOUPDATER=1
export DISABLE_UPDATES=1
exec "$tool_root/lib/claude-code/claude" "$@"
`;

fn build(src, out) {
    let launcher = join_path(out, "bin/claude");
    mkdir(dirname(launcher));
    write_file(launcher, LAUNCHER);
    chmod(launcher, 0o755);
}
