FROM python:slim
RUN useradd --create-home app --uid 1001
USER 1001:1001
WORKDIR /home/app/
RUN pip install --user --no-warn-script-location csv2md
ENTRYPOINT ["/home/app/.local/bin/csv2md"]

LABEL org.opencontainers.image.source=https://github.com/six-two/dockerfiles
