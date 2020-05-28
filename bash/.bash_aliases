#######################
#   JUMP TO FOLDERS   #
#######################

export SKOLE="$HOME/Dropbox/skoleting/ITHINGDA/"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias dot='cd ~/.dotfiles'
alias cdj="cd $SKOLE/java"
alias cds="cd $SKOLE/statistikk"
alias cdc="cd $SKOLE/C"
alias cdw="cd $SKOLE/web"
alias cdm="cd $SKOLE/Matematikk\ 2"
alias cda="cd $SKOLE/algdat"
alias cdf="cd $SKOLE/fysikk"

alias i3conf="vim $HOME/.config/i3/config"
alias bspconf="vim $HOME/.config/bspwm/bspwmrc"
alias keyconf="vim $HOME/.config/sxhkd/sxhkdrc"
alias polyconf="vim $HOME/.config/polybar/config"
alias polystart="$HOME/.config/polybar/launch.sh"

#######################
#  CMD ABBREVIATIONS  #
#######################

alias q='exit'
alias c='clear'
alias f='fuck'
alias ':q'='echo "you aint using vim now"; sfx alert & sleep 1; exit'
alias vi='vim'
alias v='vim'
alias r='ranger'
alias tb='nc termbin.com 9999'

alias ll='ls -lh'
alias la='ls -lha'

alias p='pacman'
alias pq='pacman -Q'
alias pf='pacman -Ss'
alias pu='sudo pacman -Syu'
alias puu='sudo pacman -Syyuu'
alias pi='sudo pacman -S'

alias y='yay'
alias yq='yay -Q'
alias yf='yay -Ss'
alias yu='yay -Syu'
alias yi='yay -S'

#######################
#    GIT SHORTCUTS    #
#######################

alias g='git status' # to prevent GhostScript conflict
alias ga='git add'
alias gaa='git add -A'
alias gd='git diff'
alias gdm='git diff origin/master'
alias gf='git fetch'
alias gr='git rebase'
alias gm='git merge'
alias gp='git push'
alias gc='git commit'
alias gcm='git commit -m'
alias gl='git log --oneline --graph --all --decorate'
# see https://stackoverflow.com/questions/849308/pull-push-from-multiple-remote-locations/12795747#12795747
# with or without branch arg?
alias gpab='for RMT in $(git remote); do echo "-- $RMT --" && git push -v $RMT $1; done;'
alias gpa='for RMT in $(git remote); do echo "-- $RMT --" && git push $RMT; done;'

