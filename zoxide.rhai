// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 851968,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Remembers directories you visit and helps you return to them by a short name. It supplies shell integration through its init command.",
    homepage: "https://github.com/ajeetdsouza/zoxide",
    license: "MIT",
    adds: #{ programs: ["zoxide"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "zoxide",
    version: "0.10.0",
    description: "Directory jumping based on usage",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-x86_64-unknown-linux-musl.tar.gz",
           archive: "zoxide-0.10.0-x86_64-unknown-linux-musl.tar.gz", sha256: "2d93385b99f3e82cf2701609a1bffcad863fbeb75aa3fe7eb6be4d29be68b1ae",
           destination: "main", unpack: true },
    ],
    files: [
        #{ source: "main/LICENSE", target: "share/licenses/zoxide/LICENSE", mode: 0o644,
           sha256: "23aa3b08366e4ed6050f3d9950070201802aadbe5675fa1c19f24f4de91cf294" },
        #{ source: "main/completions/README.md", target: "share/zoxide/completions/README.md", mode: 0o644,
           sha256: "eb6f7068ad5066b45b21695da3f65a88321145b646562abd3fcb9ca19d71f69b" },
        #{ source: "main/completions/_zoxide", target: "share/zsh/site-functions/_zoxide", mode: 0o644,
           sha256: "e07e75de008c783e944491ef1e513269c8bf531c558ec52e28c44eb37ce426c5" },
        #{ source: "main/completions/_zoxide.ps1", target: "share/zoxide/completions/_zoxide.ps1", mode: 0o644,
           sha256: "74e8ef5e08aeab8c4040ccdfe6122f1ef7058c67d3e9b5e3464c263512a787cc" },
        #{ source: "main/completions/zoxide.bash", target: "share/bash-completion/completions/zoxide", mode: 0o644,
           sha256: "9e3441b05747a1439a38deb5b745217cb78df62403f036e6508230967ad4dfc0" },
        #{ source: "main/completions/zoxide.elv", target: "share/zoxide/completions/zoxide.elv", mode: 0o644,
           sha256: "9f67512483f101736b193858aa19fb03053b082b21dd2cfb0c2f5e0f7f99ca4d" },
        #{ source: "main/completions/zoxide.fish", target: "share/fish/vendor_completions.d/zoxide.fish", mode: 0o644,
           sha256: "d641f99c1b81a149ec384f5f51e1df36f05389f0052f5cc4fc6d9920b2e19b44" },
        #{ source: "main/completions/zoxide.nu", target: "share/zoxide/completions/zoxide.nu", mode: 0o644,
           sha256: "6f309a430aa2e0971ae8abef4e798bd7a447db1e3eff299d4f5dae26427e4d7b" },
        #{ source: "main/completions/zoxide.ts", target: "share/zoxide/completions/zoxide.ts", mode: 0o644,
           sha256: "1155597a0555af0364ee5a85211fb52ec49356b29f286c16a233b97b6eda967c" },
        #{ source: "main/man/man1/zoxide-add.1", target: "share/man/man1/zoxide-add.1", mode: 0o644,
           sha256: "f74cba8e6bd683b4fdd6e35b65751e7e4097564cb7b964ec92ce5b26cad8fb0b" },
        #{ source: "main/man/man1/zoxide-import.1", target: "share/man/man1/zoxide-import.1", mode: 0o644,
           sha256: "cdd2b3edd0e18e17ac3b7409f00566b977706006be24d679df5dff179ada0883" },
        #{ source: "main/man/man1/zoxide-init.1", target: "share/man/man1/zoxide-init.1", mode: 0o644,
           sha256: "0f541aa52d1e6c7135d4fd8a133d3e1ee29c45aca0ea00e990ac5b7a63a0fa70" },
        #{ source: "main/man/man1/zoxide-query.1", target: "share/man/man1/zoxide-query.1", mode: 0o644,
           sha256: "7c027637a49d8a00eb27cfbceaf655f8940af00be2138de9c2980d54f250eeb3" },
        #{ source: "main/man/man1/zoxide-remove.1", target: "share/man/man1/zoxide-remove.1", mode: 0o644,
           sha256: "7c9d899bfb426e6709873d2c248ac4a4b5f3b5392fa786a63701b9092c9c6d76" },
        #{ source: "main/man/man1/zoxide.1", target: "share/man/man1/zoxide.1", mode: 0o644,
           sha256: "4fd987ad35ac8b8132da3a4d9af6686f9861098372586043d6f250aff09aedd3" },
        #{ source: "main/zoxide", target: "bin/zoxide", mode: 0o755,
           sha256: "0959b169db9adac07187ab99b0d9806f616fbe7938cf84f9f4e2422d8de16e6c" },
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
