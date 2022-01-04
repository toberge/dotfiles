#!/usr/bin/env python
# coding=utf-8

from libqtile.config import Screen

from bars import main_bar

screens = [Screen(top=main_bar), Screen()]
