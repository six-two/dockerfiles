#!/bin/sh
LOG_LINES="${LOG_LINES:-50}"

if [[ $# -eq 0 ]]; then
    echo "[!] Usage: <INPUT_FILE.tex> [LUALATEX_ARGUMENTS...]"
    echo "Builds the tex file, fixes the EXIF metadata and creates an optimized version (that breaks links)"
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "[!] File '$1' does not exist. Did you specify the correct docker volume mount?"
    exit 1
fi

PDF_FILE="$(echo "$1" | sed 's/.tex$/.pdf/')"
# Remove the file to see if it can be built. Lualatex can fail with warnings, but still produce a PDF
[[ -f "$PDF_FILE" ]] && rm -- "$PDF_FILE"
if ! lualatex -interaction=batchmode "$@"; then
    echo "[!] Lualatex returned with error code $?. Last $LOG_LINES of the log are:"
    LOG_FILE="$(echo "$1" | sed 's/.tex$/.log/')"
    tail -n "$LOG_LINES" "$LOG_FILE"
fi

if [[ -f "$PDF_FILE" ]]; then
    if [[ -z "$SKIP_FIX_METADATA" ]]; then
        echo "[*] Fixing metadata for $PDF_FILE"
        /bin/fix-metadata.sh "$PDF_FILE"
    else
        echo "[*] Skipping fixing metadata because SKIP_FIX_METADATA is set"
    fi

    if [[ -z "$SKIP_OPTIMIZE" ]]; then
        echo "[*] Optimizing $PDF_FILE (will break links in .min.pdf)"
        /bin/optimize-break-links.sh "$PDF_FILE"
    else
        echo "[*] Skipping optimizing PDF because SKIP_OPTIMIZE is set"
    fi
else
    echo "[-] Output PDF not found, skipped optimisation and metadata fixes"
    exit 1
fi
