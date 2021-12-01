#!/usr/bin/env bash

# shellcheck disable=SC2034
# NOTE: https://zenn.dev/odan/articles/17a86574b724c9
set -eu

{ for i in {1..10}; do
  command time --format="%e" nvim -c q
done; } >/dev/null 2>/tmp/nvim-startup-time

STARTUP_TIME=$(awk '{ total += $1 } END { print total/NR }' /tmp/nvim-startup-time)

cat <<EOJ
[
    {
        "name": "Neovim startup time",
        "unit": "Second",
        "value": ${STARTUP_TIME}
    }
]
EOJ
