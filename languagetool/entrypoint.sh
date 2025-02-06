#!/bin/sh

# Add custom words to the language files using a mounted share.
# Based on idea from http://wiki.languagetool.org/hunspell-support
for FILE in /share/custom_words_*.txt; do
    LANG="$(echo -n "$FILE" | sed -e 's|^/share/custom_words_||' -e 's|.txt$||')"

    if [[ "$LANG" == any ]]; then
        echo "[*] $FILE: Adding $(wc -l "$FILE") custom words for all languages"
        for OUT_FILE in /LanguageTool/org/languagetool/resource/*/hunspell/spelling.txt; do
            (echo; cat "$FILE") >> "$OUT_FILE"
        done
    elif [[ -f "/LanguageTool/org/languagetool/resource/${LANG}/hunspell/spelling.txt" ]]; then
        echo "[*] $FILE: Adding $(wc -l "$FILE") custom words for language $LANG"
        (echo; cat "$FILE") >> "/LanguageTool/org/languagetool/resource/${LANG}/hunspell/spelling.txt"
    else
        echo "[-] $FILE: Unknown language: $LANG"
    fi
done

# Now call the default entrypoint script
exec bash /LanguageTool/start.sh
