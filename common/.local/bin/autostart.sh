#!/usr/bin/env bash

# CALICOMP startup tune
sfx startup &

picom="picom --daemon --dbus --experimental-backends"

# monitor layout and device specifics
case "${HOSTNAME:-$hostname}" in
    fuglekassa) # desktop
        # only set this option if it is off
        nvidia-settings -tq CurrentMetaMode | grep -q ForceFullCompositionPipeline=On \
            || nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
        [[ "$(xrandr --query | grep -c " connected")" -eq 2 ]] \
            && xrandr --output HDMI-0 --auto --right-of DVI-D-0
        picom="$picom --xrender-sync-fence" # --backend xrender if necessary
        ;;
    thinkpad) # laptop
        ~/.local/bin/trackpoint.sh &
        # libinput-gestures-setup start &
        [[ "$(xrandr --query | grep -c " connected")" -eq 2 ]] \
            && xrandr --output HDMI2 --auto --above eDP1
            # && xrandr --output DP-2 --auto --right-of eDP-1
        # [[ "$(xrandr --query | grep -c " connected")" -eq 2 ]] \
        #     && xrandr --output eDP-1 --off
        ;;
    *)
        ;;
esac

# colors + wallpaper
wal -R
~/.fehbg &

# bar and compositor
$picom --config ~/.config/picom/picom.conf
[[ ! "$DESKTOP_SESSION" =~ ^(spectr|ct)wm$ ]] \
    && ~/.config/polybar/launch.sh &

# numlock, I need you!
numlockx on
# Caps Lock go bye bye
xmodmap ~/.Xmodmap
# and become Escape
pgrep xcape || xcape

# increase speed of spamming
xset r rate 360 42

# just in case wm/de does not set cursor correctly
xsetroot -cursor_name left_ptr

# xautolock but good (could add --not-when-audio)
pgrep xidlehook || xidlehook --not-when-fullscreen --not-when-audio --timer 600 lockmeup '' &

# remind me to take breaks!
i3-gnome-pomodoro start

# for all laptops, do battery and touchpad stuff
# (alternative: check if /sys/class/dmi/id/chassis_type is 9 or 10)
[[  -d /sys/module/battery ]] && {
    ~/.local/bin/touchpad.sh &
    xfce4-power-manager
    pgrep -f battery-warning.sh || ~/.local/bin/battery-warning.sh &
}

# prevent gnome from nagging at admin access stuff
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & \
    eval "$(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)" &

# systray apps, screen filter and notifications
for app in redshift-gtk dunst dropbox pamac-tray nm-applet /opt/BreakTimer/breaktimer
do
    if ! pgrep $app > /dev/null
    then # app not launched
        nohup $app &
    fi
done
