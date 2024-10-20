# Example usage: docker run --rm -it -v "$PWD:/share" sourcemapper -output . -jsurl https://example.com/somescript.js
FROM golang:latest as builder
RUN useradd --create-home app --uid 1001
USER 1001:1001
RUN git clone https://github.com/denandz/sourcemapper /home/app/sourcemapper
RUN cd /home/app/sourcemapper && go get && go build

FROM debian:bookworm-slim
COPY --from=builder /home/app/sourcemapper/sourcemapper /bin/sourcemapper
VOLUME /share
WORKDIR /share
ENTRYPOINT ["/bin/sourcemapper"]
