#!/bin/bash
# Usage: docker run --rm -it -v "$PWD:/share" -p 127.0.0.1:8000:8000 ghcr.io/six-two/venv /bin/mkdocs-serve.sh
pip install -r requirements.txt
pip install .
mkdocs serve -a 0.0.0.0:8000
