# LevitateOS recipes

The official source of software for LevitateOS and AcornOS: what a person
chooses and manages themselves, apart from the OS image. Each `NAME.rhai` is a
recipe that [Recipe](https://github.com/LevitateOS/recipe) runs inside Ginux
and installs into a profile. [ripgrep](ripgrep.rhai) is the first.

The systems ship this source, so nothing needs adding there:

```sh
recipe list
sudo recipe install ripgrep
sudo recipe update ripgrep
sudo recipe remove ripgrep
```

Elsewhere, add it once:

```sh
recipe source add https://github.com/LevitateOS/recipes --branch master
```

## How it is used

Recipe does not clone this repository. It fetches [`index.json`](index.json),
which lists every recipe with what a front end shows about it and the SHA-256
and size of each of its files. A recipe's files are downloaded when it is
installed, at the commit the index names, and checked against the index. A
file that differs stops the install before anything runs.

An image carries a copy of this repository at the commit it was built from, so
the recipes in it install without a network until a newer index is fetched.

## Changing a recipe

1. Edit or add `NAME.rhai`, following the
   [authoring contract](https://github.com/LevitateOS/recipe/blob/master/WRITING_RECIPES.md).
   `recipe info ./NAME.rhai` checks that it compiles.
2. Commit.
3. Run `recipe index` here and commit `index.json`.

`recipe index` refuses a recipe that cannot be read and a file that is not
committed. A push whose index is behind the recipes fails the Index check.

## Layout

- One flat folder. A recipe's `name` equals its file name.
- Every `.rhai` file is a recipe on its own, with `RECIPE_API`, `NEEDS` and an
  `ABOUT` block. User programs publish a directory output named `package`
  holding regular `bin/COMMAND` and `share/PATH` files.
- Build tools publish `tools` instead, are named only under `build_deps`, and
  are never activated into a profile. Their `ABOUT.kind` is `library` so a
  front end hides them until asked. Both OS variants use the same glibc build
  image; these tools run there, independently of the host C library.
- Files beside a recipe that share its name belong to it and are fetched with
  it: `NAME.svg` is its icon.
- [`repo.toml`](repo.toml) is what this source says about itself.
- [`generators/`](generators) holds scripts that write pinned parts of a
  recipe, not recipes: `desktop-runtime-pins.py` regenerates the Fedora pins
  of [desktop-runtime](desktop-runtime.rhai) (`--check` only reports), and
  `check-closure.sh` checks a published sdk with the host's `readelf`.
- A recipe runs without defines the OS builder would have to pass. The recipes
  that build the OS images are not here; they are in the builder.

To work on recipes with Recipe reading this checkout as it is, edits included:

```sh
recipe source add --path .
```
