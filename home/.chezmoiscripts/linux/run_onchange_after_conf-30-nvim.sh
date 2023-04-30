#!/usr/bin/env bash
set -eu

"${XDG_DATA_HOME:-$HOME/.local/share}/rtx/installs/neovim/nightly/bin/nvim" --headless "+Lazy! sync" +qa
