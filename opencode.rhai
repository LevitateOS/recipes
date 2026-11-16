const RECIPE_API = 1;
// opencode v1.19.5 (anomalyco/opencode), Bun-compiled x86_64 Linux CLI, glibc variant (dynamic, glibc <= 2.17).
// Archive SHA-256: the digest GitHub publishes for the release asset (verified against our own download).
// The tarball holds one file, opencode; its digest below was computed from the verified archive.
// libc: this recipe ships the glibc build, and ABOUT.libc says so. Upstream also publishes a musl build,
// opencode-linux-x64-musl.tar.gz, sha256 e8d5be23bf8f3f69bc3206f3311215c049329cd6afa7c06d733987cc2d33b568
// (inner opencode sha256 528058cf8f2a7196ec94dc113052b785f8f94f6802ced3980ad7359369ddacc8), which this recipe does not declare.
// Nothing is compiled. The archive carries no licence file (the project is MIT, see the repository).
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 83886080,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    libc: ["glibc"],
    details: "Runs the opencode coding agent in the terminal, with the model provider of your choice. Needs network access to that provider, and fetches a model catalogue and may download language servers. Upstream can update itself; Recipe manages updates here, so set \"update\": \"disable\" in opencode's global config. This recipe does not write user configuration. Its build is linked against glibc, as LevitateOS has.",
    homepage: "https://opencode.ai",
    license: "MIT",
    adds: #{ programs: ["opencode"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release archive and checks it against the digest GitHub publishes for it.",
        install: "Puts the opencode command in bin.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "opencode", version: "1.19.5", description: "opencode terminal coding agent" };
const UPSTREAM = #{ github: "anomalyco/opencode", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/anomalyco/opencode/releases/download/v1.19.5/opencode-linux-x64.tar.gz",
        sha256: "588310a336fa3b9df36b3f0225b26f679d453efaad0cf3d66c3651ef3ec1647a",
    },
};

// One source holding one file: the source name is left out.
const FILES = [
    ["opencode", "bin/opencode", 0o755],
];
