# Example usage: docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/smbcrawler crawl -i hosts.txt -u YOUR_AD_USERNAME -p YOUR_AD_PASSWORD -d example.lan -t 10 -D 0
FROM python:slim
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --yes g++ libpoppler-cpp-dev libmagic-dev
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir smbcrawler

# Default ports
EXPOSE 8080
EXPOSE 8443

# Share current directory easily
VOLUME /share
WORKDIR /share

ENTRYPOINT ["/home/app/.local/bin/smbcrawler"]
