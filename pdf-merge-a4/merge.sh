#!/bin/bash
set -e

usage() {
    echo "Usage: merge.sh [file1.pdf file2.pdf ...] [-o output.pdf]"
    echo "  If no input files given, merges all *.pdf in the current directory."
    exit 1
}

OUTPUT="/output/merged.pdf"
INPUTS=()

while [ $# -gt 0 ]; do
    case "$1" in
        -o) shift; OUTPUT="$1" ;;
        -h|--help) usage ;;
        -*) echo "Unknown option: $1" >&2; usage ;;
        *) INPUTS+=("$1") ;;
    esac
    shift
done

if [ ${#INPUTS[@]} -eq 0 ]; then
    INPUTS=(*.pdf)
    if [ ! -f "${INPUTS[0]}" ]; then
        echo "ERROR: No PDF files found in current directory." >&2
        exit 1
    fi
fi

# Remove output file from input list if present
FILTERED=()
for f in "${INPUTS[@]}"; do
    if [ "$(realpath "$f" 2>/dev/null || echo "$f")" != "$(realpath "$OUTPUT" 2>/dev/null || echo "$OUTPUT")" ]; then
        FILTERED+=("$f")
    fi
done
INPUTS=("${FILTERED[@]}")

if [ ${#INPUTS[@]} -eq 0 ]; then
    echo "ERROR: No input files remaining after excluding output." >&2
    exit 1
fi

for f in "${INPUTS[@]}"; do
    echo "[*] Input:  $f"
done
echo "[*] Output: $OUTPUT"

TMPFILE="/tmp/merged.pdf"
trap 'rm -f "$TMPFILE"' EXIT

# Merge all inputs, then flatten /Rotate into content so Ghostscript
# sees correct orientation without needing to interpret rotation metadata
qpdf --empty --pages "${INPUTS[@]}" -- "$TMPFILE" \
  && qpdf --flatten-rotation "$TMPFILE" --replace-input

gs -q -dBATCH -dNOPAUSE -dSAFER \
   -sDEVICE=pdfwrite \
   -dFIXEDMEDIA -dPDFFitPage -dAutoRotatePages=/None \
   -dDEVICEWIDTHPOINTS=595.28 -dDEVICEHEIGHTPOINTS=841.89 \
   -sOutputFile="$OUTPUT" \
   "$TMPFILE"

echo "[*] Done"