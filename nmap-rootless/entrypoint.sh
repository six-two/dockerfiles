#!/bin/sh
# This script checks whether the container was started with privileges and then calls the correct version of nmap.
# This ensures that nmap (but only actions not needing root, like TCP connect scans) still works when not started with privileges

# Value from macOS, may differ
if ! grep -q "CapBnd:.*00000000a80435fb" /proc/self/status; then
    echo "[-] Capability mismatch detected. Expected: 00000000a80435fb. Found: $(grep CapBnd: /proc/self/status)"
    echo "[-] Please try to run the docker container with '--cap-add=NET_RAW --cap-add=NET_ADMIN'"
    echo "[-] To prevent nmap from crashing, the '--privileged' flag is not passed to it and a version without capabilities is run."
    echo
    /usr/bin/nmap "$@"
else
    /usr/bin/nmap-privileged --privileged "$@"
fi

