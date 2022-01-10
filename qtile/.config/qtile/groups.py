from libqtile.config import Group, Match
from setups import setups, hostname

setup = setups[hostname]

main_screen = 0
side_screen = 1
if setup.is_laptop and setup.screens == 2:
    main_screen = 1
    side_screen = 0

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
