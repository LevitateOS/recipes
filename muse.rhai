// Meta Muse code CLI 1.4.18-R8587.1, x86_64 Linux single binary (not an archive).
// SHA-256 and size: Meta's release manifest for this version, the one the official launcher checks; verified against our
// own anonymous download (no login needed). The installed file is that same file, so one digest serves as both.
// file(1): ELF 64-bit x86-64, statically linked, stripped, so it runs on both OS variants.
// The recipe fetches it from Meta at install time; nothing is redistributed. Licence: no licence text was found in the
// launcher, installer or binary, so the field says proprietary (Meta terms).
// Meta advertises only the current version on its channel API, so this pin can stop downloading when Meta retires it.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["lookaside.facebook.com:443"],
    network_max_bytes: 503316480,
    timeout_secs: 3600,
};

const ABOUT = #{
    kind: "tool",
    category: "development",
    details: "Runs Meta's Muse coding agent in the terminal. Needs a Meta account and network access to Meta. Upstream's launcher updates itself; Recipe manages updates here, so set MUSE_NO_AUTO_UPDATE=1 in your environment. This recipe does not change user environment.",
    homepage: "https://dev.meta.ai",
    license: "proprietary (Meta terms)",
    adds: #{ programs: ["muse"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned file from Meta and checks it against the digest in Meta's release manifest.",
        build: "Copies the file into place and checks it against its digest; nothing is compiled.",
        install: "Puts the muse command in bin.",
    },
    keeps: [],
};

let ctx = #{
    name: "muse",
    version: "1.4.18-R8587.1",
    description: "Meta Muse terminal coding agent",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://lookaside.facebook.com/lookaside/muse/download/?channel=muse&version=1.4.18-R8587.1&file=muse-x86-linux",
           archive: "muse-1.4.18-R8587.1-x86-linux", sha256: "57732db89e25a58196c923b3790aa3e2a85b8d1ad5094492384792260e65b538",
           destination: "main/muse", unpack: false },
    ],
    files: [
        #{ source: "main/muse", target: "bin/muse", mode: 0o755,
           sha256: "57732db89e25a58196c923b3790aa3e2a85b8d1ad5094492384792260e65b538" },
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
