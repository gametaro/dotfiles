#!/usr/bin/env sh
set -eu

if ! command -v sheldon >/dev/null; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh |
    bash -s -- --force --repo rossmacarthur/sheldon --to ~/.local/bin
fi
