import os
import subprocess

from libqtile import layout, hook
from libqtile.config import Match

# Setups {{{

import platform
from dataclasses import dataclass, field
from typing import List

hostname = platform.node()


@dataclass
class Setup:
    screens: int = 1
    is_laptop: bool = False
    cmds: List[str] = field(default_factory=list)


setups = {
    "thinkpad": Setup(
        screens=1,
        is_laptop=True,
        # cmds=["xrandr --output HDMI-2 --auto --above eDP-1"],
    ),
    "fuglekassa": Setup(
        screens=2,
        cmds=[
            """
nvidia-settings -tq CurrentMetaMode | grep -q ForceFullCompositionPipeline=On \
    || nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"'

            """
        ],
    ),
}

setup = setups[hostname]

# }}}

# Colors {{{

import json
from pathlib import PosixPath
from collections import defaultdict


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

# }}}

# Hooks {{{

@hook.subscribe.startup_once
def autostart():
    subprocess.Popen(["sfx", "startup"])
    os.system("autorandr")
    os.system("wal -R")
    os.system("~/.fehbg")
    os.system("numlockx on")
    os.system("xmodmap ~/.Xmodmap")
    os.system("xset r rate 360 42")

    # Run setup-specific cmds
    if setup.is_laptop:
        os.system("touchpad.sh")
        os.system("trackpoint.sh")
        subprocess.Popen("xcape")
    for cmd in setup.cmds:
        os.system(cmd)

    # Launch some background processes
    subprocess.Popen(["picom", "--daemon", "--dbus", "--experimental-backends"])
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
    # Avoid opening two Redshift instances since that causes flicker
    if os.waitstatus_to_exitcode(os.system("pgrep redshift-gtk")) > 0:
        subprocess.Popen("redshift-gtk")
    subprocess.Popen("nm-applet")
    subprocess.Popen("dropbox")


@hook.subscribe.startup
def always_start():
    os.system("~/.fehbg")


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

# }}}

# Bar(s) {{{

from libqtile.bar import Bar
import libqtile.widget as w

bar_height = 38
widget_defaults = {
    "foreground": colors["foreground"],
    "font": "FiraMono Nerd Font",
    "fontsize": 16,
    "padding": 4,
}


def create_bar(main=False):
    widgets = [
        w.CurrentLayoutIcon(scale=0.8, foreground=colors["foreground"]),
        w.GroupBox(
            active=colors["foreground"],
            inactive=colors["color8"],
            other_current_screen_border=colors["color8"],
            other_screen_border=colors["color8"],
            this_current_screen_border=colors["color4"],
            this_screen_border=colors["color12"],
            urgent_border=colors["color1"],
            urgent_text=colors["color1"],
            disable_drag=True,
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
    ]
    if main:
        widgets.append(w.Systray())
    else:
        widgets.append(
            w.CPUGraph(
                border_width=2,
                border_color=colors["color7"],
                graph_color=colors["color7"],
                fill_color=colors["color7"],
            )
        )
    return Bar(
        widgets,
        bar_height,
        background=colors["background"],
        opacity=0.8,
    )


# }}}

# Groups {{{

from libqtile.config import Group, Match

setup = setups[hostname]

main_screen = 0
side_screen = 1
if setup.is_laptop and setup.screens == 2:
    main_screen = 1
    side_screen = 0
elif setup.is_laptop and setup.screens == 1:
    main_screen = side_screen = 0

groups = [
    Group("1", screen_affinity=main_screen),
    Group("2", spawn="firefox", screen_affinity=main_screen),
    Group("3", screen_affinity=main_screen),
    Group("4", matches=[Match(wm_class="jetbrains-idea")], screen_affinity=main_screen),
    Group("5", screen_affinity=main_screen),
    Group("6", screen_affinity=side_screen),
    Group("7", screen_affinity=side_screen),
    Group("8", matches=[Match(title="Steam")], screen_affinity=side_screen),
    Group("9", screen_affinity=side_screen),
    Group(
        "0",
        spawn="discord",
        matches=[Match(wm_class="discord")],
        screen_affinity=side_screen,
    ),
]

# }}}

# Screens {{{

from libqtile.config import Screen


screens = [
    Screen(top=create_bar(main=True)),
    *[Screen(top=create_bar()) for i in range(setup.screens - 1)],
]

# }}}

# Layouts {{{

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
        Match(wm_instance_class="floater"),
        Match(wm_class="Lxappearance"),
        Match(wm_class="zoom"),
        Match(wm_class="qt5ct"),
        Match(wm_class="MuseScore: Play Panel"),
        Match(wm_class="Gnome-calculator"),
        Match(wm_class="Godot"),
        Match(wm_class="jetbrains-idea", title="win0"),
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

# }}}

# Keybinds {{{

from libqtile.config import Click, Drag, Group, Key, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

terminal = guess_terminal()
mod = "mod4"
alt = "mod1"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "Return", lazy.layout.swap_main(), desc="Swap with main window"),
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
    # Grow windows (or main window in dynamic tiling layouts).
    Key([mod, alt], "h", lazy.layout.shrink_main(), desc="Shrink main window"),
    Key([mod, alt], "l", lazy.layout.grow_main(), desc="Grow main window"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    # Window control
    Key([mod], "s", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "m", lazy.window.toggle_maximize(), desc="Toggle maximize"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod, "shift"], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # System control
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "x", lazy.spawn("lockmeup"), desc="Lock the screen"),
    Key([mod, "control"], "x", lazy.spawn("powermenu"), desc="Show the power menu"),
    # Screenshots
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
    Key([mod], "c", lazy.spawn("color"), desc="Pick a color from the screen"),
    # Media control
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
    # Launchers
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
        [mod],
        "period",
        lazy.spawn("rofi -show emoji"),
        desc="Emoji keyboard",
    ),
    Key(
        [mod, "shift"],
        "period",
        lazy.spawn("splatmoji --disable-emoji-db copy"),
        desc="Emoji keyboard",
    ),
    # Launch specific apps
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

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
]

for g in groups:
    keys.extend(
        [
            # mod + number of group = switch to group
            Key(
                [mod],
                g.name,
                lazy.group[g.name].toscreen(int(g.screen_affinity), toggle=True),
                lazy.to_screen(int(g.screen_affinity)),
                desc="Switch to group {}".format(g.name),
            ),
            # # mod + shift + number of group = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc="Switch to & move focused window to group {}".format(i.name),
            # ),
            # Or, use below if you prefer not to switch to that group.
            # mod1 + shift + number of group = move focused window to group
            Key(
                [mod, "shift"],
                g.name,
                lazy.window.togroup(g.name),
                desc="move focused window to group {}".format(g.name),
            ),
        ]
    )

# }}}

# Options {{{

# Jesus Christ
auto_minimize = False

# Prevent trouble with Java applications
wmname = "LG3D"

# }}}
