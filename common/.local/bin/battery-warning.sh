#!/usr/bin/env bash
#
# Simple, stupid battery warning script

# Die if already started
if test pgrep -f battery-warning &> /dev/null
then
    echo "Already started"
    exit 1
fi

interval=${1:-60}
critical_level=${2:-5}

while :
do # Check battery level every X seconds
    read -r lvl < /sys/class/power_supply/BAT0/capacity
    read -r stat < /sys/class/power_supply/BAT0/status
    [[ $lvl -le $critical_level ]] && [[ "$stat" == "Discharging" ]] && {
        dunstify --urgency=critical \
            --icon=battery \
            --replace=9999 \
            "BATTERY LOW" \
            "[${lvl}%] Plug in your charger"
        sfx alert
    }
    sleep "$interval"
done
