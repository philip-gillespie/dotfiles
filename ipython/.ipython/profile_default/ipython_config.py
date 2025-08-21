import os
import sys

import matplotlib

matplotlib.use("kitcat")

config_dir = os.path.join(
    os.path.expanduser("~"),
    ".ipython",
    "profile_default",
    "extensions",
)
if config_dir not in sys.path:
    sys.path.append(config_dir)

c.InteractiveShellApp.extensions = ["restart"]
c.TerminalInteractiveShell.editing_mode = "vi"
