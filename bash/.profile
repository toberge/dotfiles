export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export QT_QPA_PLATFORMTHEME="qt5ct"
# possibly also this:
export QT_AUTO_SCREEN_SCALE_FACTOR=0

export EDITOR=/usr/bin/nvim
export PATH="$PATH:$HOME/.local/bin"

# force fzf colors
export FZF_DEFAULT_OPTS='--color=16'

xset -b # bell begone

# fixing Java GUIs not working on BSPWM
export _JAVA_AWT_WM_NONREPARENTING=1

