// Claude Code 2.1.323, Bun-compiled x86_64 Linux CLI, glibc variant (dynamic, glibc <= 2.26). A single file, not an archive.
// SHA-256: Anthropic's GPG-signed manifest.json for 2.1.323 (https://downloads.claude.ai/claude-code-releases/2.1.323/manifest.json),
// verified against our own download; the installed file is that same file, so one digest serves as both.
// Proprietary: (c) Anthropic PBC, all rights reserved, subject to Anthropic's Commercial Terms. The recipe fetches the
// file from Anthropic at install time; nothing is redistributed.
// libc: this recipe ships the glibc build, and ABOUT.libc says so. Upstream also publishes a musl build,
// .../2.1.323/linux-x64-musl/claude, sha256 8ba3c07a4531a04843048d1ecd4abad2c41fd9a5a52476789a23280ed227d399, which Recipe does
// not yet choose by RUNTIME.host.libc.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["downloads.claude.ai:443"],
    network_max_bytes: 398458880,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    libc: ["glibc"],
    details: "Runs Anthropic's Claude Code coding agent in the terminal. Needs a Claude account or API key and network access to Anthropic. Proprietary software under Anthropic's Commercial Terms. Upstream updates itself; Recipe manages updates here, so set DISABLE_AUTOUPDATER=1 in your environment. This recipe does not change user environment. Its build is linked against glibc, as LevitateOS has.",
    homepage: "https://claude.com/product/claude-code",
    license: "proprietary (Anthropic Commercial Terms, all rights reserved)",
    adds: #{ programs: ["claude"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned file from Anthropic and checks it against the digest in Anthropic's signed release manifest.",
        build: "Copies the file into place and checks it against its digest; nothing is compiled.",
        install: "Puts the claude command in bin.",
    },
    keeps: [],
};

let ctx = #{
    name: "claude-code",
    version: "2.1.323",
    description: "Claude Code terminal coding agent",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://downloads.claude.ai/claude-code-releases/2.1.323/linux-x64/claude",
           archive: "claude-2.1.323-linux-x64", sha256: "604d29a6869409106b6a1110bdadcc8b72e8654a5a865d23258f938a696e348e",
           destination: "main/claude", unpack: false },
    ],
    files: [
        #{ source: "main/claude", target: "bin/claude", mode: 0o755,
           sha256: "604d29a6869409106b6a1110bdadcc8b72e8654a5a865d23258f938a696e348e" },
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
