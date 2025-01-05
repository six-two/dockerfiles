# Example usage: docker run --rm -it ghcr.io/six-two/hashid 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08
FROM python:slim
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir hashid

ENTRYPOINT ["/home/app/.local/bin/hashid"]
