const RECIPE_API = 1;
// OpenAI Codex CLI rust-v0.167.2, static-pie musl x86_64 release: runs on both the glibc and musl OS variants.
// Archive SHA-256: the digest GitHub publishes for the release asset (verified against our own download).
// The tarball holds one file, codex-x86_64-unknown-linux-musl; its digest below was computed from the verified archive.
// file(1) checked: ELF 64-bit PIE, static-pie linked. Nothing is compiled. Nothing but the binary is installed:
// the archive carries no licence file (the project is Apache-2.0, see the repository).
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 125829120,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Runs OpenAI's Codex coding agent in the terminal: it reads and edits the files of a project and runs commands on request. It needs an OpenAI or ChatGPT account and network access to OpenAI. Upstream can check for a newer release at startup; Recipe manages updates here, so set check_for_update_on_startup = false in ~/.codex/config.toml. This recipe does not write user configuration.",
    homepage: "https://github.com/openai/codex",
    license: "Apache-2.0",
    adds: #{ programs: ["codex"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream musl release archive and checks it against the digest GitHub publishes for it.",
        install: "Puts the codex command in bin.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "codex", version: "0.167.2", description: "OpenAI Codex terminal coding agent" };
const UPSTREAM = #{ github: "openai/codex", prefix: "rust-v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/openai/codex/releases/download/rust-v0.167.2/codex-x86_64-unknown-linux-musl.tar.gz",
        sha256: "8246e846c550ea21197fcc4067bc270dca895e94ea42ed6a282e6f4e0125b15f",
    },
};

// One source holding one file: the source name is left out.
const FILES = [
    ["codex-x86_64-unknown-linux-musl", "bin/codex", 0o755],
];
