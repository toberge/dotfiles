#!/usr/bin/env bash

# CALICOMP startup tune
sfx startup &

# monitor layout and device specifics
case "$HOSTNAME" in
    fuglekassa) # desktop
        ~/.local/bin/toggletearing.sh
        [[ "$(xrandr --query | grep -c " connected")" -eq 2 ]] \
            && xrandr --output HDMI-0 --auto --right-of DVI-D-0
        ;;
    thinkpad)
        [[ "$(xrandr --query | grep -c " connected")" -eq 2 ]] \
            && xrandr --output HDMI2 --auto --above eDP1
        ;;
    *)
        ;;
esac

# colors + wallpaper
wal -R
~/.fehbg &

# bar and compositor
picom -b --dbus --config ~/.config/picom/picom.conf
[[ ! "$DESKTOP_SESSION" =~ ^(spectr|ct)wm$ ]] \
    && ~/.config/polybar/launch.sh &

# numlock, I need you!
numlockx on
# Caps Lock go bye bye
xmodmap ~/.Xmodmap
# and become Escape
xcape

# increase speed of spamming
xset r rate 360 42

# just in case wm/de does not set cursor correctly
xsetroot -cursor_name left_ptr

# xautolock but good (could add --not-when-audio)
xidlehook --not-when-fullscreen --timer 600 lockmeup '' &

# remind me to take breaks!
i3-gnome-pomodoro start

# for all laptops, do battery and touchpad stuff
[ -d /sys/class/power_supply/BAT* ] && {
    ~/.local/bin/touchpad.sh
    xfce4-power-manager
    ~/.local/bin/battery-warning.sh &
}

# prevent gnome from nagging at admin access stuff
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & \
    eval "$(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)" &

# systray apps, screen filter and notifications
for app in redshift-gtk dunst dropbox pamac-tray nm-applet
do
    if ! pgrep $app > /dev/null
    then # app not launched
        nohup $app &
    fi
done
