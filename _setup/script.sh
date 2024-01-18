#!/usr/bin/env bash

set -eu # fail early

echo Welcome to this SETUP SCRIPT THINGY
echo First, let\'s check for updates...
sudo pacman -Syu

pacmans=()
aurs=()

while read -r line
do
    IFS=',' read -r -a args <<< "$line"
    case ${args[0]} in
        PAC)
            echo "Installing ${args[1]} - ${args[2]}"
            pacmans+=("${args[1]}")
            ;;
        AUR)
            echo "Installing ${args[1]} - ${args[2]}"
            aurs+=("${args[1]}")
            ;;
        \#\#\#|*)
            # commented out
            echo "${args[@]}"
            ;;
    esac
done < _setup/packages.csv

echo
echo Installing repo packages
echo
sudo pacman --needed -S "${pacmans[@]}"

echo
echo Installing yay
echo
mkdir -p $HOME/.clones
# TODO don't install if existing
(
cd $HOME/.clones
git clone https://aur.archlinux.org/yay.git
makepkg -si
)

echo
echo Installing AUR packages
echo
yay --needed -S "${aurs[@]}"

echo
echo Enabling time synchronization
timedatectl set-ntp true

echo Stowable packages:
echo [^_]*/ | sed 's/\///g'
echo

# maybe some autostowing here?

echo "That's it, you're good to go"
