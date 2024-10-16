#!/bin/sh
if [[ $# -ne 1 && $# -ne 2 ]]; then
    echo "[!] Usage: <INPUT_FILE.pdf> [OUTPUT_FILE.pdf]"
    echo "Minifies <FILE.pdf> and saves the result as <OUTPUT_FILE.pdf>. If <OUTPUT_FILE.pdf> is not specified, <INPUT_FILE.min.pdf> is used. The minification will break elements like links. If you need links if you document, use docker.io/ptspts/pdfsizeopt instead"
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "[!] File '$1' does not exist. Did you specify the correct docker volume mount?"
    exit 1
fi

if [[ $# -eq 1 ]]; then
    OUT_FILE="$(echo "$1" | sed 's/\.pdf$/.min.pdf/')"
else
    OUT_FILE="$2"
fi

gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 \
        -dPDFSETTINGS=/screen -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=144 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=144 \
        -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=144 \
        -sOutputFile="$OUT_FILE" \
        "$1"
