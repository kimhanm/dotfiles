#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch top bar depending on wm
for i in {xmonad,bspwm}; do
  pgrep $i >/dev/null && polybar $i-top-bar &
done

echo "Polybar launched..."
