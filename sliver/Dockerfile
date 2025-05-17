# Usage: docker run -it -v "$PWD:/share" -v "$HOME/.sliver:/home/app/.sliver" -p 53:53 -p 80:80 -p 443:443 -p 8888:8888 ghcr.io/six-two/sliver
FROM kalilinux/kali-rolling

RUN apt-get update && apt-get install --yes sliver tmux && apt-get clean && rm -rf /var/lib/apt/lists/*

# Drop root
RUN useradd --create-home -s /bin/bash app && touch /home/app/.hushlogin
USER app

# Share current directory easily
VOLUME /share
WORKDIR /share

# Default ports used for Wireguard/DNS, HTTP, HTTPS and MTLS
EXPOSE 53
EXPOSE 80
EXPOSE 443
EXPOSE 8888

CMD ["/usr/bin/sliver-server"]
