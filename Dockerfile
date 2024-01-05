# Use a specific version of archlinux base image with development tools
# FROM archlinux:base-devel-20231112.0.191179
FROM archlinux:base-devel-20231105.0.189722

# Set environment variables
ENV SHELL=/usr/bin/fish \
    EDITOR=nvim \
    VISUAL=nvim \
    SUDO_EDITOR=nvim \
    MANPAGER="nvim +Man!"

# Update system and install necessary packages
RUN pacman -Syu --noconfirm \
    chezmoi \
    fd \
    fish \
    git \
    nodejs \
    npm \
    ripgrep && \
    pacman -Scc --noconfirm

WORKDIR /root

COPY install-neovim.sh .

RUN /root/install-neovim.sh nightly /usr/local/bin

# Copy configuration and run headless installation of plugins
RUN chezmoi init --apply gametaro --branch simplify
RUN nvim --headless "+Lazy! restore" +qa

# Expose port for the service and set entrypoint and default command
EXPOSE 12345
ENTRYPOINT ["nvim"]
CMD ["--headless", "--listen", "0.0.0.0:12345"]
