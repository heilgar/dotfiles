#!/bin/bash

cpu=(
  script="$PLUGIN_DIR/cpu.sh"
  icon=$CPU
  icon.font="$FONT:Regular:16.0"
  label.font="$FONT:Semibold:13.0"
  padding_right=5
  padding_left=5
  update_freq=4
  updates=on
)

sketchybar --add item cpu right \
           --set cpu "${cpu[@]}"
