# Totally qualified & decreasingly ragtag
# ~/.bashrc
# 
# Bits and pieces assembled from various sources,
# held together by a slightly strained string of sense.
#
# Some things pulled straight from Manjaro's default bashrc,
# most other things (typically less advanced -_-) written by me.

# PS1 extras
ps1_git_branch() {
    git branch 2>/dev/null | grep '^*' | colrm 1 2
}

# very good code, 100% qualified, much wow
ps1_git_stat() {
    local stat=$(git status 2> /dev/null)
    # extra space for fontawesome glyphs if term is not urxvt
    # (variable-width terms may let those take two chars)
    # gnome-terminal goes wonky with these symbols anyway
    local SPACE=$(ps -p$PPID | grep -E "urxvt|xterm" &> /dev/null || echo -n ' ')

    echo $stat | grep "up to date" &> /dev/null && echo -ne "\033[01;35m $SPACE"
    echo $stat | grep "is ahead of" &> /dev/null && echo -ne "\033[01;35m $SPACE"
    echo $stat | grep "conflict" &> /dev/null && echo -ne "\033[01;31m $SPACE" #
    echo $stat | grep "have diverged" &> /dev/null && echo -ne "\033[01;31m $SPACE"

    echo $stat | grep "to be committed" &> /dev/null && echo -ne "\033[01;35m●$SPACE"
    echo $stat | grep "not staged" &> /dev/null && echo -ne "\033[01;35m$SPACE"

    echo -n ' '
    test $(git stash list 2> /dev/null | wc -l) -ne 0 && echo -ne "\033[01;35m$SPACE"
    # dunno if I'll indicate untracked files in any way
}

ps1_exit_code() {
    # needs to be run *FIRST*
    local EXIT="$?"
    test $EXIT -ne 0 && echo -ne " \033[01;31m$EXIT"
}

# trim \w to only show X dirs:
PROMPT_DIRTRIM=3

# also, do this:

# actual definition of prompt
generate_custom_ps1() {
    if [ -z $DESKTOP_SESSION ]
    then # on a TTY, avoid fontawesome and fancy unicode
        PS1="┌───\$(ps1_exit_code) \[\033[01;32m\]\w\[\033[01;37m\] \[\033[01;34m\]\$(ps1_git_branch)\[\033[00m\]\n└─\[\033[01;32m\]\[\033[00m\] "
    else # normal terminal, gimme dat fanciness
        PS1="┌───\$(ps1_exit_code) \[\033[01;32m\]\w\[\033[01;37m\] \[\033[01;34m\]\$(ps1_git_branch) \$(ps1_git_stat)\[\033[00m\]\n┕━\[\033[01;32m\]\[\033[00m\] "
    fi
}

##########################
# MANJARO (+ my own PS1) #
##########################

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		#PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
		PS1='┌─── \[\033[01;36m\] \w\[\033[01;31m\]\n┕━ '
	else
		#PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
                # MY OWN PROMPT NOW...
                generate_custom_ps1
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

############################
# IMPORTED FROM LINUX MINT #
############################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

### there could be more but much is done in Manjaro already, it's just this *particular* thing that's gonna annoy me

#####
# IMPORTED FROM UBUNTU MAYBE

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

############################
# START OF CUSTOM THINGIES #
############################

# pywal things
if [[ "$DESKTOP_SESSION" = "i3" ]]
then # on DE where we shall set them colors
    (cat ~/.cache/wal/sequences &)
elif [ -z $DESKTOP_SESSION ]
then # on a TTY, do the pywal
    source ~/.cache/wal/colors-tty.sh
fi

SKOLE="$HOME/Dropbox/skoleting/ITHINGDA/"

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

alias bc="vim $HOME/.bashrc"
alias i3conf="vim $HOME/.config/i3/config"
alias polyconf="vim $HOME/.config/polybar/config"
alias polystart="$HOME/.config/polybar/launch.sh"

alias q='exit'
alias ':q'='echo "you aint using vim now"; sleep 2; exit'
alias vi='vim'
alias v='vim'
alias r='ranger'
# matlab is bloat
alias matlabrdp='xfreerdp +clipboard /size:1920x1080 +fonts +decorations /d:win.ntnu.no  /u:toberge /v:calcfarm.ntnu.no /app:"C:\Program Files\MATLAB\R2019a\bin\matlab.exe"'

alias ll='ls -lh'
alias la='ls -lha'

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

eval "$(thefuck --alias)" # pip install --user thefuck first

############################
# MEDIA PLAYBACK AND STUFF #
############################

muse() {
  echo "we go look for mewsic"
  cd /media/Sharelings/Music/
}

ple() {
  MODE=9 # indicating not-ple

  case $1 in
    m4a|mp3|ogg|flac)
      MODE="pureple"
      ;;
    kageki|kage)
      echo "wakarimas"
      echo "vewy sowy but it's gone"
      ;;
    lofi)
      MODE=2
      MSG="chilling out..."
      LIST="https://www.youtube.com/watch?v=hHW1oY26kxQ"
      ;;
    *)
      echo "Usage: ple [filetype/list]"
      ;;
  esac

  # the following can be rewritten as case statements, but I'll leave it like this for now

  if [ $1 == "yokohama" ] || [ $1 == "alpha" ]; then
    MODE=1
    MSG='sequester yourself in a quiet country café'
    LIST='https://www.youtube.com/playlist?list=PL157A64E54AB333EE'
  fi
  if [ $1 == "glt" ]; then
    echo yeah it wrongk
    MODE=2
    MSG='apocalypse nuow'
    LIST='https://www.youtube.com/playlist?list=PL0V1RP49t950z5e_IYNCsoXAUobTa7ppu'
  fi

  if [ $MODE == 1 ]; then
    echo $MSG
    mpv $LIST --no-video --loop-playlist=inf --shuffle --load-unsafe-playlists
  elif [ $MODE == 2 ]; then
    echo $MSG
    mpv $LIST --no-video
  elif [ $MODE == "pureple" ]
  then
    echo "we ple some $1 files"
    mpv --no-video --loop-playlist=inf --shuffle *.$1
    
  fi
}

# remember the need for spaces here. it's space-sensitive.

gimme() {
    FACE="?" # zis command copies specific "text" to yer clipboard

    case $1 in # single quotes fix everything
        s|shrug)
            : '¯\_(ツ)_/¯'
            ;;
        l|lenny)
            : '( ͡° ͜ʖ ͡°)'
            ;;
        t|flip|table|tableflip)
            : ' (╯°□°）╯︵ ┻━┻'
            ;;
        tp|put|tableput)
            : '┬──┬ ノ( ゜-゜ノ)'
            ;;
        g|gib)
            : '༼ つ ◕_◕ ༽つ'
            ;;
        ok|checkmark)
            : '✔'
            ;;
        *)
            : 'you big doofus'
            ;;
    esac
    FACE="$_"
    
    if [ "$FACE" != "?" ]
    then
        echo "Giving you a big ol' $1"
        echo -n "$FACE" | xclip -selection c # dat -n removes newline, yay
    else
        echo "Sorry, no face corresponds to that."
        echo "Try a nose instead?"
    fi
}


# specific renaming purpose
renyou() {
  find -type f -name '*.m4a' | rename -v -v 's/\-...........\.m4a/\.m4a/'
}

anonymize() {
    PS1='[\[\033[01;31m\]\W\[\033[00m\]] '
}

###################
# CONFIG THINGIES #
###################

# external ip: probably curl ifconfig.me
localip() {
    ip addr show | grep 'inet .* global' | awk '{print $2}' | cut -d '/' -f 1
}

# Setting default web browser and so on
unscrew_defaults() {
    xdg-settings set default-web-browser firefox.desktop
}

wacom() {
    xsetwacom set "Wacom Bamboo 16FG 6x8 Pen stylus" MapToOutput 1920x1080+1920+0
}

gogh() {
  bash -c  "$(wget -qO- https://git.io/vQgMr)"
  echo "you got some new colors maybe"
}

# forcing redshift using default value
shiftred() {
  redshift -O 3700
  echo "Oh, it's this problem again"
}
alias laemp='shiftred'

cleanpac() {
  # remove orphaned packages - leftover dependencies, that is. Taken from the Arch wiki.
  sudo pacman -Rns $(pacman -Qtdq)
  #sudo apt autoremove should be the similar one on deb distros
}

#######################
# PROGRAMMING SECTION #
#######################

# packing jar files, cvfm $BaseName.jar manifest.txt *.class
japp() {
  javac *.java && jar cvfm $1.jar manifest.txt *.class && echo "we hast it gedont"
  if [ $? == -1 ];then
    echo "oh, I'm so sorry"
  fi
}

# running jar files
jarun() {
  java -jar $1
}

jack() {
  javac $1.java && java $1
}

################################
# FANCY SHIT ON WELCOME SCREEN #
################################

# gotta have something here, right?
# fortune -e science
# echo

#neofetch
#if [ $? == 127 ];then
	#echo 'no neofetch you moron'
	#apt list neofetch
	#pacman -Q neofetch
	#echo
	#screenfetch
#fi

