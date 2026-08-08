FROM alpine
RUN apk add --update --no-cache bash qpdf ghostscript
RUN adduser app -D
COPY merge.sh /bin/
USER app

VOLUME /share
WORKDIR /share
ENTRYPOINT ["/bin/bash", "/bin/merge.sh"]
