#!/usr/bin/env sh
set -eu
~/.local/bin/nvim --headless "+Lazy! sync" +qa
