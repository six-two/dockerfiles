# Example usage: docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/venv
FROM python:slim
COPY entrypoint.sh mkdocs-serve.sh /bin/
RUN useradd --create-home app
USER app

# Share current directory easily
VOLUME /share
WORKDIR /share

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD []
