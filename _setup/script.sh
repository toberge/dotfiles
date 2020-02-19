#!/usr/bin/env bash

echo Welcome to this SETUP SCRIPT THINGY
echo First, let\'s check for updates...
sudo pacman -Syu

while read line
do
    IFS=',' read -r -a args <<< "$line"
    case ${args[0]} in
        PAC)
            echo "Installing ${args[1]} - ${args[2]}"
            sudo pacman -S "${args[1]}"
            ;;
        AUR)
            echo "Installing ${args[1]} - ${args[2]}"
            yay -S "${args[1]}"
            ;;
        \#\#\#|*)
            # commented out
            echo ${args[@]}
            ;;
    esac
done < packages.csv

# maybe some autostowing here?

echo "That's it, you're good to go"
