#!/usr/bin/env bash
#
# Simple, stupid battery warning script

# Die if already started
if test pgrep -f battery-warning &> /dev/null
then
    echo "Already started"
    exit 1
fi

while :
do # Check battery level every X seconds
    read lvl < /sys/class/power_supply/BAT0/capacity
    [[ $lvl -le 5 ]] && {
        notify-send --urgency=critical \
            --icon=battery \
            "BATTERY LOW" \
            "[${lvl}%] Plug in your charger"
        sfx alert
    }
    sleep 60
done
