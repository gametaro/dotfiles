#!/usr/bin/env sh
set -eu

if ! command -v nvim >/dev/null; then
  curl -sSfL -O https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
  mkdir -p ~/.local/share/dotfiles
  tar xf nvim-linux64.tar.gz -C ~/.local/share/dotfiles --strip-components 1
  rm nvim-linux64.tar.gz
  ln -sf ~/.local/share/dotfiles/bin/nvim ~/.local/bin
fi
