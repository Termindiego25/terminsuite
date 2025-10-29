#!/bin/bash
# entrypoint.sh
# TerminSuite Connector — Initialize persistent SSH tunnels for remote Raspberry Pi nodes

set -e

export HOME=/ssh
export SSH_CONFIG=/ssh/config

echo "[+] Starting SSH tunnel connections..."

# RPi5-B (example: remote services exposed on ports 11443, 12443)
autossh -M 0 -F "$SSH_CONFIG" -N \
  -L 0.0.0.0:11443:127.0.0.1:11443 \
  -L 0.0.0.0:12443:127.0.0.1:12443 \
  rpi5b &

# RPi5-C (example: remote services exposed on ports 21443, 22443)
autossh -M 0 -F "$SSH_CONFIG" -N \
  -L 0.0.0.0:21443:127.0.0.1:21443 \
  -L 0.0.0.0:22443:127.0.0.1:22443 \
  rpi5c &

# Keep container alive indefinitely
wait
