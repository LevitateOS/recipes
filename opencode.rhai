// opencode v1.19.5 (anomalyco/opencode), Bun-compiled x86_64 Linux CLI, glibc variant (dynamic, glibc <= 2.17).
// Archive SHA-256: the digest GitHub publishes for the release asset (verified against our own download).
// The tarball holds one file, opencode; its digest below was computed from the verified archive.
// libc: Recipe has no way to select an artifact by the target's C library (RUNTIME carries only target/host os and arch),
// so only the glibc build is shipped. AcornOS (musl) needs opencode-linux-x64-musl.tar.gz, sha256
// e8d5be23bf8f3f69bc3206f3311215c049329cd6afa7c06d733987cc2d33b568 (inner opencode sha256 528058cf8f2a7196ec94dc113052b785f8f94f6802ced3980ad7359369ddacc8),
// once Recipe can choose by libc.
// Nothing is compiled. The archive carries no licence file (the project is MIT, see the repository).
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 83886080,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Runs the opencode coding agent in the terminal, with the model provider of your choice. Needs network access to that provider, and fetches a model catalogue and may download language servers. Upstream can update itself; Recipe manages updates here, so set \"update\": \"disable\" in opencode's global config. This recipe does not write user configuration. This build needs glibc.",
    homepage: "https://opencode.ai",
    license: "MIT",
    adds: #{ programs: ["opencode"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release archive and checks it against the digest GitHub publishes for it.",
        build: "Unpacks the binary and checks it against its own digest; nothing is compiled.",
        install: "Puts the opencode command in bin.",
    },
    keeps: [],
};

let ctx = #{
    name: "opencode",
    version: "1.19.5",
    description: "opencode terminal coding agent",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/anomalyco/opencode/releases/download/v1.19.5/opencode-linux-x64.tar.gz",
           archive: "opencode-linux-x64.tar.gz", sha256: "588310a336fa3b9df36b3f0225b26f679d453efaad0cf3d66c3651ef3ec1647a",
           destination: "main", unpack: true },
    ],
    files: [
        #{ source: "main/opencode", target: "bin/opencode", mode: 0o755,
           sha256: "7df4e4136301f16589b0f30bf91a61380fca5f8ef22dd36570f5ebe1d4ec802c" },
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
