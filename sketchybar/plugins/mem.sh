#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get memory pressure
MEMORY_PRESSURE=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print $5}' | tr -d '%')

if [ -n "$MEMORY_PRESSURE" ]; then
  # Convert free percentage to used percentage
  MEM_PERCENT=$(echo "100 - $MEMORY_PRESSURE" | bc)
else
  # Fallback to vm_stat method
  PAGE_SIZE=4096
  VM_STAT=$(vm_stat)

  PAGES_ACTIVE=$(echo "$VM_STAT" | grep "Pages active" | awk '{print $3}' | tr -d '.')
  PAGES_WIRED=$(echo "$VM_STAT" | grep "Pages wired down" | awk '{print $4}' | tr -d '.')
  PAGES_COMPRESSED=$(echo "$VM_STAT" | grep "Pages occupied by compressor" | awk '{print $5}' | tr -d '.')

  TOTAL_MEM=$(sysctl -n hw.memsize)
  USED_MEM=$(echo "($PAGES_ACTIVE + $PAGES_WIRED + $PAGES_COMPRESSED) * $PAGE_SIZE" | bc)

  MEM_PERCENT=$(echo "scale=0; ($USED_MEM * 100) / $TOTAL_MEM" | bc)
fi

# Color based on usage
if [ "$MEM_PERCENT" -ge 80 ]; then
  LABEL_COLOR=$RED
elif [ "$MEM_PERCENT" -ge 60 ]; then
  LABEL_COLOR=$ORANGE
elif [ "$MEM_PERCENT" -ge 40 ]; then
  LABEL_COLOR=$YELLOW
else
  LABEL_COLOR=$LABEL_COLOR
fi

sketchybar --set "$NAME" label="${MEM_PERCENT}%" label.color="$LABEL_COLOR"
