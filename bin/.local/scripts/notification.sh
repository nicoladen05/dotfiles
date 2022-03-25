#!/bin/sh
if [ "$5" != "LOW" ] && [ "$1" != "Auryo" ]; then paplay "/home/nico/.local/scripts/notification.wav" --volume 25000; fi
