#!/bin/bash

temp=(
  script="$PLUGIN_DIR/temp.sh"
  icon=$TEMPERATURE
  icon.font="$FONT:Regular:16.0"
  label.font="$FONT:Semibold:13.0"
  padding_right=5
  padding_left=5
  update_freq=15
  updates=on
)

sketchybar --add item temp right \
           --set temp "${temp[@]}"
