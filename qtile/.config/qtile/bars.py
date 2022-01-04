from libqtile.bar import Bar
import libqtile.widget as w

from colors import colors

widget_defaults = {
    "foreground": colors["foreground"],
    "font": "FiraMono Nerd Font",
    "fontsize": 16,
    "padding": 4,
}

def create_main_bar():
    return Bar(
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
        38,
        background=colors["background"],
        opacity=0.8,
    )
