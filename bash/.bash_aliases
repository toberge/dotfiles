#######################
#   JUMP TO FOLDERS   #
#######################

export SKOLE="$HOME/Dropbox/skoleting/ITHINGDA/"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias dot='cd ~/.dotfiles'
alias bin='cd ~/.dotfiles/scripts/.local/bin/'
alias cdj="cd $SKOLE/java"
alias cds="cd $SKOLE/statistikk"
alias cdc="cd $SKOLE/C"
alias cdw="cd $SKOLE/web"
alias cdm="cd $SKOLE/Matematikk\ 2"
alias cda="cd $SKOLE/algdat"
alias cdf="cd $SKOLE/fysikk"
alias cdd="cd $HOME/.dotfiles" # oh, a duplicate

alias i3conf="vim $HOME/.config/i3/config"
alias bspconf="vim $HOME/.config/bspwm/bspwmrc"
alias keyconf="vim $HOME/.config/sxhkd/sxhkdrc"
alias polyconf="vim $HOME/.config/polybar/config"
alias polystart="$HOME/.config/polybar/launch.sh"
alias caps="xmodmap $HOME/.Xmodmap"
alias vv="vim $HOME/.config/nvim/init.vim"

#######################
#   CMD ADJUSTMENTS   #
#######################

# typical stuff (from manjaro):
alias cp='cp -i'        # confirm before overwriting something
alias df='df -h'        # human-readable sizes
alias free='free -m'    # show sizes in MB
alias more=less         # less is more - wait, that's the wrong way

alias bat='bat --theme=ansi-dark'   # use term colors...

#######################
#        TYPOS        #
#######################

alias bpsc='bspc'

#######################
#  CMD ABBREVIATIONS  #
#######################

alias q='exit'          # who wants to write exit all the time
alias c='clear'
alias f='fuck'          # less swearing in my history
alias ':q'='echo "you aint using vim now"; sfx alert & sleep 1; exit'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias r='ranger'
alias tb='nc termbin.com 9999'
alias mkp='mkdir -p'    # mk whole path

alias ll='ls -lh'
alias la='ls -lha'

alias sc='systemctl'
alias scs='systemctl status'

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

alias serve='python -m http.server'

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
