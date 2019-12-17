#!/usr/bin/env sh

# symlink wal templates
mkdir -p  "${HOME}/.config/dunst"
mkdir -p  "${HOME}/.config/zathura"
ln -sf "${HOME}/.cache/wal/dunstrc" "${HOME}/.config/dunst/dunstrc"
ln -sf "${HOME}/.cache/wal/zathurarc" "${HOME}/.config/zathura/zathurarc"

# requires having started FF before
cd ${HOME}/.mozilla/firefox/*.default && \
mkdir chrome && \
ln -sf "${HOME}/.cache/wal/userContent.css" chrome/userContent.css

