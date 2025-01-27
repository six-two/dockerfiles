# Usage: docker run -v "$PWD:/share" ghcr.io/six-two/ffmpeg-rubberband -i input.mp3 -filter:a "rubberband=tempo=2" output-twice-as-fast.mp3 -y
FROM ubuntu:25.04

RUN apt-get update && apt-get install --yes --no-install-recommends ffmpeg rubberband-cli bash && apt-get clean && rm -rf /var/lib/apt/lists/*

# Drop root
RUN useradd --create-home app
USER app

# Share current directory easily
VOLUME /share
WORKDIR /share

ENTRYPOINT ["/usr/bin/ffmpeg"]
