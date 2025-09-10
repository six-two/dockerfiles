# Example usage: docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/mingw test.c -o test.exe 
FROM debian:stable-slim
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --yes mingw-w64 && useradd --create-home app
USER app

# Share current directory easily
VOLUME /share
WORKDIR /share

# By default cross-compile to Windows 64 bit
ENTRYPOINT ["/usr/bin/x86_64-w64-mingw32-gcc"]
