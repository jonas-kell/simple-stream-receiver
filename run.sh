#!/bin/bash

# Usage: ./start_and_top.sh /path/to/compose-dir
COMPOSE_DIR="${1:-$(pwd)}"

# Define logfile
LOGFILE="log.txt"

# Clear the logfile at the start
> "$LOGFILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') script started in $COMPOSE_DIR" >> "$LOGFILE"

if [[ ! -f "$COMPOSE_DIR/docker-compose.yml" ]]; then
  echo "Error: docker-compose.yml not found in $COMPOSE_DIR"
  echo "Command failed. Press Enter to close."
  echo "$(date '+%Y-%m-%d %H:%M:%S') Error: docker-compose.yml not found in $COMPOSE_DIR" >> "$LOGFILE"
  echo "$(date '+%Y-%m-%d %H:%M:%S') Command failed." >> "$LOGFILE"
  read
  exit 1
fi

# setting the xhost because this might reset it seems
xhost +local:docker

echo "Starting docker compose in $COMPOSE_DIR"
echo "$(date '+%Y-%m-%d %H:%M:%S') Starting docker compose in $COMPOSE_DIR" >> "$LOGFILE"
cd "$COMPOSE_DIR" || {  
  echo "Command failed. Press Enter to close."
  echo "$(date '+%Y-%m-%d %H:%M:%S') Command failed." >> "$LOGFILE"
  read
  exit 1
}
(docker compose up 2>&1 | tee -a "$LOGFILE") &

TARGET="srt://:9999?mode=listener&latency=10"
MAX_TRIES=3600
COUNT=0

while (( COUNT < MAX_TRIES )); do
  WINID=$(wmctrl -l | grep -i "$TARGET" | awk '{print $1}')

  echo "$(date '+%Y-%m-%d %H:%M:%S') Window Manager overview" >> "$LOGFILE"
  echo "$(wmctrl -l)" >> "$LOGFILE"
  
  if [[ -n "$WINID" ]]; then
    echo "Found window $WINID, moving and setting always on top..."
    echo "$(date '+%Y-%m-%d %H:%M:%S') Found window $WINID, moving and setting always on top..." >> "$LOGFILE"
    
    wmctrl -i -r "$WINID" -e 0,0,0,-1,-1
    wmctrl -i -b add,above "$WINID"

    echo "Done."
    echo "$(date '+%Y-%m-%d %H:%M:%S') Done." >> "$LOGFILE"
    exit 0
  else
    echo "Window not found, try #$((COUNT+1))..."
    echo "$(date '+%Y-%m-%d %H:%M:%S') Window not found, try #$((COUNT+1))..." >> "$LOGFILE"
    sleep 1
    ((COUNT++))
  fi
done

echo "Failed to find the window after $MAX_TRIES tries."
echo "$(date '+%Y-%m-%d %H:%M:%S') Failed to find the window after $MAX_TRIES tries." >> "$LOGFILE"
{  
  echo "Command failed. Press Enter to close."
  read
  exit 1
}