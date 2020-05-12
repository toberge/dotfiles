#!/usr/bin/env sh

# symlink wal templates
mkdir -p  "${HOME}/.config/dunst"
mkdir -p  "${HOME}/.config/zathura"
ln -sf "${HOME}/.cache/wal/dunstrc" "${HOME}/.config/dunst/dunstrc"
ln -sf "${HOME}/.cache/wal/zathurarc" "${HOME}/.config/zathura/zathurarc"

# requires having started FF before
# and the option 
# toolkit.legacyUserProfileCustomizations.stylesheets
# to be set to *true* (in about:config)
cd ${HOME}/.mozilla/firefox/*.default && \
mkdir chrome && \
ln -sf "${HOME}/.cache/wal/userContent.css" chrome/userContent.css

