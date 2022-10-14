FROM ubuntu:rolling
WORKDIR /root
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  sudo \
  ca-certificates \
  software-properties-common \
  gpg-agent \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply gametaro

RUN printf '#!/bin/bash\nexec /bin/bash -l -c "$*"' > /entrypoint.sh && \
  chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh", "nvim" ]
CMD [ "--headless", "--listen", "0.0.0.0:12345" ]
