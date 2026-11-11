// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream micro-2.0.15-linux64-static.tar.gz.sha at the pinned release below.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 6029312,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Edits text in the terminal with familiar keyboard shortcuts and mouse support. It includes syntax highlighting and multiple buffers.",
    homepage: "https://micro-editor.github.io",
    license: "MIT",
    adds: #{ programs: ["micro"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "micro",
    version: "2.0.15",
    description: "Terminal text editor",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/micro-editor/micro/releases/download/v2.0.15/micro-2.0.15-linux64-static.tar.gz",
           archive: "micro-2.0.15-linux64-static.tar.gz", sha256: "267d238eac1e26ed053d13d4d48bd421b87f9eb538b604f0b2f74a85598b6cc2",
           destination: "main", unpack: true },
    ],
    files: [
        #{ source: "main/micro-2.0.15/LICENSE", target: "share/licenses/micro/LICENSE", mode: 0o644,
           sha256: "f3824f778a8667ea76c699e11777ef07e8215bbf8c7d5a2d6745878430264797" },
        #{ source: "main/micro-2.0.15/LICENSE-THIRD-PARTY", target: "share/licenses/micro/LICENSE-THIRD-PARTY", mode: 0o644,
           sha256: "0487c25cba70f2c55c68dc66dc4669b86a396621a96505b1970371cc741c4ac0" },
        #{ source: "main/micro-2.0.15/micro", target: "bin/micro", mode: 0o755,
           sha256: "2027f2e4698fa4e826523ad16b95c724bf808de479f10ec769cdd200437701b3" },
        #{ source: "main/micro-2.0.15/micro.1", target: "share/man/man1/micro.1", mode: 0o644,
           sha256: "9ac7cb3ebbb7561a28284325bbffc3e19065294375c474b0027ce44e0513e568" },
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
