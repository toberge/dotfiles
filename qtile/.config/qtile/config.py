import os
import json
import subprocess
from pathlib import PosixPath
from collections import defaultdict


from libqtile import layout, hook
from libqtile.bar import Bar
import libqtile.widget as w
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# from keys import keys
# from screens import screens
# from colors import colors


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
    subprocess.Popen(["sfx", "toggle"])


def load_colors():
    """Load pywal colors as flat dict"""
    path = PosixPath("~/.cache/wal/colors.json").expanduser()
    try:
        with open(path) as file:
            data = json.load(file)
            return {
                k: v
                for k, v in list(data["colors"].items()) + list(data["special"].items())
            }
    except FileNotFoundError:
        print("Using default colors...")
        return defaultdict(lambda: "#232323")


colors = load_colors()

terminal = guess_terminal()
mod = "mod4"
alt = "mod1"

# default keybinds, replace soon

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "i", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod], "o", lazy.layout.previous(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, alt], "h", lazy.layout.shrink_main(), desc="Shrink main window"),
    Key([mod, alt], "l", lazy.layout.grow_main(), desc="Grow main window"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "s", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "m", lazy.window.toggle_maximize(), desc="Toggle maximize"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    # Key(
    #    [mod, "shift"],
    #    "Return",
    #    lazy.layout.toggle_split(),
    #    desc="Toggle between split and unsplit sides of stack",
    # ),
    Key([mod], "Return", lazy.layout.swap_main(), desc="Swap with main window"),
    Key([mod, "shift"], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "x", lazy.spawn("lockmeup"), desc="Lock the screen"),
    Key([mod, "control"], "x", lazy.spawn("powermenu"), desc="Show the power menu"),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Flameshot"),
    Key(
        ["shift"],
        "Print",
        lazy.spawn("screenshot full"),
        desc="Take screenshot of entire screen",
    ),
    Key(
        ["control"],
        "Print",
        lazy.spawn("screenshot region"),
        desc="Take screenshot of a part of the screen",
    ),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [mod],
        "d",
        lazy.spawn("rofi -show drun -show-icons"),
        desc="Launch apps",
    ),
    Key(
        [mod, "shift"],
        "d",
        lazy.spawn("rofi -show run"),
        desc="Launch terminal apps",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("volume --notify mute"),
        desc="Mute audio",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("volume --notify up"),
        desc="Raise volume",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("volume --notify down"),
        desc="Lower volume",
    ),
    *[
        Key(
            [],
            f"XF86Audio{key}",
            lazy.spawn(f"playerctl --ignore-player=chromium {cmd}"),
            desc=key,
        )
        for key, cmd in [
            ("Play", "play-pause"),
            ("Next", "next"),
            ("Prev", "previous"),
            ("MicMute", "play-pause"),
        ]
    ],
    KeyChord(
        [mod],
        "space",
        [
            Key([], "w", lazy.spawn("firefox"), desc="Launch a web browser"),
            Key([], "d", lazy.spawn("discord"), desc="Launch Discord"),
            Key([], "s", lazy.spawn("steam"), desc="Launch Steam"),
            Key([], "m", lazy.spawn("spotify"), desc="Launch Spotify"),
            Key([], "i", lazy.spawn("intellij-idea"), desc="Launch IntelliJ"),
        ],
    ),
]

groups = [Group(i) for i in "1234567890"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

import libqtile.widget as w

from colors import colors

fg = colors["foreground"]

# eh
soft_sep = {"linewidth": 2, "size_percent": 70, "foreground": "393939", "padding": 7}

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
            fmt="<span weight='bold'>{}</span>",
        ),
        w.TextBox("", fontsize=22),
        w.Spacer(),
        w.TextBox("", fontsize=22),
        w.DF(
            foreground=colors["color1"],
            format=" <span weight='bold'>{p} ({uf}{m}|{r:.0f}%)</span>",
            partition="/",
            warn_space=5,
        ),
        w.DF(
            foreground=colors["color1"],
            format=" <span weight='bold'>{p} ({uf}{m}|{r:.0f}%)</span>",
            partition="/home/",
            warn_space=5,
        ),
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
    38,
    background=colors["background"],
    opacity=0.8,
)

screens = [Screen(top=main_bar), Screen(top=main_bar)]

layout_base_config = {
    "border_normal": colors["color8"],
    "border_focus": colors["color12"],
    "border_width": 3,
}
layout_config = {"margin": 18, **layout_base_config}

layouts = [
    layout.MonadTall(ratio=0.55, **layout_config),
    layout.MonadWide(**layout_config),
    layout.Floating(**layout_base_config),
]

# Prevent trouble with Java applications
wmname = "LG3D"
