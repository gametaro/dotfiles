# dotfiles

[![CI](https://github.com/gametaro/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/gametaro/dotfiles/actions/workflows/ci.yml)
[![Lines Of Code](https://tokei.rs/b1/github/gametaro/dotfiles?category=code)](https://github.com/XAMPPRocky/tokei)

My personal dotfiles managed with [chezmoi](https://github.com/twpayne/chezmoi).

## OS

* Linux
* macOS
* Windows

## Requisites

### Linux/macOS

* `curl` or `wget`

### Windows

* `PowerShell`

## Installation

* Linux/macOS

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply gametaro

# for transitory environments
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --one-shot gametaro
```

* Windows

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
(irm -useb https://get.chezmoi.io/ps1) | powershell -c -
bin/chezmoi.exe init --apply gametaro
```

* Docker

```bash
git clone --depth 1 https://github.com/gametaro/dotfiles.git
cd dotfiles/
docker run --rm -it $(docker build -q .)
```

## Benchmark

Tested with [hyperfine](https://github.com/sharkdp/hyperfine).

* [Neovim startup time](https://gametaro.github.io/dotfiles/dev/bench/)
