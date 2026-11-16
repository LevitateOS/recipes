const RECIPE_API = 1;
// pi v1.5.2 (earendil-works/pi, Mario Zechner's coding agent), x86_64 Linux release: a dynamic glibc Bun binary (glibc <= 2.17)
// with the files it reads at run time next to it (package.json, docs, themes, export-html, photon_rs_bg.wasm and
// native/linux/prebuilds/linux-x64/linux-platform-x11.node). Upstream publishes a glibc build only.
// Archive SHA-256: upstream SHA256SUMS at the pinned release, verified against our own download; nothing is compiled.
// Packages may not hold symlinks, so the tree lives whole under lib/pi/ and bin/pi is a small launcher, the same
// pattern go.rhai uses, but following its own symlink first (the profile's bin/pi links into the package): it sets
// PI_PACKAGE_DIR (documented upstream) and execs lib/pi/pi, whose real path keeps the binary beside its assets.
// The archive carries no licence file (the project is MIT, see the repository).
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 62914560,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    libc: ["glibc"],
    details: "Runs pi, a minimal terminal coding agent, with the model provider of your choice. Needs network access to that provider. pi checks for newer versions and can update itself; Recipe manages updates here, so set PI_SKIP_VERSION_CHECK=1 in your environment. This recipe does not change user environment. Its build is linked against glibc, as LevitateOS has; upstream publishes a glibc build only.",
    homepage: "https://pi.dev",
    license: "MIT",
    adds: #{ programs: ["pi"], menu: [] },
    steps: #{
        download: "Downloads the pinned upstream release archive and checks it against the digest in upstream's SHA256SUMS.",
        build: "Writes the launcher bin/pi; nothing is compiled.",
        install: "Puts the program and its support files under lib/pi and the launcher in bin.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "pi", version: "1.5.2", description: "pi terminal coding agent" };
const UPSTREAM = #{ github: "earendil-works/pi", prefix: "v" };

const SOURCES = #{
    release: #{
        url: "https://github.com/earendil-works/pi/releases/download/v1.5.2/pi-linux-x64.tar.gz",
        sha256: "811c6f2c9e7aaee252b5404252e556fb713aa209c1f7f924226aa77d4ef70cb5",
    },
};

// Everything in the release (its top folder pi/ is left out) under lib/pi;
// the program itself executable.
const FILES = [
    ["",   "lib/pi/"],
    ["pi", "lib/pi/pi", 0o755],
];

const LAUNCHER = `#!/bin/sh
set -eu
tool_root=$(CDPATH= cd -- "$(dirname -- "$(readlink -f -- "$0")")/.." && pwd)
export PI_PACKAGE_DIR="$tool_root/lib/pi"
exec "$PI_PACKAGE_DIR/pi" "$@"
`;

fn build(src, out) {
    let launcher = join_path(out, "bin/pi");
    mkdir(dirname(launcher));
    write_file(launcher, LAUNCHER);
    chmod(launcher, 0o755);
}
