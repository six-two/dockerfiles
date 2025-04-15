# Example usage: docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/pytools
FROM python:slim
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir build pip-tools twine

# Share current directory easily
VOLUME /share
WORKDIR /share
# Add python tools to PATH
ENV PATH=$PATH:/home/app/.local/bin/

ENTRYPOINT []
CMD ["/bin/bash", "-c", "rm -r ./dist/; python -m build"]
