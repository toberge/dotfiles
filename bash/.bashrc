# Totally qualified & decreasingly ragtag
# ~/.bashrc
# 
# Bits and pieces assembled from various sources,
# held together by a slightly strained string of sense.
#
# Some things pulled straight from Manjaro's default bashrc,
# most other things (typically less advanced -_-) written by me.

# Abort if not interactive
[[ $- != *i* ]] && return

############
# SETTINGS #
############

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Trim \w to only show X dirs:
PROMPT_DIRTRIM=3

# Check window size after each command
shopt -s checkwinsize

# This *should* be set by default
shopt -s expand_aliases

# Enable history appending instead of overwriting.
shopt -s histappend

##############
# COMPLETION #
##############

# Tab completion of commands and options
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

complete -cf sudo # complete commands written after sudo!
complete -c  man  # also complete man lookups!

##########
# PROMPT #
##########

# PS1 extras
ps1_git_branch() {
    git branch 2>/dev/null | grep '^*' | colrm 1 2
}

# very good code, 100% qualified, much wow
ps1_git_stat() {
    git rev-parse --is-inside-work-tree &>/dev/null || return
    local stat=$(git status 2> /dev/null)

    # Exclusive states
    case $stat in
        *"up to date"*)
            : "\033[01;35m  "
            ;;
        *"is ahead of"*)
            : "\033[01;35m  "
            ;;
        *conflict*)
            : "\033[01;31m  "
            ;;
        *"have diverged"*)
            : "\033[01;31m  "
            ;;
        *)
            : ""
            ;;
    esac
    echo -ne "$_"

    # File status
    [[ "$stat" = *"to be committed"* ]] && echo -ne "\033[01;35m● "
    [[ "$stat" = *"not staged"* ]] && echo -ne "\033[01;35m "

    # Stash, with preceding space
    [[ "$stat" = *"to be committed"* ]] || [[ "$stat" = *"not staged"* ]] && echo -n ' '
    test $(git stash list 2> /dev/null | wc -l) -ne 0 && echo -ne "\033[01;35m "
    # dunno if I'll indicate untracked files in any way
}

ps1_exit_code() {
    # needs to be run *FIRST*
    local exit="$?"
    test $exit -ne 0 && echo -ne " \033[01;31m$exit"
}

# actual definition of prompt
generate_custom_ps1() {
    if [ -z "$DESKTOP_SESSION" ]
    then # on a TTY, avoid fontawesome and fancy unicode
        PS1="\
┌───\$(ps1_exit_code) \[\033[01;32m\]\w\[\033[01;37m\] \[\033[01;34m\]\$(ps1_git_branch)\[\033[00m\]\n\
└─\[\033[01;32m\]\[\033[00m\] "
    else # normal terminal, gimme dat fanciness
        PS1="\
┌────\$(ps1_exit_code) \[\033[01;32m\]\w\[\033[01;37m\] \[\033[01;34m\]\$(ps1_git_branch) \$(ps1_git_stat)\[\033[00m\]\n\
┕━\[\033[01;34m\]  \[\033[00m\] "
    fi
}

##########################
# MANJARO (+ my own PS1) #
##########################

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*|alacritty*)
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
		PS1='┌─── \[\033[01;36m\] \w\[\033[01;31m\]\n┕━ '
	else
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

xhost +local:root > /dev/null 2>&1

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
      *.rar)       unrar x $1   ;;
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
# START OF CUSTOM THINGIES #
############################

# pywal things
if [ -z "$DESKTOP_SESSION" ]
then # on a TTY, do the pywal
    source ~/.cache/wal/colors-tty.sh
else # on DE where we shall set them colors
    (cat ~/.cache/wal/sequences &)
fi

source $HOME/.bash_aliases

eval "$(thefuck --alias)" # pip install --user thefuck first

####################
# VARIOUS COMMANDS #
####################

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

nichijou() {
    [[ -z $1 ]] && [[ -z $2 ]] \
        && sxiv -b "$HOME/Pictures/nichijou/$(date +'%m/%d').jpg" \
        || sxiv -b "$HOME/Pictures/nichijou/$1/$2.jpg"
}

anonymize() {
    PS1='[\[\033[01;31m\]\W\[\033[00m\]] '
}

# see https://stackoverflow.com/questions/849308/pull-push-from-multiple-remote-locations/12795747#12795747
gpa() {
    for RMT in $(git remote)
    do
        echo "-- $RMT --" && git push "$RMT"
    done
}

###################
# CONFIG COMMANDS #
###################

# external ip: probably curl ifconfig.me
localip() {
    ip addr show | grep 'inet .* global' | awk '{print $2}' | cut -d '/' -f 1
}

whatsmyip() {
    curl icanhazip.com
}

# Setting default web browser and so on
unscrew_defaults() {
    xdg-settings set default-web-browser firefox.desktop
}

wacom() {
    xsetwacom set "Wacom Bamboo 16FG 6x8 Pen stylus" MapToOutput 1920x1080+1920+0
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
