const RECIPE_API = 1;
// Meta Muse code CLI 1.4.18-R8587.1, x86_64 Linux single binary (not an archive).
// SHA-256 and size: Meta's release manifest for this version, the one the official launcher checks; verified against our
// own anonymous download (no login needed). The installed file is that same file, so one digest serves as both.
// file(1): ELF 64-bit x86-64, statically linked, stripped, so it runs on both OS variants.
// The recipe fetches it from Meta at install time; nothing is redistributed. Licence: no licence text was found in the
// launcher, installer or binary, so the field says proprietary (Meta terms).
// Meta advertises only the current version on its channel API, so this pin can stop downloading when Meta retires it.
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
        download: "Downloads the pinned file from Meta and checks it against the digest in Meta's release manifest.",
        install: "Puts the muse command in bin.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "muse", version: "1.4.18-R8587.1", description: "Meta Muse terminal coding agent" };
// No UPSTREAM: Meta's channel API names only the current version, and no latest() is written for it.

const SOURCES = #{
    release: #{
        url: "https://lookaside.facebook.com/lookaside/muse/download/?channel=muse&version=1.4.18-R8587.1&file=muse-x86-linux",
        sha256: "57732db89e25a58196c923b3790aa3e2a85b8d1ad5094492384792260e65b538",
        // The URL ends in a query, so the saved file's name is given.
        file: "muse-1.4.18-R8587.1-x86-linux",
    },
};

// A lone plain-file source is named by its source name: there is no path inside it.
const FILES = [
    ["release", "bin/muse", 0o755],
];
