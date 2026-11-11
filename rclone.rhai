// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Release SHA-256: upstream SHA256SUMS at the pinned release below.
// Missing licence texts come from the same pinned upstream tag; their SHA-256 values were computed on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443", "raw.githubusercontent.com:443"],
    network_max_bytes: 37158912,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Copies and synchronises files between local storage and cloud services. It also supports checking file contents and managing remote directories.",
    homepage: "https://rclone.org",
    license: "MIT",
    adds: #{ programs: ["rclone"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "rclone",
    version: "1.76.0",
    description: "File synchronisation for cloud storage",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/rclone/rclone/releases/download/v1.76.0/rclone-v1.76.0-linux-amd64.zip",
           archive: "rclone-v1.76.0-linux-amd64.zip", sha256: "b00f00b3266c3764413afe599d3ec316f6f43b3e0ea8a0bc1d186d2133e46df7",
           destination: "main", unpack: true },
        #{ url: "https://raw.githubusercontent.com/rclone/rclone/v1.76.0/COPYING",
           archive: "COPYING", sha256: "8cd2e9e750b90a04b7d82dbbca3930c696ae0309d7c10464f90a44f45754cd04",
           destination: "licenses/COPYING", unpack: false },
    ],
    files: [
        #{ source: "main/rclone-v1.76.0-linux-amd64/rclone", target: "bin/rclone", mode: 0o755,
           sha256: "62e4d3e5432f2c685f1834b8bb342058ff0611c99d048aeb44bb8d8fd611527e" },
        #{ source: "main/rclone-v1.76.0-linux-amd64/rclone.1", target: "share/man/man1/rclone.1", mode: 0o644,
           sha256: "e9f3f445ac715b91a52ac67bbd32501d3da7479d6fa97de2699548d451a6d18e" },
        #{ source: "licenses/COPYING", target: "share/licenses/rclone/COPYING", mode: 0o644,
           sha256: "8cd2e9e750b90a04b7d82dbbca3930c696ae0309d7c10464f90a44f45754cd04" },
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
