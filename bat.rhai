// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 4259840,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Displays files with syntax highlighting and line numbers. It can show Git changes beside the text.",
    homepage: "https://github.com/sharkdp/bat",
    license: "MIT OR Apache-2.0",
    adds: #{ programs: ["bat"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "bat",
    version: "0.26.1",
    description: "File viewer with syntax highlighting",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-x86_64-unknown-linux-musl.tar.gz",
           archive: "bat-v0.26.1-x86_64-unknown-linux-musl.tar.gz", sha256: "0dcd8ac79732c0d5b136f11f4ee00e581440e16a44eab5b3105b611bbf2cf191",
           destination: "main", unpack: true },
    ],
    files: [
        #{ source: "main/bat-v0.26.1-x86_64-unknown-linux-musl/LICENSE-APACHE", target: "share/licenses/bat/LICENSE-APACHE", mode: 0o644,
           sha256: "c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4" },
        #{ source: "main/bat-v0.26.1-x86_64-unknown-linux-musl/LICENSE-MIT", target: "share/licenses/bat/LICENSE-MIT", mode: 0o644,
           sha256: "dccda9eb9533f5c65624a1106536c6cfde46008d58e60b3faf154e8b9fd5b46e" },
        #{ source: "main/bat-v0.26.1-x86_64-unknown-linux-musl/autocomplete/_bat.ps1", target: "share/bat/completions/_bat.ps1", mode: 0o644,
           sha256: "0ebf3b9d7b6271c747a6ce43b84f2641b0d51ee7babc51b395a9a32a806d7b8c" },
        #{ source: "main/bat-v0.26.1-x86_64-unknown-linux-musl/autocomplete/bat.bash", target: "share/bash-completion/completions/bat", mode: 0o644,
           sha256: "ecc658df28c268d9fd7aa2322f5260e82bf94475c66648d57cb22e4799543a8e" },
        #{ source: "main/bat-v0.26.1-x86_64-unknown-linux-musl/autocomplete/bat.fish", target: "share/fish/vendor_completions.d/bat.fish", mode: 0o644,
           sha256: "65c0ec90cc15b441bce53627f9afce59c7a5d52683430369f195a390bd1f6be8" },
        #{ source: "main/bat-v0.26.1-x86_64-unknown-linux-musl/autocomplete/bat.zsh", target: "share/zsh/site-functions/_bat", mode: 0o644,
           sha256: "17b1fd468ea040343a43be2894dd2d2542c827514fdb03b2e71f7f0fe28b5884" },
        #{ source: "main/bat-v0.26.1-x86_64-unknown-linux-musl/bat", target: "bin/bat", mode: 0o755,
           sha256: "fe686142ae007618f92a9ece304bf5a83499436447ddb983baa1c144566451d2" },
        #{ source: "main/bat-v0.26.1-x86_64-unknown-linux-musl/bat.1", target: "share/man/man1/bat.1", mode: 0o644,
           sha256: "2bee848452c53e0024fdb9dbfe60dbc472c68f29209bc7a030534ba2926579d1" },
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
