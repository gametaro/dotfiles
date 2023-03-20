#!/usr/bin/env sh
set -eu

temp=$(mktemp -d)
cd "$temp"
curl -sSfL -O https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x ./nvim.appimage
./nvim.appimage --appimage-extract
ln -sf "$temp/squashfs-root/usr/bin/nvim" ~/.local/bin/nvim
