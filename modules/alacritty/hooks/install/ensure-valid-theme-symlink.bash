#!/usr/bin/env bash
set -eu -o pipefail

symlink="$TARGET/.config/alacritty/current-theme.toml"

if dest=$(readlink -f "$symlink") && [[ -f $dest ]]; then
    :
    # Already set up.
else
    ln -sf dark-theme.toml "$symlink"
fi
