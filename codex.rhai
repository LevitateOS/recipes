// OpenAI Codex CLI rust-v0.167.2, static-pie musl x86_64 release: runs on both the glibc and musl OS variants.
// Archive SHA-256: the digest GitHub publishes for the release asset (verified against our own download).
// The tarball holds one file, codex-x86_64-unknown-linux-musl; its digest below was computed from the verified archive.
// file(1) checked: ELF 64-bit PIE, static-pie linked. Nothing is compiled. Nothing but the binary is installed:
// the archive carries no licence file (the project is Apache-2.0, see the repository).
const RECIPE_API = 2;
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
        acquire: "Downloads the pinned upstream musl release archive and checks it against the digest GitHub publishes for it.",
        build: "Unpacks the static binary and checks it against its own digest; nothing is compiled.",
        install: "Puts the codex command in bin.",
    },
    keeps: [],
};

let ctx = #{
    name: "codex",
    version: "0.167.2",
    description: "OpenAI Codex terminal coding agent",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/openai/codex/releases/download/rust-v0.167.2/codex-x86_64-unknown-linux-musl.tar.gz",
           archive: "codex-x86_64-unknown-linux-musl.tar.gz", sha256: "8246e846c550ea21197fcc4067bc270dca895e94ea42ed6a282e6f4e0125b15f",
           destination: "main", unpack: true },
    ],
    files: [
        #{ source: "main/codex-x86_64-unknown-linux-musl", target: "bin/codex", mode: 0o755,
           sha256: "a9672d0fa0dd8fcf8cad136fa0d056b914bc046f5ac3d78f4a5cf390655af56b" },
    ],
};
ctx.downloads = join_path(RUNTIME.paths.build, "downloads");

fn is_acquired(ctx) {
    for source in ctx.sources {
        let path = join_path(ctx.downloads, source.archive);
        if !is_file(path) { return needs_work(ctx, "download " + source.archive); }
        verify_sha256(path, source.sha256);
    }
    ready(ctx)
}

fn acquire(ctx) {
    mkdir(ctx.downloads);
    for source in ctx.sources {
        download(source.url, join_path(ctx.downloads, source.archive), source.sha256);
    }
    ctx
}

fn is_built(ctx) {
    for file in ctx.files {
        let path = join_path(ctx.unpacked, file.source);
        if !is_file(path) { return needs_work(ctx, "unpack " + ctx.name + " " + ctx.version); }
        verify_sha256(path, file.sha256);
    }
    ready(ctx)
}

fn build(ctx) {
    if exists(ctx.unpacked) { rm(ctx.unpacked); }
    mkdir(ctx.unpacked);
    for source in ctx.sources {
        let archive = join_path(ctx.downloads, source.archive);
        verify_sha256(archive, source.sha256);
        let destination = join_path(ctx.unpacked, source.destination);
        if source.unpack {
            mkdir(destination);
            extract(archive, destination);
        } else {
            mkdir(dirname(destination));
            copy_file(archive, destination);
        }
    }
    ctx
}

fn is_installed(ctx) {
    for file in ctx.files {
        let path = join_path(ctx.package_root, file.target);
        if !is_file(path) { return needs_work(ctx, "install " + ctx.name + " " + ctx.version); }
        verify_sha256(path, file.sha256);
    }
    ctx.outputs["package"] = ctx.package_root;
    ready(ctx)
}

fn install(ctx) {
    if exists(ctx.package_root) { rm(ctx.package_root); }
    for file in ctx.files {
        let path = join_path(ctx.package_root, file.target);
        mkdir(dirname(path));
        copy_file(join_path(ctx.unpacked, file.source), path);
        chmod(path, file.mode);
    }
    ctx.outputs["package"] = ctx.package_root;
    ctx
}

fn remove(ctx) {
    if exists(ctx.package_root) { rm(ctx.package_root); }
    ctx.outputs = #{};
    ctx
}
