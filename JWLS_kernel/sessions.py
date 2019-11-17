import tempfile
import pathlib
import os
import pexpect

class FifoWolframscriptSession:

    def __init__(self):
        self.temporary_directory = tempfile.TemporaryDirectory(prefix="JWLS-")
        self.temp_path = pathlib.Path(self.temporary_directory.name)

        os.mkfifo(self.temp_path / "wlin.fifo")
        (self.temp_path / "wlout.txt").touch()

        p = str(self.temp_path)
        cmd = f'bash -c "tail -f {p}/wlin.fifo | ' + \
            f'JWLS.wl --tmpdir={p}"'
        print(cmd)
        self.child = pexpect.spawn(cmd)

    def close(self):
        self.child.sendintr()
        self.temporary_directory.cleanup()