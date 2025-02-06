# Usage: docker run --rm -it -p 8081:8010 -v "$PWD/languagetool/test/:/share:ro" ghcr.io/six-two/languagetool
FROM erikvl87/languagetool
COPY entrypoint.sh /bin/
CMD ["bash", "/bin/entrypoint.sh"]
