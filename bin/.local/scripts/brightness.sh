#!/bin/bash

brightness=$(echo $(echo $(xrandr --verbose | grep Brightness -m 1 | awk '{print $2}') + $1) | bc)

xrandr --output DP-0 --brightness $brightness
xrandr --output HDMI-0 --brightness $brightness
