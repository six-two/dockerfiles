FROM ghcr.io/ifilot/lualatex-debian12:v0.6.0

# Temporarily switch back to root to install the package(s)
USER root
RUN DEBIAN_FRONTEND=noninteractive apt install --yes exiftool qpdf poppler-utils
COPY *.sh /bin/
USER lualatex

ENTRYPOINT ["/bin/entrypoint.sh"]
