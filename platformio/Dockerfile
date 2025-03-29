# Example usage: docker run --rm -it -v "$HOME/.platformio:/home/app/.platformio" -v "$PWD:/share" ghcr.io/six-two/platformio

FROM python:slim
RUN apt-get update && apt-get install --yes --no-install-recommends git && apt-get clean && rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir platformio

# Share current directory easily
VOLUME /share
WORKDIR /share

ENTRYPOINT ["/home/app/.local/bin/platformio"]
# Build the current project by default
CMD ["-f", "run"]
