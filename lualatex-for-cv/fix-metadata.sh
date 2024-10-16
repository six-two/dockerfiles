#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo "[!] Usage: <INPUT_FILE.pdf>"
    echo "Sets the matadata of the file based on the TITLE, AUTHOR, PRODUCER, and COPYRIGHT environment variables. Removes all other metadata like the used latex version."
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "[!] File '$1' does not exist. Did you specify the correct docker volume mount?"
    exit 1
fi

# Remove all metadata, then set title and the like
# SEE list of valid tags: https://www.exiftool.org/TagNames/XMP.html#pdf
exiftool -overwrite_original -all:all= -Title="${TITLE:-$1}" -Author="${AUTHOR}" -Producer="${PRODUCER}" -Copyright="${COPTRIGHT:-Copyright $(date +%Y)}" "$1"

# Optimize the pdf, make the old metadata unrecoverable
qpdf --linearize --replace-input "$1"
