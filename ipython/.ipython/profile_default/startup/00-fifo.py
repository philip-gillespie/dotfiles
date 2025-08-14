"""
00-fifo.py
"""

import os
from threading import Thread

from IPython.core.getipython import get_ipython
from IPython.core.interactiveshell import InteractiveShell
from pygments import highlight
from pygments.formatters import TerminalFormatter
from pygments.lexers.python import PythonLexer

FIFO_PATH = "/tmp/repl_pipe"

if not os.path.exists(FIFO_PATH):
    os.mkfifo(FIFO_PATH)


def format_code(code: str) -> str:
    highlighted: str = highlight(code, PythonLexer(), TerminalFormatter())
    # Add ">>> " to code inputs
    split = highlighted.split("\n")
    for i, line in enumerate(split[:-1]):
        split[i] = ">>> " + line
    formatted = "\n".join(split)
    # replace tabs with spaces
    output = formatted.replace("\t", " "*4)
    return output


def watch_fifo():
    ipy: InteractiveShell | None = get_ipython()
    if ipy is None:
        raise RuntimeError("This script must be run inside IPython")
    while True:
        with open(FIFO_PATH, "r") as f:
            code = f.read()
        print(format_code(code))
        ipy.run_cell(code)


Thread(target=watch_fifo, daemon=True).start()
