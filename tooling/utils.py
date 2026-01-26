from typing import Any

import os
import pathlib
import shutil
import subprocess


type PathLike = str | bytes | pathlib.Path


__dir__ = pathlib.Path(__file__).parent.parent

CI = os.getenv("CI_CD")


def void(*_: Any) -> None:
    pass


def link(source: PathLike, destination: PathLike):
    if CI:
        shutil.copytree(f"{source}", f"{destination}", dirs_exist_ok=True)
        return

    if os.name == "nt":
        subprocess.run(
            ["mklink", "/D", destination, source], shell=True, capture_output=True
        )
    else:
        os.symlink(source, destination)
