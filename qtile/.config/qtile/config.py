import os
import subprocess

from libqtile import layout, hook
from libqtile.config import Match

from keys import keys, mouse, groups
from colors import colors
# from screens import screens  # also imports all bars


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


# TODO just have sep file
# (but things just CRASH AND BURN when you do that, so...)
# (current lead: stuff not being read as utf-8)
from libqtile.bar import Bar
import libqtile.widget as w

from colors import colors

bar_height = 38
widget_defaults = {
    "foreground": colors["foreground"],
    "font": "FiraMono Nerd Font",
    "fontsize": 16,
    "padding": 4,
}

main_bar = Bar(
    [
        w.CurrentLayoutIcon(),
        w.GroupBox(
            active=colors["foreground"],
            inactive=colors["color8"],
            other_current_screen_border=colors["color8"],
            other_screen_border=colors["color8"],
            this_current_screen_border=colors["color4"],
            this_screen_border=colors["color12"],
            urgent_border=colors["color1"],
            urgent_text=colors["color1"],
        ),
        w.TextBox("", fontsize=22),
        w.Spacer(),
        w.TextBox("", fontsize=22),
        *[
            w.DF(
                foreground=colors["color1"],
                format=" <span weight='bold'>{p} ({uf}{m}|{r:.0f}%)</span>",
                partition=path,
                warn_space=5,
            )
            for path in ["/", "/home/"]
        ],
        w.PulseVolume(emoji=False, fmt="墳 <span weight='bold'>{}</span>"),
        w.Battery(
            battery="BAT0",
            unknown_char="",
            charge_char="",
            discharge_char="",
            empty_char="",
            format="{char} <span weight='bold'>{percent:2.0%}</span>",
        ),
        w.Clock(fmt=" <span weight='bold'>{}</span>"),
        w.CPUGraph(
            border_width=2,
            border_color=colors["color7"],
            graph_color=colors["color7"],
            fill_color=colors["color7"],
        ),
        w.Systray(),
    ],
    bar_height,
    background=colors["background"],
    opacity=0.8,
)

from libqtile.config import Screen

screens = [Screen(top=main_bar), Screen()]

layout_base_config = {
    "border_normal": colors["color8"],
    "border_focus": colors["color12"],
    "border_width": 3,
}
layout_config = {"margin": 18, **layout_base_config}

# Configure the appearance of floating windows
# and what windows should start out floating
floating_layout = layout.Floating(
    **layout_base_config,
    float_rules=[
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
    ]
)

layouts = [
    layout.MonadTall(ratio=0.55, **layout_config),
    layout.MonadWide(ratio=0.55, **layout_config),
    layout.Floating(**layout_base_config),
]

# Prevent trouble with Java applications
wmname = "LG3D"
