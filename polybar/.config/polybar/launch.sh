#!/usr/bin/env bash

# Fetch pywal colors for transparent background
# See https://github.com/dylanaraps/pywal/issues/132
# (makes me want to switch to something else...)
# shellcheck disable=1090
source ~/.cache/wal/colors.sh
# shellcheck disable=2154
export background_transparent="#bf${background/'#'}"

# Polybar somehow needs a timeout
sleep .01

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null
do
    sleep 1
done

# Start bar on all monitors
# from https://github.com/gugahoi/dotfiles-linux/blob/master/config/polybar/scripts/launch.sh
primary=$(xrandr --query | grep " primary" | cut -d' ' -f1)
mainbar=main
lamebar=secondary
if type "xrandr"
then
    for monitor in $(xrandr --query | grep " connected" | cut -d' ' -f1)
    do
        if [[ "${monitor}" = "${primary}" ]]
        then
            MONITOR=${monitor} polybar --reload ${mainbar}&
        else
            MONITOR=${monitor} polybar --reload ${lamebar}&
        fi
    done
else
  polybar --reload ${mainbar} &
fi

echo "Launched your bar(s), ${mainbar} and ${lamebar}"
