# dotfiles

[![CI](https://github.com/gametaro/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/gametaro/dotfiles/actions/workflows/ci.yml)
[![Lines Of Code](https://tokei.rs/b1/github/gametaro/dotfiles?category=code)](https://github.com/XAMPPRocky/tokei)

My personal dotfiles managed with [chezmoi](https://github.com/twpayne/chezmoi).

## Installation

```sh
git clone https://github.com/gametaro/dotfiles.git
cd dotfiles/
sh install.sh
```

or with chezmoi:

```sh
chezmoi init gametaro
```

or with docker:

```sh
git clone https://github.com/gametaro/dotfiles.git
cd dotfiles/
docker run ---rm -it $(docker build -q .)
```

## Benchmark

Tested with [hyperfine](https://github.com/sharkdp/hyperfine).

* [Neovim startup time](https://gametaro.github.io/dotfiles/dev/bench/)  
