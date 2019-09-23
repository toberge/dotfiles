#!/usr/bin/env bash

if test `echo $HOSTNAME | grep computer`
then # specific issue on laptop only
    echo "laptop bad, must wait"
    sleep 1
fi

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null
do
    sleep 1
done

# start bar on all monitors
name=sunset
if type "xrandr"
then
  for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1)
  do
    MONITOR=${monitor} polybar --reload ${name}&
  done
else
  polybar --reload ${name} &
fi

echo "Launched your bar(s), ${name}"
