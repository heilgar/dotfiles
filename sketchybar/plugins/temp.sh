#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get CPU temperature from powermetrics (works on Apple Silicon)
TEMP=$(sudo powermetrics --samplers smc -i1 -n1 2>/dev/null | grep -i "CPU die temperature" | awk '{print $4}' | tr -d 'C')

if [ -n "$TEMP" ]; then
  # Round to integer
  TEMP_INT=$(printf "%.0f" "$TEMP")

  # Color based on temperature
  if [ "$TEMP_INT" -ge 80 ]; then
    LABEL_COLOR=$RED
  elif [ "$TEMP_INT" -ge 70 ]; then
    LABEL_COLOR=$ORANGE
  elif [ "$TEMP_INT" -ge 60 ]; then
    LABEL_COLOR=$YELLOW
  else
    LABEL_COLOR=$LABEL_COLOR
  fi

  sketchybar --set "$NAME" label="${TEMP_INT}°C" label.color="$LABEL_COLOR"
else
  # Fallback: show N/A
  sketchybar --set "$NAME" label="N/A" label.color=$LABEL_COLOR
fi
