#!/bin/bash
if [[ $# -ne 2 ]]; then
    echo "[!] Usage: <INPUT_FILE.pdf> <OUTPUT_BASENAME>"
    echo "Create a JPEG of every page form a PDF document. By default the PPI is set to 144 and the quality is 90% as a compromise between image quality and size."
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "[!] File '$1' does not exist. Did you specify the correct docker volume mount?"
    exit 1
fi

pdftoppm -jpeg -jpegopt quality=90 -r 144 "$1" "$2"
