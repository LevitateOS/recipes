const RECIPE_API = 1;
// Archive SHA-256: https://go.dev/dl/?mode=json, for the exact go1.27.4 Linux amd64 release.
// go.sh selects the bundled GOROOT without a caller define; GOTOOLCHAIN=local prevents hidden downloads.
// The archive's checksum covers its contents; Recipe records each placed file's checksum.
const GO_LAUNCHER = `#!/bin/sh
set -eu
tool_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export GOROOT="$tool_root/lib/go"
export GOTOOLCHAIN=local
exec "$GOROOT/bin/go" "$@"
`;
const NEEDS = #{
    outputs: #{ tools: "directory" },
    network: ["go.dev:443", "dl.google.com:443"],
    network_max_bytes: 81461248,
    memory_mib: 4096,
    storage_max_objects: 131072,
    timeout_secs: 1800,
};

// Build dependencies are hidden library entries until the catalog has a toolchain kind.
const ABOUT = #{
    kind: "library",
    category: "development",
    details: "Compiles Go programs inside the Recipe sandbox with the pinned compiler and standard library. The go launcher selects this bundled toolchain and disables automatic toolchain downloads.",
    homepage: "https://go.dev",
    license: "BSD-3-Clause",
    steps: #{
        download: "Downloads the pinned release archive and checks its SHA-256.",
        build: "Removes upstream test fixtures and writes the go launcher and the gofmt copy.",
        install: "Publishes the toolchain under lib/go with the launchers in bin, as a private tools directory for recipes that name this under build_deps.",
    },
};

const PACKAGE = #{ name: "go", version: "1.27.4", description: "Go compiler and standard library" };

const SOURCES = #{
    release: #{
        url: "https://go.dev/dl/go1.27.4.linux-amd64.tar.gz",
        sha256: "7226736c2339719cda28fbf3a54d71aa63bcefe376e98cef00034268dab24840",
    },
};

// Everything in the release (its top folder go/ is left out) under lib/go.
const FILES = [["", "lib/go/"]];

// go.dev says the current version on its first line ("go1.27.4").
fn latest() {
    http_get("https://go.dev/VERSION?m=text").split("\n")[0].sub_string(2)
}

fn build(src, out) {
    let goroot = join_path(out, "lib/go");
    // Compiler/stdlib build inputs do not include upstream test fixtures,
    // including intentionally published private keys used by Go's tests.
    exec_checked("find", [join_path(goroot, "src"), "-type", "d", "-name", "testdata", "-prune", "-exec", "rm", "-rf", "{}", ";"]);
    exec_checked("find", [goroot, "-type", "f", "-name", "*_test.go", "-delete"]);
    rm(join_path(goroot, "test"));
    rm(join_path(goroot, "src/crypto/x509/platform_root_key.pem"));
    rm(join_path(goroot, "src/crypto/x509/platform_root_cert.pem"));
    mkdir(join_path(out, "bin"));
    write_file(join_path(out, "bin/go"), GO_LAUNCHER);
    chmod(join_path(out, "bin/go"), 0o755);
    copy_file(join_path(goroot, "bin/gofmt"), join_path(out, "bin/gofmt"));
    chmod(join_path(out, "bin/gofmt"), 0o755);
}

// The run-the-program check (`go version`) is gone: verify only reads.
fn verify(out) {
    for path in ["bin/go", "bin/gofmt", "lib/go/bin/go", "lib/go/pkg/tool"] {
        if !exists(join_path(out, path)) { throw "the toolchain has no " + path; }
    }
}
