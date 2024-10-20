# USAGE: docker run --rm -it ghcr.io/six-two/ffuf -u http://127.0.0.1:8000/FUZZ -w /wordlists/common.txt -mc 200
FROM alpine
RUN apk add --update --no-cache ffuf
RUN adduser app -D
USER app
COPY *.txt /wordlists/
VOLUME /share
WORKDIR /share
ENTRYPOINT ["ffuf"]
