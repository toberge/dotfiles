#######################
#   JUMP TO FOLDERS   #
#######################

export SKOLE="$HOME/skul"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias bin='cd ~/.dotfiles/scripts/.local/bin/'
alias cdj="cd $SKOLE/java"
alias cdc="cd $SKOLE/C"
alias cdw="cd $SKOLE/web"
alias cdm="cd $SKOLE/Matematikk\ 3"
alias cda="cd $SKOLE/algdat"
alias cdf="cd $SKOLE/Fysikk\ 2"
alias cds="cd ~/git/security"
alias cdp="cd $SKOLE/sikkerhet/programvare"
alias cdn="cd $SKOLE/sikkerhet/nettverk"
alias cdd="cd $HOME/.dotfiles" # no longer a duplicate

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

# typical stuff:
alias cp='cp -i'        # confirm before overwriting something
alias df='df -h'        # human-readable sizes
alias du='du -h'        # human-readable sizes
alias free='free -m'    # show sizes in MB
alias more=less         # less is more - wait, that's the wrong way

# color=auto does not work
alias diff='diff --color=always'

# ssh from alacritty always starts out bad:
alias sssh='TERM=xterm-256color ssh'

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
alias ':q'='echo "you aint using vim now"; sfx alert; wait; exit'

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias r='ranger'

alias tb='nc termbin.com 9999'

alias w='which'
alias mkd='mkdir'
alias mkp='mkdir -p'    # mk whole path

alias o='xdg-open'      # Open things quickly
alias s='setsid -f'     # avoid having to bg and disown

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

alias py='python'

# Clipboard
alias copy='xclip -selection clipboard -i'
alias paste='xclip -selection clipboard -o'

alias serve='python -m http.server'

alias dragon='dragon-drag-and-drop'
alias drag='dragon-drag-and-drop'

# The annoying first steps of cmaking
alias cmk='mkdir build && cd build && cmake .. && make'
# Other annoyances
alias cleantex='rm -f *.{aux,log,out}'

# Debug features
alias ewwdbg='GTK_DEBUG=interactive eww open main_window'

# escaped $2 won't get expanded - and it is awk syntax..
# shellcheck disable=SC2142
alias localip="ip addr show | grep 'inet .* global' | awk '{print \$2}' | cut -d '/' -f 1"
alias whatsmyip='curl icanhazip.com'
alias unscrew_defaults='xdg-settings set default-web-browser firefox.desktop && xdg-mime default thunar.desktop inode/directory'
alias wacom='xsetwacom set "Wacom Bamboo 16FG 6x8 Pen stylus" MapToOutput 1920x1080+1920+0'
alias webcam='mpv av://v4l2:/dev/video0 --profile=low-latency --untimed --x11-name=webcam'

#######################
#    GIT SHORTCUTS    #
#######################

alias ga='git add'
alias gaa='git add -A'
alias gd='git diff'
alias gds='git diff --staged'
alias gdm='git diff origin/master'
alias gf='git fetch'
alias gr='git rebase'
alias grs='git reset' # unstages staged files
alias grm='git reset --mixed' # also affects commits
alias gm='git merge'
alias gp='git push'
alias gph='git push -u origin HEAD'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gc='git commit'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gsm='git stash -m'
alias gsp='git stash pop'
alias gl='git log --oneline --graph --all --decorate'
alias glead='git shortlog -s -n --all --no-merges'

#######################
#        MISC         #
#######################

alias killunity='kill -9 $(pidof Unity)'
