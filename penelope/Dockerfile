# Example usage: docker run --rm -it -p 4444:4444 -p 8000:8000 -v "$HOME/.penelope:/home/app/.penelope" ghcr.io/six-two/penelope

# Use a builder image, so that we do not have to have git installed in the final image
FROM python:slim AS builder
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --yes git
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir git+https://github.com/brightio/penelope

FROM python:slim
# Install net-tools (ifconfig) to allow penelope to list current network interfaces
RUN apt-get update && apt-get install --yes --no-install-recommends net-tools libcap2-bin && apt-get clean && rm -rf /var/lib/apt/lists/*
# Allow penelope to bind to low ports like 80 and 443 without root
RUN setcap 'cap_net_bind_service=+ep' "$(realpath /usr/local/bin/python3)"
RUN useradd --create-home app
USER app
COPY --from=builder /home/app /home/app/
# RUN pip install --user --no-warn-script-location --no-cache-dir /home/app/source
ENTRYPOINT ["/usr/local/bin/python3", "/home/app/.local/bin/penelope"]
