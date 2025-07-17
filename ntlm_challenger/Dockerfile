FROM python:slim
RUN apt-get update && apt-get install --yes --no-install-recommends git && apt-get clean && rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN useradd --create-home app
USER app
RUN pip install --user --no-warn-script-location --no-cache-dir impacket requests
RUN git clone https://github.com/nopfor/ntlm_challenger /home/app/ntlm_challenger

ENTRYPOINT ["python3", "/home/app/ntlm_challenger/ntlm_challenger.py"]

