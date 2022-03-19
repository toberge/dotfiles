# Fish - the fiendishly invocative shell

# Options {{{
set fish_greeting
set -x VIRTUAL_ENV_DISABLE_PROMPT true
# }}}

# Sourcing {{{
source ~/.config/fish/theme.fish
source ~/.bash_aliases
[ "$TERM" = linux ] && bash ~/.cache/wal/colors-tty.sh
# }}}

# Misc {{{
[ ! "$TERM" = linux ] && thefuck --alias | source
# }}}
