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
