# LevitateOS Recipes

Base package recipes for LevitateOS.

## Structure

```
base.recipe           # Filesystem hierarchy + essential configs
linux.recipe          # Kernel
linux-firmware.recipe # Firmware blobs
systemd.recipe        # Init system + bootctl
networkmanager.recipe # Networking
bash.recipe           # Shell
coreutils.recipe      # Core utilities (ls, cp, etc.)
util-linux.recipe     # System utilities (mount, fdisk, etc.)
recipe.recipe         # Package manager (self-hosting)
```

## Usage

### Bootstrap a new system

```bash
# Mount your target partition
mount /dev/sdX1 /mnt

# Bootstrap base system
recipe bootstrap /mnt --recipe-dir /path/to/recipes

# Chroot and configure
arch-chroot /mnt
```

### Install individual packages

```bash
recipe install bash --recipe-dir .
recipe install coreutils --recipe-dir .
```

### List available packages

```bash
recipe list --recipe-dir .
```

## Recipe Format

Recipes use S-expressions:

```lisp
(package "name" "version"
  (description "Package description")
  (license "LICENSE-ID")
  (homepage "https://...")

  (acquire
    (source "https://..." (sha256 "...")))

  (build-deps
    (dep1)
    (dep2))

  (deps
    (runtime-dep))

  (build
    (steps
      (configure "...")
      (compile "...")))

  (install
    (to-bin "binary")
    (to-lib "library")
    (shell "custom install command")))
```

## CI Validation

All recipes are validated on push/PR via GitHub Actions.
