# Example usage: docker run --rm -it -v "$PWD:/src" ghcr.io/six-two/semgrep-extra-rules
# Prepare builder image
FROM alpine:latest AS builder
RUN apk add --no-cache curl git
RUN adduser build -D
USER build
WORKDIR /rules

# Download the rules
COPY download-rules.sh /bin/download-rules.sh
RUN /bin/download-rules.sh /rules/

# Copy rules to final image and make it use non-root
FROM semgrep/semgrep:latest
COPY --from=builder /rules /rules
RUN adduser app -D
USER app

ENV SEMGREP_SEND_METRICS=off
WORKDIR /src
ENTRYPOINT ["semgrep"]
CMD ["scan", "--metrics=off", "--no-git-ignore", "--disable-nosem", "--sarif-output=semgrep.sarif", "--config=/rules", "."]
