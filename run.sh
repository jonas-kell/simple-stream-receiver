#!/bin/bash

# Usage: ./start_and_top.sh /path/to/compose-dir
COMPOSE_DIR="${1:-$(pwd)}"

if [[ ! -f "$COMPOSE_DIR/docker-compose.yml" ]]; then
  echo "Error: docker-compose.yml not found in $COMPOSE_DIR"
  echo "Command failed. Press Enter to close."
  read
  exit 1
fi

# setting the xhost because this might reset it seems
xhost +local:docker

echo "Starting docker compose in $COMPOSE_DIR"
cd "$COMPOSE_DIR" || {  
  echo "Command failed. Press Enter to close."
  read
  exit 1
}
(docker compose up) &

TARGET="srt://:9999?mode=listener&latency=10"
MAX_TRIES=3600
COUNT=0

while (( COUNT < MAX_TRIES )); do
  WINID=$(wmctrl -l | grep -i "$TARGET" | awk '{print $1}')
  
  if [[ -n "$WINID" ]]; then
    echo "Found window $WINID, moving and setting always on top..."
    wmctrl -i -r "$WINID" -e 0,0,0,-1,-1
    wmctrl -i -b add,above "$WINID"
    echo "Done."
    exit 0
  else
    echo "Window not found, try #$((COUNT+1))..."
    sleep 1
    ((COUNT++))
  fi
done

echo "Failed to find the window after $MAX_TRIES tries."
{  
  echo "Command failed. Press Enter to close."
  read
  exit 1
}