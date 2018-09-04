#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 2; done

# Launch bar1 and bar2
polybar bar1 &
polybar bar2 &

echo "Bars launched..."

