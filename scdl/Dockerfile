# Example usage: docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/scdl -l https://soundcloud.com/rick-astley-official/never-gonna-give-you-up-4
FROM python:slim
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --yes ffmpeg
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir scdl

# Share current directory easily
VOLUME /share
WORKDIR /share

ENTRYPOINT ["/home/app/.local/bin/scdl"]
