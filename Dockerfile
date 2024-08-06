FROM archlinux:base-devel-20240804.0.251467

ENV SHELL=/usr/bin/fish \
    EDITOR=nvim \
    VISUAL=nvim \
    SUDO_EDITOR=nvim \
    MANPAGER="nvim +Man!"

RUN pacman-key --init

RUN pacman -Syu --noconfirm --needed \
    chezmoi \
    fd \
    fish \
    git \
    nodejs \
    npm \
    ripgrep \
    unzip

RUN pacman -Scc --noconfirm

WORKDIR /root

COPY install-neovim.sh .

RUN ./install-neovim.sh nightly /usr/local/bin

RUN chezmoi init --apply gametaro
RUN nvim --headless \
    -c "Lazy! restore" \
    -c "TSInstallSync lua" \
    -c "MasonInstall lua-language-server stylua" \
    -c "qall"

EXPOSE 12345
ENTRYPOINT ["nvim"]
CMD ["--headless", "--listen", "0.0.0.0:12345"]
