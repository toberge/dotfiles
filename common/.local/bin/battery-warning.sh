#!/usr/bin/env bash
while :
do # check battery level every X seconds
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
