import os
import sys


def restart(_) -> None:
    """Restart IPython session."""
    os.system("clear")
    os.execv(sys.executable, [sys.executable, "-m", "IPython"])
    return None


def load_ipython_extension(ipython):
    ipython.register_magic_function(restart, "line", "restart")
