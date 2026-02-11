# Example usage: docker run --rm -it -v "$PWD:/share" -w "/share" ghcr.io/six-two/firescan
# Prepare builder image
FROM golang:alpine AS builder
RUN apk add --no-cache git
RUN adduser build -D
USER build
WORKDIR /app

# Build the application
RUN git clone https://github.com/JacobDavidAlcock/firescan.git .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o firescan ./cmd/firescan

# Copy binary to final image
FROM alpine:latest
RUN apk add --no-cache ca-certificates
RUN adduser app -D
COPY --from=builder /app/firescan /usr/local/bin/firescan
USER app
ENTRYPOINT ["firescan"]
