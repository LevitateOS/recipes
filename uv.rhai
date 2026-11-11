// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream uv-x86_64-unknown-linux-musl.tar.gz.sha256 at the pinned release below.
// Missing licence texts come from the same pinned upstream tag; their SHA-256 values were computed on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 21364736,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Manages Python projects, environments and packages. The companion uvx command runs tools in isolated Python environments.",
    homepage: "https://docs.astral.sh/uv",
    license: "MIT OR Apache-2.0",
    adds: #{ programs: ["uv", "uvx"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "uv",
    version: "0.13.7",
    description: "Python project and package manager",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/astral-sh/uv/releases/download/0.13.7/uv-x86_64-unknown-linux-musl.tar.gz",
           archive: "uv-x86_64-unknown-linux-musl.tar.gz", sha256: "287491da03f2a785c70fa75b13e1f849918c2f2b5415fe84876b8214eeb792f9",
           destination: "main", unpack: true },
        #{ url: "https://raw.githubusercontent.com/astral-sh/uv/0.13.7/LICENSE-APACHE",
           archive: "LICENSE-APACHE", sha256: "c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4",
           destination: "licenses/LICENSE-APACHE", unpack: false },
        #{ url: "https://raw.githubusercontent.com/astral-sh/uv/0.13.7/LICENSE-MIT",
           archive: "LICENSE-MIT", sha256: "860e3d7a86b84e6a7012c7a635fc64df475cebc6cce34dfeb73a5982ec58176c",
           destination: "licenses/LICENSE-MIT", unpack: false },
    ],
    files: [
        #{ source: "main/uv-x86_64-unknown-linux-musl/uv", target: "bin/uv", mode: 0o755,
           sha256: "500c0ec54518b2a53380783586b75a79907d937d741ebb04236d90a50ed5ab26" },
        #{ source: "main/uv-x86_64-unknown-linux-musl/uvx", target: "bin/uvx", mode: 0o755,
           sha256: "9abf7dea7b7b1e3282c8a9db839d874c331e8b745428354a2273bdc306656e29" },
        #{ source: "licenses/LICENSE-APACHE", target: "share/licenses/uv/LICENSE-APACHE", mode: 0o644,
           sha256: "c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4" },
        #{ source: "licenses/LICENSE-MIT", target: "share/licenses/uv/LICENSE-MIT", mode: 0o644,
           sha256: "860e3d7a86b84e6a7012c7a635fc64df475cebc6cce34dfeb73a5982ec58176c" },
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
