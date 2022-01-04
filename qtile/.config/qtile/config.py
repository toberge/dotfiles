import os
import subprocess

from libqtile import layout, hook
from libqtile.config import Match

from keys import keys, mouse, groups
from screens import screens # also imports all bars
from colors import colors


@hook.subscribe.startup_once
def autostart():
    subprocess.Popen(["sfx", "startup"])
    os.system("autorandr")
    os.system("touchpad.sh")
    os.system("trackpoint.sh")
    os.system("wal -R")
    os.system("~/.fehbg")
    os.system("numlockx on")
    os.system("xmodmap ~/.Xmodmap")
    os.system("xset r rate 360 42")
    subprocess.Popen(["picom", "--daemon", "--dbus", "--experimental-backends"])
    subprocess.Popen("xcape")
    subprocess.Popen(
        [
            "xidlehook",
            "--not-when-fullscreen",
            "--not-when-audio",
            "--timer",
            "600",
            "lockmeup",
        ]
    )
    if os.waitstatus_to_exitcode(os.system("pgrep redshift-gtk")) > 0:
        subprocess.Popen("redshift-gtk")
    subprocess.Popen("nm-applet")
    subprocess.Popen("dropbox")


@hook.subscribe.client_new
def launch_sound():
    subprocess.Popen(["sfx", "open"])


@hook.subscribe.client_killed
def close_sound():
    subprocess.Popen(["sfx", "close"])


@hook.subscribe.float_change
def float_sound():
    subprocess.Popen(["sfx", "toggle"])


@hook.subscribe.layout_change
def layout_sound():
    subprocess.Popen(["sfx", "open"])


layout_base_config = {
    "border_normal": colors["color8"],
    "border_focus": colors["color12"],
    "border_width": 3,
}
layout_config = {"margin": 18, **layout_base_config}

# Configure the appearance of floating windows
# and what windows should start out floating
floating_layout = layout.Floating(**layout_base_config, float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class="Lxappearance"),
    Match(wm_class="zoom"),
    Match(wm_class="qt5ct"),
    Match(wm_class="MuseScore: Play Panel"),
    Match(wm_class="Gnome-calculator"),
    Match(wm_class="Godot"),
    Match(wm_class="Xclock"),
    Match(wm_class="MainApp"),
    Match(wm_class="Main"),
])

layouts = [
    layout.MonadTall(ratio=0.55, **layout_config),
    layout.MonadWide(ratio=0.55, **layout_config),
    layout.Floating(**layout_base_config),
]

# Prevent trouble with Java applications
wmname = "LG3D"
