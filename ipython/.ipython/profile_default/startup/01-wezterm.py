import matplotlib.pyplot as plt
import io
import subprocess
import tempfile

def wezterm_show():
    buf = io.BytesIO()
    plt.savefig(buf, format="png")
    buf.seek(0)
    with tempfile.NamedTemporaryFile(suffix=".png") as tmp:
        tmp.write(buf.read())
        tmp.flush()
        subprocess.run(["imgcat", tmp.name])
    print("\n")
    return None

plt.show = wezterm_show
