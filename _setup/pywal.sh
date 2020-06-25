#!/usr/bin/env sh

# symlink wal templates
for template in dunstrc zathurarc alacritty.yml
do
    folder=${template%%.*}
    folder=${folder%%rc}
    mkdir -p  "${HOME}/.config/${folder}"
    ln -sf "${HOME}/.cache/wal/${template}" \
        "${HOME}/.config/${folder}/${template}"
done

# symlink all glava templates
mkdir -p  "${HOME}/.config/glava"
for template in $(ls ${HOME}/.cache/wal/*.glsl)
do
    ln -sf "${template}" "${HOME}/.config/glava/${template##*/}"
done

# requires having started FF before
# and the option 
# toolkit.legacyUserProfileCustomizations.stylesheets
# to be set to *true* (in about:config)
cd ${HOME}/.mozilla/firefox/*.default && \
mkdir chrome && \
ln -sf "${HOME}/.cache/wal/userContent.css" chrome/userContent.css

