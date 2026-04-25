#!/usr/bin/env bash

# Get all sinks (Audio/Sink nodes)
mapfile -t SINK_IDS < <(
  pw-dump | jq -r '
    .[] 
    | select(.type == "PipeWire:Interface:Node") 
    | select(.info.props."media.class" == "Audio/Sink") 
    | .id
  '
)

# Get current default sink
CURRENT_ID=$(wpctl status | grep '\*' | grep -oE '[0-9]+' | head -1)

if [ ${#SINK_IDS[@]} -lt 2 ]; then
  notify-send "Audio Toggle" "Only one sink available"
  exit 1
fi

# Find next sink
NEXT_ID=""
for i in "${!SINK_IDS[@]}"; do
  if [ "${SINK_IDS[$i]}" = "$CURRENT_ID" ]; then
    NEXT_ID="${SINK_IDS[$(((i + 1) % ${#SINK_IDS[@]}))]}"
    break
  fi
done

# Get human-readable name from PipeWire
NEXT_NAME=$(pw-dump | jq -r "
  .[] 
  | select(.id == $NEXT_ID) 
  | .info.props.\"node.description\"
")

# Switch
wpctl set-default "$NEXT_ID"

notify-send "Audio Output" "Switched to: $NEXT_NAME"
