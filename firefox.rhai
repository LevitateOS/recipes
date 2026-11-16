const RECIPE_API = 1;
// firefox: a Recipe group, installed into the system root (`recipe --system install firefox`)
// with a receipt, so it can be removed or replaced like any other recipe. It is
// a share of the packages the OS images shipped burned in until now: the same
// builds, pinned to the base and desktop locks of each OS.
//
// Hand-written: ABOUT, the seeds per C library, the accounts and the groups it
// needs (deps). Generated: firefox.pins beside this file (the pinned packages and
// the group's version), written by `cargo xtask base groups levitate` (glibc:
// Fedora RPMs) and `cargo xtask base groups acorn` (musl: Alpine APKs) from the
// seeds below. A package more than one group needs belongs to desktop-libs.
const NEEDS = #{
    outputs: #{ system: "directory" },
    network: ["dl.fedoraproject.org:443", "dl-cdn.alpinelinux.org:443"],
    memory_mib: 4096,
    storage_max_objects: 262144,
    timeout_secs: 7200,
};

import "os-facts.rhai" as os_facts;

const ABOUT = #{
    kind: "app",
    category: "web",
    libc: ["glibc", "musl"],
    systems: ["levitateos", "acornos"],
    details: "Firefox, Mozilla's web browser, as the distribution builds it: Fedora's build on LevitateOS, Alpine's on AcornOS.",
    homepage: "https://www.firefox.com",
    license: "MPL-2.0",
    adds: #{ programs: ["firefox"], menu: ["Firefox"] },
    steps: #{
        download: "Takes each pinned package by its SHA-256, from the install medium's cache or the distribution's mirror.",
        install: "Unpacks the packages natively into one system tree, without running their scripts, and writes it into the system root with a receipt.",
    },
    keeps: [],
};

const PACKAGE = #{ name: "firefox", description: "The Firefox web browser" };   // version: firefox.pins

// What this group installs, by name; the generator adds what they need.
// glibc: LevitateOS (Fedora 45). musl: AcornOS (Alpine 3.24).
const PACKAGES = #{
    glibc: ["firefox"],
    musl:  ["firefox"],
};

let deps = ["desktop-libs"];

// Firefox as the OS's browser (the OS builder's `browser`, moved here): the
// distribution it names is the OS (distribution.ini), the packaged default
// preferences keep everything but the distribution's start page and pinned
// new-tab sites (renamed for the OS), and a policy turns off telemetry,
// studies, the first-run and what's-new pages and the browser's own updater
// (Recipe updates it), opens the OS's website at start where it has one, and
// gives one bookmark: levitateos.org, on the toolbar.
fn configure(tree) {
    let os = os_facts::of(PACKAGE_FORMAT);
    let dir = if PACKAGE_FORMAT == "rpm" { "usr/lib64/firefox/" } else { "usr/lib/firefox/" };
    tree_text(tree, dir + "distribution/distribution.ini");
    put(tree, dir + "distribution/distribution.ini",
        "[Global]\nid=" + os.id + "\nversion=1.0\nabout=Mozilla Firefox for " + os.name + "\n\n[Preferences]\napp.distributor=" + os.id + "\napp.distributor.channel=" + os.id + "\n",
        0o644);
    let prefs = dir + "browser/defaults/preferences/";
    let packaged = if PACKAGE_FORMAT == "rpm" { "firefox-redhat-default-prefs.js" } else { "vendor.js" };
    let text = "";
    for line in tree_text(tree, prefs + packaged).split("\n") {
        if line.contains("browser.startup.homepage") || line.contains("browser.newtabpage.pinned") { continue; }
        text += line + "\n";
    }
    rm(join_path(tree, prefs + packaged));
    put(tree, prefs + os.id + "-default-prefs.js", text, 0o644);
    let policies = "{\n  \"policies\": {\n";
    policies += "    \"DisableTelemetry\": true,\n    \"DisableFirefoxStudies\": true,\n    \"DisableAppUpdate\": true,\n";
    policies += "    \"DontCheckDefaultBrowser\": true,\n    \"OverrideFirstRunPage\": \"\",\n    \"OverridePostUpdatePage\": \"\",\n";
    if os.home_url != "" {
        policies += "    \"Homepage\": {\"URL\": \"" + os.home_url + "\", \"StartPage\": \"homepage\"},\n";
    }
    policies += "    \"NoDefaultBookmarks\": true,\n";
    policies += "    \"Bookmarks\": [{\"Title\": \"LevitateOS\", \"URL\": \"https://levitateos.org\", \"Placement\": \"toolbar\"}],\n";
    policies += "    \"UserMessaging\": {\"ExtensionRecommendations\": false, \"FeatureRecommendations\": false, \"MoreFromMozilla\": false, \"SkipOnboarding\": true}\n";
    policies += "  }\n}\n";
    put(tree, dir + "distribution/policies.json", policies, 0o644);
}
