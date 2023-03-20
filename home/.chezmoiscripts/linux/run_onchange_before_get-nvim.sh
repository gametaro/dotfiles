#!/usr/bin/env sh
set -eu

temp=$(mktemp -d)
cd "$temp"
curl -sSfL -O https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod a+x ./nvim.appimage
./nvim.appimage --appimage-extract
ln -sf "$temp/nvim.appimage" ~/.local/bin/nvim
