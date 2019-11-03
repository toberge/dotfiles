#!/usr/bin/env sh

# symlink wal templates
mkdir -p  "${HOME}/.config/dunst"
mkdir -p  "${HOME}/.config/zathura"
ln -sf "${HOME}/.cache/wal/dunstrc" "${HOME}/.config/dunst/dunstrc"
ln -sf "${HOME}/.cache/wal/zathurarc" "${HOME}/.config/zathura/zathurarc"
