#!/usr/bin/env bash
# Courtesy of xkero, see https://www.reddit.com/r/archlinux/comments/858q6h/nvidia_screen_tearing/dvvs008

function vsync { nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = $@ }" ;}
[[ $(nvidia-settings -tq CurrentMetaMode | grep ForceFullCompositionPipeline=On) ]] && vsync Off || vsync On

