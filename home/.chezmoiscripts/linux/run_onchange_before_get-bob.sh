#!/usr/bin/env sh
set -eu

if ! command -v bob >/dev/null && command -v unzip >/dev/null; then
  curl -sSfL -O https://github.com/MordechaiHadad/bob/releases/download/v1.2.1/bob-linux-x86_64.zip
  unzip bob-linux-x86_64.zip
  chmod u+x bob
  mv bob ~/.local/bin
  rm bob-linux-x86_64.zip
fi
