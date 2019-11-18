import tempfile
import pathlib
import os
import stat
import pexpect

# https://stackoverflow.com/a/20885799/10155767
try:
    import importlib.resources as pkg_resources
except ImportError:
    # Try backported to PY<37 `importlib_resources`.
    import importlib_resources as pkg_resources


class FifoWolframscriptSession:

    def __init__(self):
        self.temporary_directory = tempfile.TemporaryDirectory(prefix="JWLS-")
        self.temp_path = pathlib.Path(self.temporary_directory.name)

        os.mkfifo(self.temp_path / "wlin.fifo")
        (self.temp_path / "wlout.txt").touch()
        write_script_to(self.temp_path / "JWLS.wl")

        p = str(self.temp_path)
        cmd = f'bash -c "tail -f {p}/wlin.fifo | ' + \
            f'{p}/JWLS.wl --tmpdir={p}"'
        print(cmd)
        self.child = pexpect.spawn(cmd)

    def close(self):
        self.child.sendintr()
        self.temporary_directory.cleanup()


def write_script_to(file_name):
    script = pkg_resources.read_binary(__package__, 'JWLS.wl')
    with open(file_name, "wb") as out_file:
        out_file.write(script)
    os.chmod(file_name, os.stat(file_name).st_mode | stat.S_IEXEC)
