# dotfiles

[![CI](https://github.com/gametaro/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/gametaro/dotfiles/actions/workflows/ci.yml)
[![Lines Of Code](https://tokei.rs/b1/github/gametaro/dotfiles?category=code)](https://github.com/XAMPPRocky/tokei)

My personal dotfiles managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Installation

Unix:

```bash
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin init --apply gametaro

# for transitory environments
sh -c "$(curl -fsLS chezmoi.io/get)" -- -b ~/.local/bin init --one-shot gametaro
```

Windows:

```powershell
iex "& { $(irm https://chezmoi.io/get.ps1) } "
.\bin\chezmoi init --apply gametaro
```
With chezmoi:

```bash
chezmoi init gametaro
```

With docker:

```bash
git clone --depth 1 https://github.com/gametaro/dotfiles.git
cd dotfiles/
docker run --rm -it $(docker build -q .)
```

## Benchmark

Tested with [hyperfine](https://github.com/sharkdp/hyperfine).

* [Neovim startup time](https://gametaro.github.io/dotfiles/dev/bench/)  
