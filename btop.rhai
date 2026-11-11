// Upstream static x86_64 Linux release: file and readelf -d checked before authoring.
// Upstream publishes no checksum file; archive SHA-256 computed from the download on 2026-11-11.
// Every installed file is pinned separately below; nothing is compiled.
const RECIPE_API = 2;
const NEEDS = #{
    outputs: #{ "package": "directory" },
    network: ["github.com:443", "release-assets.githubusercontent.com:443"],
    network_max_bytes: 1376256,
    timeout_secs: 300,
};

const ABOUT = #{
    kind: "tool",
    category: "utilities",
    details: "Shows processor, memory, disk, network and process activity in the terminal. This static release does not include GPU monitoring.",
    homepage: "https://github.com/aristocratos/btop",
    license: "Apache-2.0",
    adds: #{ programs: ["btop"], menu: [] },
    steps: #{
        acquire: "Downloads the pinned upstream release and any companion documentation or licence files, checking every SHA-256.",
        build: "Unpacks the static release and checks each selected file against its own digest; nothing is compiled.",
        install: "Copies the commands and accompanying release files into bin and share.",
    },
    keeps: [],
};

let ctx = #{
    name: "btop",
    version: "1.4.8",
    description: "Interactive system resource monitor",
    package_root: join_path(RUNTIME.paths.output, "package"),
    unpacked: join_path(RUNTIME.paths.build, "unpacked"),
    sources: [
        #{ url: "https://github.com/aristocratos/btop/releases/download/v1.4.8/btop-x86_64-unknown-linux-musl.tar.gz",
           archive: "btop-x86_64-unknown-linux-musl.tar.gz", sha256: "af589cf82cc9ea9c29ce050b9239a13bef2d1492256d476156e1054a42ce89ad",
           destination: "main", unpack: true },
    ],
    files: [
        #{ source: "main/btop/LICENSE", target: "share/licenses/btop/LICENSE", mode: 0o644,
           sha256: "cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30" },
        #{ source: "main/btop/bin/btop", target: "bin/btop", mode: 0o755,
           sha256: "13ef2031016ba7600021797c391e1bd6c114874f2443e19064544b48767e515d" },
        #{ source: "main/btop/themes/HotPurpleTrafficLight.theme", target: "share/btop/themes/HotPurpleTrafficLight.theme", mode: 0o644,
           sha256: "dec7475a5583bc00e9a11ec15d95387fcca1e43e8979a3f6186d7897c4be0fd5" },
        #{ source: "main/btop/themes/adapta.theme", target: "share/btop/themes/adapta.theme", mode: 0o644,
           sha256: "99306b440742c324adc2f1c87f89e954e3db88b16c236e47c7ff764c799317f5" },
        #{ source: "main/btop/themes/adwaita-dark.theme", target: "share/btop/themes/adwaita-dark.theme", mode: 0o644,
           sha256: "e6a01151bffdfa87eb55f942d0098b964eea24c1deb5fe294a77703269081da2" },
        #{ source: "main/btop/themes/adwaita.theme", target: "share/btop/themes/adwaita.theme", mode: 0o644,
           sha256: "f173660a9e03bf4c6d2a743bf5f9429d168a3e847c66a5d411fe680764f27bf6" },
        #{ source: "main/btop/themes/ayu.theme", target: "share/btop/themes/ayu.theme", mode: 0o644,
           sha256: "d5484417195f43235313c14764ffc7be5be1c40a1545f8fbe4d86e77e742dd89" },
        #{ source: "main/btop/themes/dracula.theme", target: "share/btop/themes/dracula.theme", mode: 0o644,
           sha256: "ca5f7a7a8aab828e2b3b464393797df1edc109e1aca11c716ff7f66947a05292" },
        #{ source: "main/btop/themes/dusklight.theme", target: "share/btop/themes/dusklight.theme", mode: 0o644,
           sha256: "713670fc54d8f39418e35955932c6ae51942b18e97515c1a7adf27aed20c562c" },
        #{ source: "main/btop/themes/elementarish.theme", target: "share/btop/themes/elementarish.theme", mode: 0o644,
           sha256: "01ae4d75ef7e1e47991bee90b2334ef210ac67c4f634d8e62d4557ebdbc443a7" },
        #{ source: "main/btop/themes/everforest-dark-hard.theme", target: "share/btop/themes/everforest-dark-hard.theme", mode: 0o644,
           sha256: "0104dcd7a9deaa8e71646ae9a90c6d693747135f07af58b249700d3fb71e58fa" },
        #{ source: "main/btop/themes/everforest-dark-medium.theme", target: "share/btop/themes/everforest-dark-medium.theme", mode: 0o644,
           sha256: "33d3fc5de3ce224745629840bbb0401fa87706e74a836846c4c91ba419070de7" },
        #{ source: "main/btop/themes/everforest-light-medium.theme", target: "share/btop/themes/everforest-light-medium.theme", mode: 0o644,
           sha256: "150290d8ebf26e884be19299af8d4ce0a24a0455fba1f8b03f18015fc49383a9" },
        #{ source: "main/btop/themes/flat-remix-light.theme", target: "share/btop/themes/flat-remix-light.theme", mode: 0o644,
           sha256: "307e1d86f4c97ea716fc09c80bbedaaaab47b2c09674dcaca186353aecb4f898" },
        #{ source: "main/btop/themes/flat-remix.theme", target: "share/btop/themes/flat-remix.theme", mode: 0o644,
           sha256: "e522964bc393daee1b558817b9efa4610da879aaf38f75dd7cbbc50aef9e6db9" },
        #{ source: "main/btop/themes/flexoki-dark.theme", target: "share/btop/themes/flexoki-dark.theme", mode: 0o644,
           sha256: "4c6b50e91321094454998b0dfbf38188b1ea1c5a1a4e100333c0fd325ff91875" },
        #{ source: "main/btop/themes/flexoki-light.theme", target: "share/btop/themes/flexoki-light.theme", mode: 0o644,
           sha256: "6aee64fd6f9c0266801205aa96194830599463d541d43c5ea0a41fbb473e3f08" },
        #{ source: "main/btop/themes/gotham.theme", target: "share/btop/themes/gotham.theme", mode: 0o644,
           sha256: "dad0b9e7091fb699379d4652bcb018d9b8f50492c3d02cda8254c3f2328aa6e0" },
        #{ source: "main/btop/themes/greyscale.theme", target: "share/btop/themes/greyscale.theme", mode: 0o644,
           sha256: "f04d535d4bcc836e3a3b86915117968003a2081b6b63051e9df9650a5a95aea9" },
        #{ source: "main/btop/themes/gruvbox_dark.theme", target: "share/btop/themes/gruvbox_dark.theme", mode: 0o644,
           sha256: "5a96a4398118ae1ffd3ab5c2cf613318537845304b91b3a97e61737c24f2997b" },
        #{ source: "main/btop/themes/gruvbox_dark_v2.theme", target: "share/btop/themes/gruvbox_dark_v2.theme", mode: 0o644,
           sha256: "fda7a4f3284c07869e4869c09996c71fd3ede5d9cb507fcfd1afdcfd53e81b66" },
        #{ source: "main/btop/themes/gruvbox_light.theme", target: "share/btop/themes/gruvbox_light.theme", mode: 0o644,
           sha256: "35c2b2ef59945b6ddfb0b5712cf0fbafd86458dc748e98228387d982f6354728" },
        #{ source: "main/btop/themes/gruvbox_material_dark.theme", target: "share/btop/themes/gruvbox_material_dark.theme", mode: 0o644,
           sha256: "b857066fc9607faa289195265cfb632821aacc3abae2f78819372ff07a521768" },
        #{ source: "main/btop/themes/horizon.theme", target: "share/btop/themes/horizon.theme", mode: 0o644,
           sha256: "c13a196565ffdb56faef6e765e8df2da1f4995a2ad70a196da15c28af990103f" },
        #{ source: "main/btop/themes/kanagawa-dragon.theme", target: "share/btop/themes/kanagawa-dragon.theme", mode: 0o644,
           sha256: "7734cb252d5545663eec703c5e3bc0a72ad9ebd51eb9746bc683b7b89fa7e284" },
        #{ source: "main/btop/themes/kanagawa-lotus.theme", target: "share/btop/themes/kanagawa-lotus.theme", mode: 0o644,
           sha256: "15f7cd94b9dbb80fca1cfadd24d8ca77aa7959d3c402c12c18cbb971bd0327f8" },
        #{ source: "main/btop/themes/kanagawa-wave.theme", target: "share/btop/themes/kanagawa-wave.theme", mode: 0o644,
           sha256: "94fb4e287bbea27c54936196824855879679869591a1450901bb8ffa2f56d835" },
        #{ source: "main/btop/themes/kyli0x.theme", target: "share/btop/themes/kyli0x.theme", mode: 0o644,
           sha256: "14a99dee96c0443818b5db0f8d806eaa3fffeb4f973b26a13db9ce8a0fb2446a" },
        #{ source: "main/btop/themes/matcha-dark-sea.theme", target: "share/btop/themes/matcha-dark-sea.theme", mode: 0o644,
           sha256: "24ce49c1bb23789357bb2419ab97361cca9b7c6d60a684b05bc9c889bbc8ea76" },
        #{ source: "main/btop/themes/monokai.theme", target: "share/btop/themes/monokai.theme", mode: 0o644,
           sha256: "160c5e7cae0d9b0ccd8ebc3d0c0def0ecb8be17123a9a4f3b61094f431a50bc7" },
        #{ source: "main/btop/themes/night-owl.theme", target: "share/btop/themes/night-owl.theme", mode: 0o644,
           sha256: "69e19d4dbe5e7fd9a788a0e1186040f7c12a46ce06da53f753783faa1c92fd79" },
        #{ source: "main/btop/themes/nord.theme", target: "share/btop/themes/nord.theme", mode: 0o644,
           sha256: "d4b43128675e091c5e191df246552e06dcaa738f38d80b8246e971e929241cbb" },
        #{ source: "main/btop/themes/onedark.theme", target: "share/btop/themes/onedark.theme", mode: 0o644,
           sha256: "733539fa76477655f4140e20009a3e6c168bcc9c62236b2d92398bc711cfc87e" },
        #{ source: "main/btop/themes/orange.theme", target: "share/btop/themes/orange.theme", mode: 0o644,
           sha256: "a9239d9b446aafce89f6c02a1d8a071bd9a6c84a3991fcb6695327503f6d9bc7" },
        #{ source: "main/btop/themes/paper.theme", target: "share/btop/themes/paper.theme", mode: 0o644,
           sha256: "54b699fb49f3dbe58f6e2e2818984cc9ffe8d699e2f5a107710873b5cdde23b7" },
        #{ source: "main/btop/themes/phoenix-night.theme", target: "share/btop/themes/phoenix-night.theme", mode: 0o644,
           sha256: "e88dba6ab8e12979536e289d65b9ec6abf561da7f4fa9a8b0da340d7b5139621" },
        #{ source: "main/btop/themes/solarized_dark.theme", target: "share/btop/themes/solarized_dark.theme", mode: 0o644,
           sha256: "d50ee145b1808ae218d4e9fc0eb2e4d8c6cc50369ec18404760708b20fc1034b" },
        #{ source: "main/btop/themes/solarized_light.theme", target: "share/btop/themes/solarized_light.theme", mode: 0o644,
           sha256: "e749f955e4328ac446c5e126e37d5b7d79d79863572513a879965d995b5879eb" },
        #{ source: "main/btop/themes/tokyo-night.theme", target: "share/btop/themes/tokyo-night.theme", mode: 0o644,
           sha256: "710c9c497f0a005b5090c4035ea6058746d178f8d21fa1ec3ade987f0bfacc70" },
        #{ source: "main/btop/themes/tokyo-storm.theme", target: "share/btop/themes/tokyo-storm.theme", mode: 0o644,
           sha256: "2ddd5caebd51ed21fdd4adcbddec7d0fe04cc5428012eaa6b9e6303962e13fbf" },
        #{ source: "main/btop/themes/tomorrow-night.theme", target: "share/btop/themes/tomorrow-night.theme", mode: 0o644,
           sha256: "2ecbfdc068038e60cd6e71c44f31ac7e4fc7545ef2ca8f7548ee891ff491b96f" },
        #{ source: "main/btop/themes/twilight.theme", target: "share/btop/themes/twilight.theme", mode: 0o644,
           sha256: "d3d7e6a2984030a0964c3db23329d5147b11edd36607818ab6789d6cbd0d4480" },
        #{ source: "main/btop/themes/whiteout.theme", target: "share/btop/themes/whiteout.theme", mode: 0o644,
           sha256: "5e908aa70a9fefcb65ca9be424659eba6831d46825197e1943328b01a2ec920a" },
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
