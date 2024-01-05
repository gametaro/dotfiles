#!/bin/sh

set -eu

VERSION=${1:-"nightly"}
BIN_DIR=${2:-"$HOME/.local/bin"}
EXTRACT_PATH="$HOME/.local/share/neovim"
APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/$VERSION/nvim.appimage"
CHECKSUM_URL="$APPIMAGE_URL.sha256sum"

cleanup() {
  rm -rf -- "${TEMP_DIR}"
}

setup() {
  TEMP_DIR=$(mktemp -d)
  APPIMAGE_PATH="$TEMP_DIR/nvim.appimage"
  CHECKSUM_PATH="$APPIMAGE_PATH.sha256sum"

  trap cleanup EXIT
  trap 'exit' INT TERM
}

download() {
  url=$1
  path=$2

  if command -v wget >/dev/null; then
    wget -q -O "$path" "$url"
  elif command -v curl >/dev/null; then
    curl -fsLS "$url" -o "$path"
  else
    echo "Error: wget or curl is required." >&2
    exit 1
  fi
}

verify_and_install() {
  cd "$TEMP_DIR"
  sha256sum -c "$(basename "$CHECKSUM_PATH")"

  chmod u+x "$APPIMAGE_PATH"
  "$APPIMAGE_PATH" --appimage-extract >/dev/null

  mkdir -p "$EXTRACT_PATH"
  rm -rf "$EXTRACT_PATH/squashfs-root"
  mv "squashfs-root" "$EXTRACT_PATH"
  ln -sf "$EXTRACT_PATH/squashfs-root/AppRun" "$BIN_DIR/nvim"
}

main() {
  setup
  mkdir -p "$BIN_DIR"
  cd "$BIN_DIR" || exit 1
  BIN_DIR=$(pwd)

  echo "Downloading Neovim..."
  download "$APPIMAGE_URL" "$APPIMAGE_PATH"
  download "$CHECKSUM_URL" "$CHECKSUM_PATH"

  verify_and_install

  echo "Neovim installation completed. Run 'nvim' to start Neovim."
}

main
