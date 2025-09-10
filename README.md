# Dockerfiles

Dockerfiles for my manually build images hosted at GitHub Container Registry (ghcr.io).
You can see all images (including the ones built by GitHub Actions for my other projects) on my [packages page](https://github.com/six-two?tab=packages).

## Usage

Convenience script to build and tag a container (here `nmap-rootless`):
```bash
./build-image.sh nmap-rootless
```

### Push

Create a personal access token in the `Developer Settings` of the Github account.
Log in with it as a password:
```bash
docker login --username six-two --password ghp_REDACTED ghcr.io
```

After building an image, you can push it with:
```bash
docker push ghcr.io/six-two/nmap-rootless
```

When you first push an image, its visibility is set to private.
So you need to go to the image page -> `Package Settings` -> Section `Danker Zone` -> `Visibility`, choose `public` and confirm.

To allow the GitHub Actions to update the image, you also need to allow the repository access: `Package Settings` -> section `Manage Actions access` -> `Add Repository` -> select `dockerfiles` -> change `Role` to `Write`

## Containers

### csv2md

Just a dockerfile for <https://github.com/lzakharov/csv2md> that uses a non-root user.
You can use it as a template for any other pip package, if you just replace `csv2md` with the package you want to containerize.

Jou can just pipe your CSV input into the docker command to convert it to a Markdown table:
```bash
echo -e "a,b,c\n1,2,3" | docker run --rm -i ghcr.io/six-two/csv2md
```

### ffmpeg-rubberband

A container for ffmpeg with the `rubberband` filter.
It can be used to speed up or slow down music, while keeping the pitch the same.

Example usage:
```bash
docker run -v "$PWD:/share" ghcr.io/six-two/ffmpeg-rubberband -i input.mp3 -filter:a "rubberband=tempo=2" output-twice-as-fast.mp3 -y
```

### ffuf

Just installs `ffuf` with apk and adds a couple wordlists I like to use for directory busting from [SecLists](https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content).

Example invocation using included wordlist:
```bash
docker run --rm -it ghcr.io/six-two/ffuf -u http://127.0.0.1:8000/FUZZ -w /wordlists/common.txt -mc 200
```

Example invocation using a custom wordlist:
```bash
docker run --rm -it ghcr.io/six-two/ffuf -u http://127.0.0.1:8000/FUZZ -w /wordlists/common.txt -mc 200
```

### hashid

Just a dockerfile for <https://github.com/psypanda/hashID> that uses a non-root user.

Excample invocation:
```bash
docker run --rm -it ghcr.io/six-two/hashid 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08
```

### languagetool

This is a small wrapper around `erikvl87/languagetool` that allows you to specify the custom words you want to include to the dictoionaries at runtime.
Compared to the suggestion in the original repo this allows you to more easily import custom wordlists, since you do not need to rebuild the container each time.
For each language directory, you can mount a file at `/share/custom_words_<LANGUAGE>.txt`.
Here `<LANGUAGE>` is the short name of the language like `en` for english and `de` for german.
The contents of the file will be added to the dictionary for the given language.
Each line of the file should contain exactly one word.

If you create a file called `/share/custom_words_any.txt`, then the contents will be added to the dictionaries of all languages.

Example invocation (assumes you have your custom wordlists stored in `~/.config/languagetool`):
```bash
docker run --rm -it -p 8081:8010 -v "$HOME/.config/languagetool:/share:ro" ghcr.io/six-two/languagetool
```

### lualatex-for-cv

lualatex container with some extra tools (`exiftool`, `qpdf`) and helper scripts.
It will build your LaTeX file, set its metadata and also create a minified version (removes links if your original contained them).

Assuming you have a file `anschreiben/anschreiben.tex`, that relies on some files from the parent directory, you can run the following command from the parent directory:
```bash
docker run --rm -it -v "$PWD:/share" -e "TITLE=Anschreiben" -e "AUTHOR=six-two" -w /share/anschreiben ghcr.io/six-two/lualatex-for-cv anschreiben.tex
```

This will set the `Title` metadata to `Anschreiben`, the `Author` to `six-two` and write the output file to `anschreiben/anschreiben.pdf`.
A minified PDF will be in `anschreiben/anschreiben.min.pdf` and the LaTeX log in `anschreiben/anschreiben.log`.

By setting the environment variables `SKIP_FIX_METADATA` or `SKIP_OPTIMIZE` to something non-empty (like `docker run -e "SKIP_FIX_METADATA=yes" ...`), you can skip certain steps which speeds up the build.

### mangabuddy-scraper (image not published)

Containerized version of <https://github.com/TUVIMEN/mangabuddy-scraper>.

This Dockerfile was created my me for educational purposes (seeing how to build minimal alpine images that build applications from source).
The resulting docker image is not published.

Disclaimer: Usage of this tool may violate copyright.
You are responsible for your own actions, I take no responsibility.

Example usage:
```bash
./build-image.sh mangabuddy-scraper
```
```bash
docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/mangabuddy-scraper <URL>
```

You can also use the image as a dockerized version of <https://github.com/TUVIMEN/reliq/>:
```bash
docker run --rm -it -v "$PWD:/share" --entrypoint=/usr/bin/reliq ghcr.io/six-two/mangabuddy-scraper <YOUR_ARGUMENTS...>
```

### mingw

A Debian based image for [mingw-w64](https://www.mingw-w64.org/).
Useful for cross compilation from macOS or Linux to Windows.
By default, it invokes `x86_64-w64-mingw32-gcc`, which compiles for 64-bit Windows.

Example invocation that compiles a simple C file:
```bash
docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/mingw test.c -o test.exe
```

There are a bunch of other mingw executables installed.
You can list them with:
```bash
docker run --rm -it -v "$PWD:/share" --entrypoint=bash ghcr.io/six-two/mingw -c "ls -1 /bin/*mingw*"
```

And you can directly use a different compiler (like 32 bit only) via the entrypoint:
```bash
docker run --rm -it -v "$PWD:/share" --entrypoint=/bin/i686-w64-mingw32-gcc ghcr.io/six-two/mingw test.c -o test32.exe
```


### nmap

Normal nmap, just installed with `apk`.

Example invocation:
```bash
docker run --rm -it ghcr.io/six-two/nmap 192.168.1.1 -F -sS
```

### nmap-rootless

This container can run scans normally requiring root privileges, even though inside the container aa non-root user is used.

Scan local gateway:
```bash
docker run --rm -it --cap-add=NET_RAW --cap-add=NET_ADMIN ghcr.io/six-two/nmap-rootless 192.168.1.1 -Pn -T5 -vv
```

It will also work without capabilities, but can only run commands not needing root.
Trying to for example do SYN scans without privileges will fail:
```
$ docker run --rm -it ghcr.io/six-two/nmap-rootless 192.168.1.1 -Pn -T5 -vv -sS
[-] Capability mismatch detected. Expected: 00000000a80435fb. Found: CapBnd:	00000000a80425fb
[-] Please try to run the docker container with '--cap-add=NET_RAW --cap-add=NET_ADMIN'
[-] To prevent nmap from crashing, the '--privileged' flag is not passed to it and a version without capabilities is run.

You requested a scan type which requires root privileges.
QUITTING!
```

### ntlm_challenger

A dockerized version of <https://github.com/nopfor/ntlm_challenger>.

Example usage:
```bash
docker run --rm -it ghcr.io/six-two/ntlm_challenger https://example.com/url-with-ntlm-authentication-option/
```

### penelope

Attempt to dockerize <https://github.com/brightio/penelope>.
The volume mount is so that your logs will be stored outsude the container.
Networking is pretty annoying, since there are two different ways that are both not perfect.

#### Port forwarding

This mode sucks, because the IP addresses in the payloads will always be wrong.
Example usage:
```bash
docker run --rm -it -p 80:80 -p 4444:4444 -p 8000:8000 -v "$HOME/.penelope:/home/app/.penelope" ghcr.io/six-two/penelope 80 4444
```


#### Host network

Listen using docker's host network mode (should in theory work easiest):
```bash
docker run --rm -it --network=host -v "$HOME/.penelope:/home/app/.penelope" ghcr.io/six-two/penelope 80 4444
```

On macOS, you need to open `Docker Desktop` and enable `Settings` -> `Resources` -> `Network` -> `Enable host network` (see [dockerdocs](https://docs.docker.com/engine/network/tutorials/host/)).
Even then it still does not recognize the correct IP addresses on macOS.
Maybe on a Linux host it works better?

### platformio

Containerized version of the [PlatformIO Core CLI](https://docs.platformio.org/en/latest/core/installation/methods/pypi.html).

You can use it to compile embedded software projects:
```bash
docker run --rm -it -v "$HOME/.platformio:/home/app/.platformio" -v "$PWD:/share" ghcr.io/six-two/platformio -f run
```

If your project depends on other local projects, you may have to play around with the mounts and the working directory.
The safest bet is mounting the root directory of all your projects (like `~/Documents`) and then setting the working dir to `/share/RELATIVE_PATH_TO_PROJECT_FROM_DOCUMENTS`.
If you only need projects from the parent folder, you can also do something like this from your current project's folder:
```bash
docker run --rm -it -v "$HOME/.platformio:/home/app/.platformio" -v "$PWD/..:/share" -w "/share/$(basename "$PWD")" ghcr.io/six-two/platformio -f run
```

### powerhub

Containerized version of <https://github.com/AdrianVollmer/PowerHub>.

Example invocation:
```bash
docker run --rm -it -v "$PWD:/share" -p 8080:8080 -p 8443:8443 ghcr.io/six-two/powerhub your-local-hostname-or-domain-fronting.com --no-auth
```

It should create a `powerhub` directory in the folder mounted to `/share`, which contains powerhub's modules, settings, clipbaord data and files.
This way, these data should persist between multiple invocations of the container (assuming the same folder is volume mounted).

### pytools

A python container containing some common build tools for python packages such as `build` (build pip packages), `pip-compile` (update pinned dependencies), and `twine` (upload pip packages).

Update pinned dependencies:
```bash
docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/pytools pip-compile -U
```

Build pip package:
```bash
docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/pytools
```

Upload pip package:
```bash
docker run --rm -it -v "$PWD:/share" -v "$HOME/.pypirc:/home/app/.pypirc:ro" ghcr.io/six-two/pytools twine upload dist/*
```

### scdl

Containerized version of <https://github.com/scdl-org/scdl>.

While there is a official docker file documented in the [wiki](https://github.com/scdl-org/scdl/wiki/Try-scdl-with-docker), I try to keep my python dockerfiles (like powerhub) similar to make them easier to maintain.

Example invocation (will download `Never Gonna Give You Up.mp3` to your current directory):
```bash
docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/scdl -l https://soundcloud.com/rick-astley-official/never-gonna-give-you-up-4
```

### sliver

A containerized version of the Sliver C2 framework (<https://github.com/BishopFox/sliver>).

Example usage to start sliver server:
```bash
docker run -it -v "$PWD:/share" -v "$HOME/.sliver:/home/app/.sliver" -p 53:53 -p 80:80 -p 443:443 -p 8888:8888 ghcr.io/six-two/sliver
```

### smbcrawler

Containerized version of <https://github.com/SySS-Research/smbcrawler>.
Currently untested container.

Scans hosts from `hosts.txt` and only do access checks:
```bash
docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/smbcrawler crawl -i hosts.txt -u YOUR_AD_USERNAME -p YOUR_AD_PASSWORD -d example.lan -t 10 -D 0
```

### sourcemapper

Containerized <https://github.com/denandz/sourcemapper>

Example invocation:
```bash
docker run --rm -it -v "$PWD:/share" sourcemapper -output . -jsurl https://example.com/somescript.js
```

## venv

A container for working with a python virtual environment.
The idea is that the virtual environment stays persistent and is mounted into the container each time.
By default the venv is stored in a folder called `venv.docker`.
This makes it faster than using a blank container and installing the dependencies each time, while avoiding the hassle of having to deal with a bunch of different docker containers (one for each project) filling up your `docker ps -a`.

As the python libraries and tools are only run in a docker container, this provides more security when dealing with less trustworthy code (random unknown libraries, PRs, etc).
You can either start an interactive shell that has your venv loaded:
```
$ docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/venv
(venv.docker) app@78337c223c74:/share$ pip freeze
babel==2.17.0
backrefs==5.9
[...]
```

Or you can supply a single command you want to run:
```bash
docker run --rm -it -v "$PWD:/share" ghcr.io/six-two/venv mkdocs build
```

As a convenience feature I also added a `/bin/mkdocs-serve.sh` script to the container, that quickly installs all dependencies from `requirements.txt`, installs the current directory as a python package and then runs `mkdocs serve` while binding to all interfaces.
This allows me to use a single command fro testing while developing mkdocs plugins:
```bash
docker run --rm -it -v "$PWD:/share" -p 127.0.0.1:8000:8000 ghcr.io/six-two/venv /bin/mkdocs-serve.sh
```

## docker-compose

This contains some docker-compose configuration files I built.
The files are in the folder `./docker-compose/`.

### languagetool-isolated

If you use language tool to check sensitive information (for example if it checks all text entered in your browser), you likely want to make sure that the tool will not send them to the Internet.
This docker compose tool deploys the languagetool container into an isolated network, which should not be able to reach any services on your host or in the Internet.
It also deploys a simple nginx reverse proxy, that allows you to reach the port exposed by the languagetool container.
It does this by being connected to in the normal `default` network as well as the isolated network used by languagetool.
