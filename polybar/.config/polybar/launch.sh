#!/usr/bin/env bash

# source ~/.cache/wal/colors.sh

# set transparent color for polybar
export color0_alpha="#99${color0/'#'}"
export color8_alpha="#22${color8/'#'}"

# Terminate already running bar instances
killall polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar top -c $(dirname $0)/config.ini &

