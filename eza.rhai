// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Binary archive SHA-256: upstream release notes, sha256sum table.
// Documentation archive SHA-256 values computed from downloads on 2026-11-11; no upstream checksum published.
// Missing licence texts come from the same pinned upstream tag; their SHA-256 values were computed on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 1835008,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Lists files with colours, Git status and tree views. It can display permissions, timestamps and other file details.",
    homepage: "https://github.com/eza-community/eza",
    license: "EUPL-1.2 AND MIT AND CC-BY-4.0",
    adds: #{ programs: ["eza"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "eza",
    version: "0.23.5",
    description: "Directory listing with file details",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/eza-community/eza/releases/download/v0.23.5/eza_x86_64-unknown-linux-musl.tar.gz",
           archive: "eza_x86_64-unknown-linux-musl.tar.gz", sha256: "e06eebab74b73d6b7d51a796a353824b001bea82df077706382e100815d28904",
           destination: "main", unpack: true },
        #{ url: "https://github.com/eza-community/eza/releases/download/v0.23.5/man-0.23.5.tar.gz",
           archive: "man-0.23.5.tar.gz", sha256: "cbdae2ad79ae0ef1fd6a06f4644c90cef79a56353bc3bb7cf4663bb2831420f9",
           destination: "docs1", unpack: true },
        #{ url: "https://github.com/eza-community/eza/releases/download/v0.23.5/completions-0.23.5.tar.gz",
           archive: "completions-0.23.5.tar.gz", sha256: "8ca5a250d28c3c7ebd0077aca203701a17d1ea7c92621d9e274b93965e3c9291",
           destination: "docs2", unpack: true },
        #{ url: "https://raw.githubusercontent.com/eza-community/eza/v0.23.5/LICENSE.txt",
           archive: "LICENSE.txt", sha256: "57fb42fbcd0b037ce528ed8f72f1ec095d67bc6825ecf1448ff39be1fe68a4b4",
           destination: "licenses/LICENSE.txt", unpack: false },
        #{ url: "https://raw.githubusercontent.com/eza-community/eza/v0.23.5/LICENSES/CC-BY-4.0.txt",
           archive: "CC-BY-4.0.txt", sha256: "d557539df68e771cc1eedcc91d13f70fca930e508d11eedcafa4b15db49e3744",
           destination: "licenses/CC-BY-4.0.txt", unpack: false },
        #{ url: "https://raw.githubusercontent.com/eza-community/eza/v0.23.5/LICENSES/EUPL-1.2.txt",
           archive: "EUPL-1.2.txt", sha256: "57fb42fbcd0b037ce528ed8f72f1ec095d67bc6825ecf1448ff39be1fe68a4b4",
           destination: "licenses/EUPL-1.2.txt", unpack: false },
        #{ url: "https://raw.githubusercontent.com/eza-community/eza/v0.23.5/LICENSES/MIT.txt",
           archive: "MIT.txt", sha256: "b85dcd3e453d05982552c52b5fc9e0bdd6d23c6f8e844b984a88af32570b0cc0",
           destination: "licenses/MIT.txt", unpack: false },
    ],
    files: [
        #{ source: "main/eza", target: "bin/eza", mode: 0o755,
           sha256: "57861176680ae28c6fec813014050a70372b0c89359730be117de1561ba782b4" },
        #{ source: "docs1/target/man-0.23.5/eza.1", target: "share/man/man1/eza.1", mode: 0o644,
           sha256: "a948b88ddddc8db95906042ea142ef363f2f8480328e49bad3b23305472f6836" },
        #{ source: "docs1/target/man-0.23.5/eza_colors-explanation.5", target: "share/man/man5/eza_colors-explanation.5", mode: 0o644,
           sha256: "89fcdc749620b572bfa4d2579ed6afa2c63957f7918afe581a0b20d6c4045015" },
        #{ source: "docs1/target/man-0.23.5/eza_colors.5", target: "share/man/man5/eza_colors.5", mode: 0o644,
           sha256: "c5034fcb1cffee942059a7a204d01224a17be0c8f87af208a31129528bab9630" },
        #{ source: "docs2/target/completions-0.23.5/_eza", target: "share/zsh/site-functions/_eza", mode: 0o644,
           sha256: "251d3f3059fe6dbe17a14f55250b554ffa85ad7939e7a55720ff61a9747aff1e" },
        #{ source: "docs2/target/completions-0.23.5/_eza.ps1", target: "share/eza/completions/_eza.ps1", mode: 0o644,
           sha256: "2cb4c33dab819f53d9cb0a167140123e2bab5d48fd31c74802d3c7d5701ad59b" },
        #{ source: "docs2/target/completions-0.23.5/eza", target: "share/bash-completion/completions/eza", mode: 0o644,
           sha256: "5f0a65aa99b2edbf1aedce5190f759a4105f1ec07235f2f37548682df7bd400d" },
        #{ source: "docs2/target/completions-0.23.5/eza.fish", target: "share/fish/vendor_completions.d/eza.fish", mode: 0o644,
           sha256: "62173ee6f35e323b3724239696079338e35edab10964c35864d4eeedd497dc01" },
        #{ source: "docs2/target/completions-0.23.5/eza.nu", target: "share/eza/completions/eza.nu", mode: 0o644,
           sha256: "4bdc697f534d86d8c15b4acf2c5d01394b75e9ca2926b940db5754c07088ab9f" },
        #{ source: "licenses/LICENSE.txt", target: "share/licenses/eza/LICENSE.txt", mode: 0o644,
           sha256: "57fb42fbcd0b037ce528ed8f72f1ec095d67bc6825ecf1448ff39be1fe68a4b4" },
        #{ source: "licenses/CC-BY-4.0.txt", target: "share/licenses/eza/CC-BY-4.0.txt", mode: 0o644,
           sha256: "d557539df68e771cc1eedcc91d13f70fca930e508d11eedcafa4b15db49e3744" },
        #{ source: "licenses/EUPL-1.2.txt", target: "share/licenses/eza/EUPL-1.2.txt", mode: 0o644,
           sha256: "57fb42fbcd0b037ce528ed8f72f1ec095d67bc6825ecf1448ff39be1fe68a4b4" },
        #{ source: "licenses/MIT.txt", target: "share/licenses/eza/MIT.txt", mode: 0o644,
           sha256: "b85dcd3e453d05982552c52b5fc9e0bdd6d23c6f8e844b984a88af32570b0cc0" },
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
