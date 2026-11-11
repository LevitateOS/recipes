// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 4063232,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Displays diffs with syntax highlighting and side-by-side views. It can serve as the pager for Git output.",
    homepage: "https://github.com/dandavison/delta",
    license: "MIT",
    adds: #{ programs: ["delta"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "delta",
    version: "0.20.1",
    description: "Syntax-highlighted pager for diffs",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/dandavison/delta/releases/download/0.20.1/delta-0.20.1-x86_64-unknown-linux-musl.tar.gz",
           archive: "delta-0.20.1-x86_64-unknown-linux-musl.tar.gz", sha256: "69dcb4043f55c29118f408c6efd30115e0a4e0a6709253343b8c8fa814ab4a31",
           destination: "main", unpack: true },
    ],
    files: [
        #{ source: "main/delta-0.20.1-x86_64-unknown-linux-musl/LICENSE", target: "share/licenses/delta/LICENSE", mode: 0o644,
           sha256: "3c7f629a291a54889b6be5db2fc470462f27005c315d81edc1630f1d34046fd4" },
        #{ source: "main/delta-0.20.1-x86_64-unknown-linux-musl/delta", target: "bin/delta", mode: 0o755,
           sha256: "35d5a370dd8f554c0465a37acbd1016b8781efa10e04291f8fffc59cbc9e83c4" },
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
