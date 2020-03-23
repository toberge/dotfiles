#! /usr/bin/env bash

# CALICOMP startup tune
mpv $HOME/.sounds/startup.wav &

# pywal + wallpaper
wal -R

# bar and compositor
~/.config/polybar/launch.sh
picom -b --dbus --config ~/.config/picom/picom.conf

# numlock, I need you!
numlockx on

if [[ "$HOSTNAME" == "qualified-desktop" ]]
then # desktop
    . ~/.local/bin/toggletearing.sh
    . ~/.screenlayout/default.sh
else # laptop
    . ~/.local/bin/touchpad.sh
    /usr/bin/xfce-power-manager
fi

# prevent gnome from nagging at admin access stuff
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &

# systray apps, screen filter and notifications
for app in redshift-gtk dunst dropbox pamac-tray nm-applet
do
    if ! ps -e | grep $app > /dev/null
    then # app not launched
        nohup $app &
    fi
done

