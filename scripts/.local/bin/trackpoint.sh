#!/usr/bin/env bash

# Explanation:
# run xinput list to get device ID
# run xinput list-props [ID] to get ID of natural scroll or other property

set -euo pipefail

device=$(xinput list | grep -i 'trackpoint' | cut -d "=" -f 2 | cut -d "[" -f 1 | cut -f 1)

wheel_enabled=$(xinput list-props "$device" | grep 'Wheel Emulation (' | cut -d '(' -f 2 | cut -d ')' -f 1)
wheel_button=$(xinput list-props "$device" | grep 'Wheel Emulation Button' | cut -d '(' -f 2 | cut -d ')' -f 1)

xinput set-prop "$device" "$wheel_enabled" 1
xinput set-prop "$device" "$wheel_button" 2
