// os-facts.rhai: written by `cargo xtask base groups`; do not edit.
// What a recipe needs to know about the system it is installed into (its name,
// website, desktop and palettes), from each variant's distro.toml (identity,
// profile, look). `of(format)` takes PACKAGE_FORMAT: `rpm` or `apk`.

fn of(format) {
    // AcornOS: distro/variants/acorn/distro.toml
    if format == "apk" {
        return #{
            id: "acornos",
            name: "AcornOS",
            home_url: "",
            desktop: "lxqt",
            appearance: "dark",
            light: #{
            surface: "#E6DFCF",
            surface_raised: "#EFE9DB",
            surface_sunken: "#D9D1BE",
            text: "#241A12",
            text_secondary: "#54483C",
            text_muted: "#6B5D4F",
            rule: "#C2B8A2",
            hairline: "#D0C7B3",
            accent: "#644532",
            highlight: "#214438",
            band: "#644532",
            on_band: "#F2EEE4",
            ok: "#2F6B3F",
            warn: "#7F5200",
            bad: "#B22F27",
        },
            dark: #{
            surface: "#1F1711",
            surface_raised: "#2B2019",
            surface_sunken: "#150F0A",
            text: "#F2EEE4",
            text_secondary: "#CDBFAE",
            text_muted: "#A89886",
            rule: "#4D3D30",
            hairline: "#382B21",
            accent: "#E4CBA6",
            highlight: "#C7D9BA",
            band: "#644532",
            on_band: "#F2EEE4",
            ok: "#A9CF9A",
            warn: "#F0B866",
            bad: "#F0A497",
        },
        };
    }
    // LevitateOS: distro/variants/levitate/distro.toml
    if format == "rpm" {
        return #{
            id: "levitateos",
            name: "LevitateOS",
            home_url: "https://levitateos.org",
            desktop: "plasma",
            appearance: "dark",
            light: #{
            surface: "#DDE2D2",
            surface_raised: "#E8ECDF",
            surface_sunken: "#CFD6C3",
            text: "#14221A",
            text_secondary: "#465047",
            text_muted: "#5C6459",
            rule: "#AEB8A4",
            hairline: "#C6CDB9",
            accent: "#214438",
            highlight: "#644532",
            band: "#214438",
            on_band: "#F2EEE4",
            ok: "#2F6B3F",
            warn: "#7F5200",
            bad: "#B22F27",
        },
            dark: #{
            surface: "#14221A",
            surface_raised: "#1D2D24",
            surface_sunken: "#0D1711",
            text: "#F2EEE4",
            text_secondary: "#BAC5B7",
            text_muted: "#9AA89D",
            rule: "#3A4B40",
            hairline: "#2A3B31",
            accent: "#C7D9BA",
            highlight: "#E4CBA6",
            band: "#214438",
            on_band: "#F2EEE4",
            ok: "#A9CF9A",
            warn: "#F0B866",
            bad: "#F0A497",
        },
        };
    }
    throw "os-facts.rhai: no facts for package format " + format;
}
