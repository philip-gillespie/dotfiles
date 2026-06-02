from IPython.core.interactiveshell import InteractiveShell



def reverse(line: str) -> str:
    """reverse a string"""
    return line[::-1]


def load_ipython_extension(ipython: InteractiveShell):
    ipython.register_magic_function(reverse, "line", "reverse")


def unload_ipython_extension(ipython: InteractiveShell):
    if "reverse" in ipython.magics_manager.magics["line"]:
        del ipython.magics_manager.magics["line"]["reverse"]
