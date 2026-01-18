#!/usr/bin/env bash

# Extract only first Sinks block (ignore the second empty one)
SINKS=$(wpctl status | sed -n '/Sinks:/,/Sources:/p' | head -n 5)

# Parse IDs
HDMI_ID=$(echo "$SINKS" | grep -i "HDMI" | awk '{print $2}' | sed 's/\.//')
BUILTIN_ID=$(echo "$SINKS" | grep -i "Analog" | awk '{print $2}' | sed 's/\.//')
CURRENT_ID=$(echo "$SINKS" | grep "\*" | awk '{print $2}' | sed 's/\.//')

echo "Current: $CURRENT_ID"
echo "HDMI:    $HDMI_ID"
echo "Built-in: $BUILTIN_ID"

if [ -z "$CURRENT_ID" ] || [ -z "$HDMI_ID" ] || [ -z "$BUILTIN_ID" ]; then
    echo "Error: Could not parse sinks"
    exit 1
fi

if [ "$CURRENT_ID" = "$HDMI_ID" ]; then
    wpctl set-default "$BUILTIN_ID"
    notify-send "Audio Output" "Switched to Built-in Audio"
else
    wpctl set-default "$HDMI_ID"
    notify-send "Audio Output" "Switched to HDMI Output"
fi

