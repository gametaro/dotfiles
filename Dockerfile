FROM ubuntu:latest
WORKDIR /root
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  sudo \
  ca-certificates \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*
RUN sh -c "$(curl -fsLS git.io/chezmoi)" -- -b ~/.local/bin init --apply gametaro
