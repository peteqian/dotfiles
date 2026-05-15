#!/bin/bash

# --- CONFIGURATION ---
STEP=5
STATE_FILE_PREFIX="/tmp/waybar_brightness"
# ---------------------

# Get monitor name - either from argument, env var, or focused monitor
get_monitor_name() {
    if [ -n "$1" ]; then
        echo "$1"
    elif [ -n "$WAYBAR_OUTPUT_NAME" ]; then
        echo "$WAYBAR_OUTPUT_NAME"
    else
        hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
    fi
}

# Get ddcutil display number for a monitor (adjust to your setup)
get_ddcutil_display() {
    local monitor_name="$1"
    case "$monitor_name" in
        "DP-1")
            echo "1"  # LG ULTRAGEAR
            ;;
        # Add other external monitors here:
        # "DP-4") echo "2" ;;
        # "HDMI-A-1") echo "3" ;;
        *)
            echo ""  # No DDC/CI mapping
            ;;
    esac
}

# Compose per-monitor state file path
get_state_file() {
    local monitor="$1"
    echo "${STATE_FILE_PREFIX}_${monitor}.tmp"
}

# Run DDC/CI command in the background
set_brightness_ddcutil() {
    local display_num="$1"
    local brightness="$2"
    pkill -f "ddcutil.*setvcp 10"
    (ddcutil --display "$display_num" setvcp 10 "$brightness") &
}

# Set brightness for laptop displays
set_brightness_laptop() {
    local brightness="$1"
    brightnessctl set "${brightness}%" > /dev/null 2>&1
}

# Get cached or real brightness for a monitor
get_current_brightness() {
    local monitor="$1"
    local state_file
    state_file=$(get_state_file "$monitor")
    local display_num
    display_num=$(get_ddcutil_display "$monitor")

    if [[ "$monitor" == eDP* ]]; then
        # Laptop display
        if [ ! -f "$state_file" ]; then
            local current
            current=$(brightnessctl get 2>/dev/null || echo "0")
            local max
            max=$(brightnessctl max 2>/dev/null || echo "1")
            local percent=$((current * 100 / max))
            echo "$percent" > "$state_file"
        fi
        cat "$state_file"
    elif [ -n "$display_num" ]; then
        # External monitor through DDC/CI
        if [ ! -f "$state_file" ]; then
            local brightness
            brightness=$(ddcutil --display "$display_num" getvcp 10 -t 2>/dev/null | awk '{print $4}' || echo "100")
            echo "$brightness" > "$state_file"
        fi
        cat "$state_file"
    else
        echo "?"
    fi
}

# Write new brightness and trigger hardware change
set_brightness() {
    local monitor="$1"
    local new_brightness="$2"
    local state_file
    state_file=$(get_state_file "$monitor")
    local display_num
    display_num=$(get_ddcutil_display "$monitor")

    if [[ "$monitor" == eDP* ]]; then
        echo "$new_brightness" > "$state_file"
        set_brightness_laptop "$new_brightness"
    elif [ -n "$display_num" ]; then
        echo "$new_brightness" > "$state_file"
        set_brightness_ddcutil "$display_num" "$new_brightness"
    else
        return
    fi

    pkill -RTMIN+8 waybar
}

COMMAND="$1"
MONITOR=$(get_monitor_name "$2")
current=$(get_current_brightness "$MONITOR")

case "$COMMAND" in
    "get")
        echo " $current"
        ;;
    "up")
        if [ "$current" = "?" ]; then
            echo " N/A"
        else
            new_brightness=$((current + STEP > 100 ? 100 : current + STEP))
            if [ "$current" -ne "$new_brightness" ]; then
                set_brightness "$MONITOR" "$new_brightness"
            fi
        fi
        ;;
    "down")
        if [ "$current" = "?" ]; then
            echo " N/A"
        else
            new_brightness=$((current - STEP < 0 ? 0 : current - STEP))
            if [ "$current" -ne "$new_brightness" ]; then
                set_brightness "$MONITOR" "$new_brightness"
            fi
        fi
        ;;
    "right_click")
        if [ "$current" != "?" ]; then
            new_brightness=0
            set_brightness "$MONITOR" "$new_brightness"
        fi
        ;;
    "left_click")
        if [ "$current" != "?" ]; then
            new_brightness=100
            set_brightness "$MONITOR" "$new_brightness"
        fi
        ;;
esac
