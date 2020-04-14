#!/usr/bin/env bash

set -eu # fail early

echo Welcome to this SETUP SCRIPT THINGY
echo First, let\'s check for updates...
sudo pacman -Syu

pacmans=()
aurs=()

while read line
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
            echo ${args[@]}
            ;;
    esac
done < packages.csv

echo
echo Installing repo packages
echo
sudo pacman -S "${pacmans[@]}"

echo
echo Installing AUR packages
echo
yay -S "${aurs[@]}"

echo Listing stowable packages:
ls -F .. | grep -E '^[^_].+/$' | sed 's/\///g'

# maybe some autostowing here?

echo "That's it, you're good to go"

