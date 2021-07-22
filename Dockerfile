FROM ubuntu:latest
WORKDIR /root/dotfiles
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  sudo \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*
COPY . .
RUN chmod +x install.sh
RUN ./install.sh
