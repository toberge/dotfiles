#!/bin/sh

# Should export FULL_NAME and EMAIL
source "$HOME/.private"

export EDITOR="/home/linuxbrew/.linuxbrew/bin/nvim"
export PATH="$HOME/.local/bin:$PATH:$HOME/.cargo/bin"

# force fzf colors
export FZF_DEFAULT_OPTS='--color=16'
