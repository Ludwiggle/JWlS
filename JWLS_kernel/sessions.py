import tempfile
import pathlib
import os
import stat
import pexpect
import re
from notebook.notebookapp import list_running_servers

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
        os.mkdir(self.temp_path / "output_files")
        self.symlink_dest = pathlib.Path(get_notebook_directory()) / self.temp_path.name
        os.symlink(
            self.temp_path / "output_files",
            self.symlink_dest
        )

        p = str(self.temp_path)
        cmd = f'bash -c "tail -f {p}/wlin.fifo | ' + \
            f'{p}/JWLS.wl --tmpdir={p} ' + \
            f'--url={get_notebook_url()}files/{self.temp_path.name}"'
        print(cmd)
        self.child = pexpect.spawn(cmd)

    def close(self):
        self.child.sendintr()
        try:
            self.symlink_dest.unlink()
        except FileNotFoundError:
            pass
        self.temporary_directory.cleanup()


def write_script_to(file_name):
    script = pkg_resources.read_binary(__package__, 'JWLS.wl')
    with open(file_name, "wb") as out_file:
        out_file.write(script)
    os.chmod(file_name, os.stat(file_name).st_mode | stat.S_IEXEC)

def get_notebook_directory():
    # This may get confused when multiple servers exist.
    # It is possible to try to connect to the notebook
    # and search for a match for our particular kernel
    # (e.g. https://stackoverflow.com/a/52187331/10155767 )
    # but this is going to fail with password auth.
    return next(list_running_servers())['notebook_dir']

def get_notebook_url():
    # See note above.
    my_url = next(list_running_servers())['url']
    # The token is suggested with IP 127.0.0.1 even when
    # the running server is 0.0.0.0.
    my_url = re.sub(
        r'http(s?)://0.0.0.0',
        r'http\1://127.0.0.1',
        my_url
    )
    return my_url
