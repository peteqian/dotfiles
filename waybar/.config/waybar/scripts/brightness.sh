#!/bin/bash

# Configuration
BUS=5
STEP=5
LOCK_FILE="/tmp/brightness.lock"
LOG_FILE="/tmp/brightness.log"
CACHE_FILE="/tmp/brightness.cache"
TIMEOUT=2 # Timeout for ddcutil commands (seconds)

# Function to get brightness with caching
get_brightness() {
  local brightness
  # Check if cache is recent (within 5 seconds)
  if [[ -f "$CACHE_FILE" && $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt 5 ]]; then
    brightness=$(cat "$CACHE_FILE")
  else
    # Use flock to prevent concurrent ddcutil calls
    brightness=$(timeout "$TIMEOUT" flock -w 1 "$LOCK_FILE" ddcutil --bus="$BUS" getvcp 10 --brief 2>>"$LOG_FILE" | awk '{print $4}' || echo "0")
    if ! [[ "$brightness" =~ ^[0-9]+$ ]]; then
      echo "Error: Invalid brightness value from ddcutil: $(timeout $TIMEOUT flock -w 1 $LOCK_FILE ddcutil --bus=$BUS getvcp 10 --brief)" >>"$LOG_FILE"
      brightness=0
    fi
    echo "$brightness" >"$CACHE_FILE"
  fi
  echo "$brightness"
}

# Handle scroll events or default case
case "$1" in
up)
  current=$(get_brightness)
  new=$((current + STEP))
  [[ $new -gt 100 ]] && new=100
  timeout "$TIMEOUT" flock -w 1 "$LOCK_FILE" ddcutil --bus="$BUS" setvcp 10 "$new" 2>>"$LOG_FILE"
  brightness=$(get_brightness)
  ;;
down)
  current=$(get_brightness)
  new=$((current - STEP))
  [[ $new -lt 0 ]] && new=0
  timeout "$TIMEOUT" flock -w 1 "$LOCK_FILE" ddcutil --bus="$BUS" setvcp 10 "$new" 2>>"$LOG_FILE"
  brightness=$(get_brightness)
  ;;
*)
  brightness=$(get_brightness)
  ;;
esac

# Output JSON for Waybar
echo "{\"percentage\": $brightness, \"tooltip\": \"Brightness: $brightness%\"}"
