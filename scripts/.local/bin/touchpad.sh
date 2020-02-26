#!/usr/bin/env bash

# Explanation:
# run xinput list to get device ID
# run xinput list-props [ID] to get ID of natural scroll or other property

# Two cuts because cut only supports single-char delimiter
device=$(xinput list | grep Trackpad | cut -d "=" -f 2 | cut -d "[" -f 1 | cut -f 1)

natural_scroll=$(xinput list-props $device | grep 'Natural Scrolling Enabled (' | cut -d '(' -f 2 | cut -d ')' -f 1)
tapping=$(xinput list-props $device | grep 'Tapping Enabled (' | cut -d '(' -f 2 | cut -d ')' -f 1)

xinput set-prop $device $natural_scroll 1
xinput set-prop $device $tapping 1

