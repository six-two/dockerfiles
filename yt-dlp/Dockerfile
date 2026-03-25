# Example usage: docker run --rm -it -v "$PWD:/share" -w "/share" ghcr.io/six-two/yt-dlp https://www.youtube.com/watch?v=dQw4w9WgXcQ
FROM python:slim
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir yt-dlp

ENTRYPOINT ["/home/app/.local/bin/yt-dlp"]
