# Dockerfiles

Dockerfiles for my images hosted at GitHub Container Registry (ghcr.io).

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

## Containers

### csv2md

Just a dockerfile for <https://github.com/lzakharov/csv2md> that uses a non-root user.
You can use it as a template for any other pip package, if you just replace `csv2md` with the package you want to containerize.

Jou can just pipe your CSV input into the docker command to convert it to a Markdown table:
```bash
echo -e "a,b,c\n1,2,3" | docker run --rm -i ghcr.io/six-two/csv2md
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

