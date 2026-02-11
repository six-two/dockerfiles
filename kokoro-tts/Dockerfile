# Example usage: docker run --rm -it -v $PWD:/share ghcr.io/six-two/kokoro-tts /share/.gitignore /share/kokoro-tts/output.wav --voice af_alloy
FROM python:3.12-slim
RUN useradd --create-home app
USER app
# Download voices and model as described in the readme: https://github.com/nazdridoy/kokoro-tts
WORKDIR /home/app/
COPY download.py .
RUN python3 ./download.py; rm download.py

USER root
# Needed to prevent
# [...]
#   File "/home/app/.local/lib/python3.12/site-packages/sounddevice.py", line 71, in <module>
#     raise OSError('PortAudio library not found')
# OSError: PortAudio library not found
RUN apt-get update && apt-get install -y \
    python3-dev \
    build-essential \
    portaudio19-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
USER app

# Install the Kokoro CLI
RUN pip install --user --no-warn-script-location --no-cache-dir kokoro-tts

ENTRYPOINT ["/home/app/.local/bin/kokoro-tts"]
