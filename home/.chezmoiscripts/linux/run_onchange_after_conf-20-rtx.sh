#!/usr/bin/env sh
set -eu

rtx="${XDG_DATA_HOME:-$HOME/.local/share}/rtx/bin/rtx"
$rtx trust
$rtx install
$rtx list
