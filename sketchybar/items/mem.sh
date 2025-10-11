#!/bin/bash

mem=(
  script="$PLUGIN_DIR/mem.sh"
  icon=$MEMORY
  icon.font="$FONT:Regular:16.0"
  label.font="$FONT:Semibold:13.0"
  padding_right=5
  padding_left=5
  update_freq=10
  updates=on
)

sketchybar --add item mem right \
           --set mem "${mem[@]}"
