# Example usage: docker run --rm -it -v "$PWD:/share" -p 8080:8080 -p 8443:8443 ghcr.io/six-two/powerhub your-local-hostname-or-domain-fronting.com --no-auth
FROM python:slim
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --yes mono-mcs gcc-mingw-w64-x86-64 gcc-mingw-w64-i686 libmagic1 git
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir powerhub

# Default ports
EXPOSE 8080
EXPOSE 8443

# Share current directory easily
VOLUME /share
WORKDIR /share
# This makes powerhub create/read its state and configuration from /share/powerhub. This means your clipboard entries, uploaded files, modules, etc will be persisted.
ENV XDG_DATA_HOME=/share

ENTRYPOINT ["/home/app/.local/bin/powerhub"]
