#
# ~/.bashrc
#

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
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
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

# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"


############################
# IMPORTED FROM LINUX MINT #
############################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

### there could be more but much is done in Manjaro already, it's just this *particular* thing that's gonna annoy me

############################
# START OF CUSTOM THINGIES #
############################

alias q='exit'
alias vi='vim'
alias v='vim'

eval $(thefuck --alias) # sudo pip install thefuck first

# potato() {
#  feh -x ~/Pictures/folded/potato.jpg
# }
alias potato='feh -x ~/Pictures/folded/potato.jpg'
# w3m -o ext_image_viewer=0 ~/Pictures/folded/potato.jpg

############################
# MEDIA PLAYBACK AND STUFF #
############################

muse() {
  echo "we go look for mewsic"
  cd /media/Sharelings/Music/
}

ple() {
  MODE=1 # indicating not-ple


  case $1 in
	  m4a|mp3|ogg)
		  MODE="pureple"
		  ;;
	  kageki|kage)
		  echo wakarimas
		  ;;
 	  *)
		  echo "Usage: ple [filetype/list]"
		  ;;
  esac

  if [ $1 == "kageki" ] || [ $1 == "kage" ]; then
    MSG='wakarimas'
    LIST='https://www.youtube.com/playlist?list=PL477PKeQut6-VmAh4X6EkAzsOYWLtHL_G'
  fi
  if [ $1 == "iamreborn" ] || [ $1 == "reproduce" ]; then
    MSG='I AM REBORN'
    LIST='https://www.youtube.com/watch?v=fZ6s-2hLazs'
    THEEND='wakarimas'
    MODE=2
  fi
  if [ $1 == "yokohama" ] || [ $1 == "alpha" ]; then
    MSG='sequester yourself in a quiet country café'
    LIST='https://www.youtube.com/playlist?list=PL157A64E54AB333EE'
  fi
  if [ $1 == "glt" ]; then
    MSG='apocalypse nuow'
    LIST='https://www.youtube.com/playlist?list=PL0V1RP49t950z5e_IYNCsoXAUobTa7ppu'
  fi
  if [ $1 == "ugoku" ] || [ $1 == "dab" ]; then
    MSG='ugok now, ku'
    LIST='https://www.youtube.com/watch?v=M28Gzhxvf9w'
    THEEND='*dabs*'
    MODE=2
  fi
  if [ $1 == "moanai" ]; then
    MSG='moanai moanai'
    LIST='https://www.youtube.com/watch?v=M28Gzhxvf9w' # wrong link
    THEEND='dja-ar-ni-i'
    MODE=2
  fi

  if [ $MODE == 1 ]; then
    echo $MSG
    mpv $LIST --no-video --loop-playlist=inf --shuffle --load-unsafe-playlists
  elif [ $MODE == 2 ]; then
    echo $MSG
    mpv $LIST --no-video
    echo $THEEND
  elif [ $MODE == "pureple" ]
  then
	  echo "we ple some $1 files"
	  mpv --no-video --loop-playlist=inf --shuffle *.$1

  fi
}
alias kool='ple kool'
alias giraffe='ple kageki'
alias reborn='ple iamreborn'
alias dab='ple ugoku'
alias angst='angband -mgcu'


gimme() {
    FACE="?"

    case $1 in # single quotes fix everything
        shrug)
            FACE='¯\_(ツ)_/¯'
            ;;
        lenny)
            FACE='( ͡° ͜ʖ ͡°)'
            ;;
    esac
    
    if [ "$FACE" != "?" ]
    then
        echo "Giving you a big ol' $1"
        echo -n "$FACE" | xclip -selection c # dat -n removes newline, yay
    else
        echo "Sorry, no face corresponds to that."
        echo "Try a nose instead?"
    fi
}

# remember the need for spaces here. it's space-sensitive.
# check out the shuffle thingy

# specific renaming purpose
renyou() {
  find -type f -name '*.m4a' | rename -v -v 's/\-...........\.m4a/\.m4a/'
}

what() {
if [ $1 = "am" ]; then
	echo "oh my god"
	if [ $2 = "I" ]; then
		echo "this seems"
		if [ $3 = "doing" ]; then
			echo "hopeless"
		elif [ 2 = 2 ]; then
			echo "to be going somewhere"
		fi
	fi
fi
}

###################
# CONFIG THINGIES #
###################

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

# mysql shell
scowl() {
	mysql -h mysql.stud.iie.ntnu.no -u toberge -p
}

# getting to java folder
cdj() {
  echo "we go to ze javalion"
  cd ~/Dropbox/skoleting/ITHINGDA/java
}
alias cdjava='cdj'

cdc() {
  cdj
  echo "we leave ze javalion alone and see"
  cd ../C
}

# shortcut to java config (Debian distros only, I guess
setj() {
  sudo update-alternatives --config java
  sudo update-alternatives --config javac
}
alias setjava='setj'

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

#neofetch
#if [ $? == 127 ];then
	#echo 'no neofetch you moron'
	#apt list neofetch
	#pacman -Q neofetch
	#echo
	#screenfetch
#fi
