#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd -- "$SCRIPT_DIR"

is_installed() {
    command -v "$1" &>/dev/null
}

print_valid_images() {
    echo "[*] Valid values for <DOCKER_IMAGE> are:"
    for FILE in *; do
        if [[ -f "$FILE/Dockerfile" ]]; then
            echo "     - $FILE"
        fi
    done
}

DOCKER="${DOCKER:-docker}"
if ! is_installed docker; then
    if is_installed podman; then
        echo "[*] Docker is not installed, using podman instead"
        DOCKER=podman
    else
        echo "[!] Neither docker nor podman are installed"
        exit 1
    fi
fi

if [[ $# -ge 1 ]]; then
    NAME="$1"
    shift
    if [[ -f "$NAME/Dockerfile" ]]; then
        cd "$NAME"
        "$DOCKER" build . -t "ghcr.io/six-two/$NAME" "$@"
    else
        echo "[!] Unknown docker image '$NAME'"
        print_valid_images
        exit 1
    fi
else
    echo "[!] Usage: <DOCKER_IMAGE> [DOCKER_BUILD_ARGS...]"
    # examples or arguments: --no-cache 
    print_valid_images
    exit 1
fi
