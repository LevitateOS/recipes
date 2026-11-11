// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream fzf_0.75.0_checksums.txt at the pinned release below.
// Missing licence texts come from the same pinned upstream tag; their SHA-256 values were computed on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 2818048,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Filters a list of lines with an interactive fuzzy search. It works with files, command history and other text supplied on standard input.",
    homepage: "https://github.com/junegunn/fzf",
    license: "MIT",
    adds: #{ programs: ["fzf"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "fzf",
    version: "0.75.0",
    description: "Interactive fuzzy finder",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/junegunn/fzf/releases/download/v0.75.0/fzf-0.75.0-linux_amd64.tar.gz",
           archive: "fzf-0.75.0-linux_amd64.tar.gz", sha256: "0d6640f83582d991cf429754baad64b07e3a4e439a6019670f4b91da1314141c",
           destination: "main", unpack: true },
        #{ url: "https://raw.githubusercontent.com/junegunn/fzf/v0.75.0/LICENSE",
           archive: "LICENSE", sha256: "a296f423c0d30ce3581435e78e7e36c5fe73984a882d8720c72e713b4593588b",
           destination: "licenses/LICENSE", unpack: false },
    ],
    files: [
        #{ source: "main/fzf", target: "bin/fzf", mode: 0o755,
           sha256: "2d70610518863239656b5cafdeea3c1af93e3a0bb8d584aeb1bb090157eec27b" },
        #{ source: "licenses/LICENSE", target: "share/licenses/fzf/LICENSE", mode: 0o644,
           sha256: "a296f423c0d30ce3581435e78e7e36c5fe73984a882d8720c72e713b4593588b" },
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
