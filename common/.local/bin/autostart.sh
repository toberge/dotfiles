#!/usr/bin/env bash

# CALICOMP startup tune
mpv $HOME/.sounds/startup.wav &

# pywal + wallpaper
wal -R
$HOME/.fehbg &

# bar and compositor
~/.config/polybar/launch.sh
picom -b --dbus --config ~/.config/picom/picom.conf

# numlock, I need you!
numlockx on

# just in case wm/de does not set cursor correctly
xsetroot -cursor_name left_ptr &

# xautolock but good (could add --not-when-audio)
xidlehook --not-when-fullscreen --timer 600 lockmeup '' &

# remind me to take breaks!
i3-gnome-pomodoro start

if [[ "$HOSTNAME" == "fuglekassa" ]]
then # desktop
    ~/.local/bin/toggletearing.sh
    ~/.screenlayout/default.sh
elif [[ -d /sys/class/power_supply/BAT* ]]
then # laptop
    ~/.local/bin/touchpad.sh
    /usr/bin/xfce-power-manager
    ~/.local/bin/battery-warning.sh
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

