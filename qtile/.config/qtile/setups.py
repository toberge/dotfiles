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
        screens=2, is_laptop=True, cmds=["xrandr --output HDMI-2 --auto --above eDP-1"]
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
