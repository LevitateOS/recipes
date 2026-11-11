// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream sha256sum.txt at the pinned release below.
// jq source archive (manual and licences only): upstream sha256sum.txt.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 5046272,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Filters and transforms JSON using a small expression language. It can select fields, combine records and format results.",
    homepage: "https://jqlang.org",
    license: "MIT",
    adds: #{ programs: ["jq"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "jq",
    version: "1.8.2",
    description: "Command-line JSON processor",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-linux-amd64",
           archive: "jq-linux-amd64", sha256: "b1c22172dd303f3be49e935aa56aa48a8b7a46e0bc838b4997d3bb451495870f",
           destination: "main/jq", unpack: false },
        #{ url: "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-1.8.2.tar.gz",
           archive: "jq-1.8.2.tar.gz", sha256: "71b8d6e8f5fe81f6c6d0d110e3892251f6ce76ed095abd315e26e6e1193af3af",
           destination: "docs1", unpack: true },
    ],
    files: [
        #{ source: "main/jq", target: "bin/jq", mode: 0o755,
           sha256: "b1c22172dd303f3be49e935aa56aa48a8b7a46e0bc838b4997d3bb451495870f" },
        #{ source: "docs1/jq-1.8.2/jq.1", target: "share/man/man1/jq.1", mode: 0o644,
           sha256: "6f1dac8bf304aa3a16f452a60b827a25fe1928e3165888a6f1b6493cc024c073" },
        #{ source: "docs1/jq-1.8.2/COPYING", target: "share/licenses/jq/COPYING", mode: 0o644,
           sha256: "ad2b4a266b2268939c1446979759706077421cf906a203aa188c6f396e8cfd74" },
        #{ source: "docs1/jq-1.8.2/vendor/oniguruma/COPYING", target: "share/licenses/jq/oniguruma-COPYING", mode: 0o644,
           sha256: "70ba5469ea0bab6e18a32d7009068f996503168d27be57747e08da34337ff26f" },
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
