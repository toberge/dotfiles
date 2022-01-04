from libqtile.config import Screen

from bars import create_main_bar

screens = [Screen(top=create_main_bar()), Screen(top=create_main_bar())]
