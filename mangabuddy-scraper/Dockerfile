# USAGE: docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/mangabuddy-scraper <URL>

# Builder image for compiling reliq and downloading mangabuddy-scraper
FROM alpine:latest as builder
RUN apk add --update --no-cache build-base git
USER 1001:1001
RUN cd /tmp; git clone https://github.com/TUVIMEN/reliq/; cd reliq; make all; cd ..; git clone https://github.com/TUVIMEN/mangabuddy-scraper/

# Minimal image that we just copy the built binaries into
FROM alpine:latest
RUN apk add --update --no-cache jq bash curl
COPY --from=builder /tmp/mangabuddy-scraper/mangabuddy-scraper /tmp/reliq/reliq /usr/bin/
USER 1001:1001
VOLUME /share
WORKDIR /share
ENTRYPOINT ["/usr/bin/mangabuddy-scraper"]
