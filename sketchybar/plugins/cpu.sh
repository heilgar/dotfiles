#!/bin/bash

source "$CONFIG_DIR/colors.sh"

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"

# Color based on usage
if [ "$CPU_PERCENT" -ge 80 ]; then
  LABEL_COLOR=$RED
elif [ "$CPU_PERCENT" -ge 60 ]; then
  LABEL_COLOR=$ORANGE
elif [ "$CPU_PERCENT" -ge 40 ]; then
  LABEL_COLOR=$YELLOW
else
  LABEL_COLOR=$LABEL_COLOR
fi

sketchybar --set "$NAME" label="${CPU_PERCENT}%" label.color="$LABEL_COLOR"
