#!/usr/bin/env python
# coding=utf-8

from libqtile.config import Click, Drag, Group, Key, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from groups import groups

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
