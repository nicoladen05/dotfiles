#!/bin/sh
if [ "$5" != "LOW" ] && [ "$1" != "Spotify" ]; then sleep 0.1 && paplay "/home/nico/.local/scripts/notification.wav" --volume 25000; fi
