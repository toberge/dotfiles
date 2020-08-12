#!/usr/bin/env bash

set -euo pipefail

test -f _sounds/open.wav || exit 1

THEMEFOLDER="$HOME/.local/share/sounds/calicomp"

mkdir "$HOME/.sounds"
mkdir -p "$THEMEFOLDER/source"

# copy sounds for i3wm sounds & source for freedesktop sound theme
cp _sounds/*.wav "$HOME/.sounds"
cp _sounds/*.wav "$THEMEFOLDER/source"
cp _sounds/index.theme "$THEMEFOLDER"

cd "$THEMEFOLDER"

# symlink <sound name> <freedesktop action>
symlink() {
    ln -sf "$THEMEFOLDER/$2.wav" "source/$1.wav"
}

for sound in desktop-login theme-demo
do
    symlink startup $sound
done

symlink close window-close

for sound in dialog-ok drag-accept
do
    symlink apply $sound
done

for sound in drag-fail dialog-{error,warning} window-attention-{inactive,active}
do
    symlink browse $sound
done

symlink open window-open
