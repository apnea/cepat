#!/bin/bash
# Docker log rotation from https://docs.docker.com/engine/logging/drivers/json-file/

DAEMON_JSON="/etc/docker/daemon.json"
CONFIG='{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}'

[ -f "$DAEMON_JSON" ] && [ -s "$DAEMON_JSON" ] && \
  cat "$DAEMON_JSON" | jq . >/dev/null 2>&1 || echo '{}' | sudo tee "$DAEMON_JSON"

sudo cp "$DAEMON_JSON" "$DAEMON_JSON.bak"

cat "$DAEMON_JSON" | \
  jq --argjson c "$CONFIG" '. * $c' | \
  sudo tee "$DAEMON_JSON" > /dev/null

sudo systemctl restart docker