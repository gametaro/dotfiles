FROM ubuntu:20.04
WORKDIR /root
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  sudo \
  ca-certificates \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*
RUN sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply gametaro
