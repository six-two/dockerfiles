# Example usage:
# Oneshot: echo "こんにちは" | docker run --rm -i ghcr.io/six-two/romaji-converter
# Web server: docker run --rm -p 8000:8000 ghcr.io/six-two/romaji-converter --port 8000
#    Client request: curl -X POST http://localhost:8000/romanize -H "Content-Type: application/json" -d '{"text": "こんにちは"}'
FROM python:slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir cutlet fugashi[unidic] fastapi uvicorn

RUN python -m unidic download

WORKDIR /app
COPY app.py /app/

ENTRYPOINT ["python", "app.py"]