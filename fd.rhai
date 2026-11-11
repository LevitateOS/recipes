// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 2228224,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Finds files and directories by name with simple defaults. It respects ignore files and can run a command for each match.",
    homepage: "https://github.com/sharkdp/fd",
    license: "MIT OR Apache-2.0",
    adds: #{ programs: ["fd"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "fd",
    version: "10.5.2",
    description: "Fast file finder",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/sharkdp/fd/releases/download/v10.5.2/fd-v10.5.2-x86_64-unknown-linux-musl.tar.gz",
           archive: "fd-v10.5.2-x86_64-unknown-linux-musl.tar.gz", sha256: "7e2d07fa2b8807642aaec67b7e2972a9fbe4db26fcb340a7372392db42b26694",
           destination: "main", unpack: true },
    ],
    files: [
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/LICENSE-APACHE", target: "share/licenses/fd/LICENSE-APACHE", mode: 0o644,
           sha256: "73c83c60d817e7df1943cb3f0af81e4939a8352c9a96c2fd00451b1116fa635c" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/LICENSE-MIT", target: "share/licenses/fd/LICENSE-MIT", mode: 0o644,
           sha256: "322cfc7aa0c774d0eca3b2610f1d414de3ddbd7d8dd4b9dea941a13a6eb07455" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/autocomplete/_fd", target: "share/zsh/site-functions/_fd", mode: 0o644,
           sha256: "08b83ba1cd59a2d6cc6670dea4464583503e7b827b82a12b25a8ee6e5d1e52fe" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/autocomplete/_fd.ps1", target: "share/fd/completions/_fd.ps1", mode: 0o644,
           sha256: "c0ec44cb2316d72eabe3be5ccd12402f14a0ea8ab73b76007b433f3f9d42dd36" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/autocomplete/_fdfind", target: "share/zsh/site-functions/_fdfind", mode: 0o644,
           sha256: "ba0e263c71cfae7df2ae063256ca2943944bf9e118ac7d23594d7a8d172c9197" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/autocomplete/fd.bash", target: "share/bash-completion/completions/fd", mode: 0o644,
           sha256: "e90bbae0af1bb5a2887fa739ab2d40400cd1191694666b55082267983d21b707" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/autocomplete/fd.fish", target: "share/fish/vendor_completions.d/fd.fish", mode: 0o644,
           sha256: "e427d78b027cb1c09fb62e02c7302a5c521a2c7897b69dcbc784f713bffc70b3" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/autocomplete/fdfind.bash", target: "share/bash-completion/completions/fdfind", mode: 0o644,
           sha256: "8084686e775e4c301ab81809fa0ce6542adf774a27386c265b6fdcff87ebe7ff" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/autocomplete/fdfind.fish", target: "share/fish/vendor_completions.d/fdfind.fish", mode: 0o644,
           sha256: "c57a8dc96e9230d3c8eba255b84e1bc6ded40ea15a00dbf82f076a783c257613" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/fd", target: "bin/fd", mode: 0o755,
           sha256: "bd664fa3c5c4919234adf2b489c4b7ec47282e8e926c012e3f67112cf9f8c182" },
        #{ source: "main/fd-v10.5.2-x86_64-unknown-linux-musl/fd.1", target: "share/man/man1/fd.1", mode: 0o644,
           sha256: "fd03c47404fb48b57be10d212237346de79983d1df1dd884b24d62d74317be8c" },
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
