#!/usr/bin/env python3
import urllib.request
files = ['https://github.com/nazdridoy/kokoro-tts/releases/download/v1.0.0/voices-v1.0.bin', 'https://github.com/nazdridoy/kokoro-tts/releases/download/v1.0.0/kokoro-v1.0.onnx']
for url in files:
    response = urllib.request.urlopen(url)
    with open(url.split('/')[-1], 'wb') as f:
        f.write(response.read())
