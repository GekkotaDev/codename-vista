from typing import Any, Callable, TypedDict, Literal, Annotated

import json
import pathlib
import shutil
import stat
import subprocess
import os

import pyjson5 as json5
import typer

from rich import print
from rich.prompt import Confirm

from utils import __dir__, link  # ty:ignore[unresolved-import]


class Addon(TypedDict):
    url: str
    source: str | None
    subfolder: str


ci = typer.Typer()

app = typer.Typer()
app.add_typer(ci, name="ci")


@app.command()
def setup():
    """
    Set up the development environment.
    """

    null_target = pathlib.Path(".void")

    if os.name == "nt":
        subprocess.run(
            ["mklink", "/D", null_target, "NUL:"], shell=True, capture_output=True
        )
    else:
        os.link(os.devnull, null_target)


@app.command()
def sync(skip_install: Annotated[bool, typer.Option] = False):
    """
    Update dependencies.
    """

    EMOJI_INFO = "ℹ️"

    def on_rmtree_exc(func: Callable[..., Any], path: str, _: Any):
        """
        Error handler for ``shutil.rmtree``.

        If the error is due to an access error (read only file)
        it attempts to add write permission and then retries.

        If the error is for another reason it re-raises the error.

        Usage : ``shutil.rmtree(path, onerror=onerror)``
        """
        # Is the error an access error?
        if not os.access(path, os.W_OK):
            os.chmod(path, stat.S_IWUSR)
            func(path)
        else:
            raise

    # addons = pathlib.Path("addons")

    # if addons.exists():
    #     shutil.rmtree(
    #         addons,
    #         onexc=on_rmtree_exc,
    #     )

    # subprocess.run(
    #     ["dotnet", "godotenv", "addons", "install"],
    #     # stderr=subprocess.DEVNULL,
    # )
    print(f"{EMOJI_INFO}  [blue]Fetching dependencies...[/blue]")

    try:
        if not skip_install:
            subprocess.run(
                ["dotnet", "godotenv", "addons", "install"],
                check=True,
                capture_output=True,
            )
    except subprocess.CalledProcessError as error:
        if error.returncode != 1:
            print(f"[red]{error.stdout}[/red]")
            print(f"[red]{error.stderr}[/red]")
            raise error

    print(f"{EMOJI_INFO}  [blue]Linking dependencies...[/blue]")

    ADDONS = __dir__ / "addons.jsonc"

    target = __dir__ / pathlib.Path("addons")
    config: dict[str, Any] = {}
    addons: dict[str, Addon] = {}

    if target.exists():
        shutil.rmtree(
            target,
            onexc=on_rmtree_exc,
        )

    with open(ADDONS) as file:
        config = json5.loads("".join(line for line in file))
        addons = config["addons"]

    cache = __dir__ / pathlib.Path(config["cache"])
    local = __dir__ / ".addons" / "local"

    if not target.exists():
        target.mkdir()

    for name, addon in addons.items():
        if not (cache / name).exists():
            continue

        if ("source" not in addon) or (addon["source"] == "remote"):
            link(cache / name / addon["subfolder"], target / name)
            continue

        # Resolve Godotenv's complicated remote zip management.
        uuids = [
            directory.name
            for directory in os.scandir(cache / name)
            if directory.is_dir()
        ]

        if len(uuids) < 1:
            print(cache / name)
            print([*os.scandir(cache / name)])
            continue

        uuid = uuids[0]

        if not f"{(cache / name / uuid / addon['subfolder']).parent}".endswith(
            "addons"
        ):
            link(cache / name / uuid / addon["subfolder"], target / name)
            continue

        children = [
            directory
            for directory in os.scandir(
                (cache / name / uuid / addon["subfolder"]).parent
            )
            if directory.is_dir()
        ]

        for child in children:
            link(child.path, target / child.name)

    for addon in [directory for directory in os.scandir(local) if directory.is_dir()]:
        link(addon.path, target / addon.name)

    print("[green][bold]Finished![/bold][/green]")


@app.command()
def force_pull():
    """
    Forcefully pulls code from the remote repository eradicating all unsaved changes.
    """

    LABEL_INFO = "[bold blue]INFO[/bold blue]"
    LABEL_WARN = "[bold yellow]WARN[/bold yellow]"

    permission = Confirm.ask(
        f"{LABEL_WARN} All uncommitted work will be lost, continue?"
    )

    if (
        not permission
        and shutil.which("lazygit")
        and Confirm.ask(f"{LABEL_INFO} Commit files with Lazygit?")
    ):
        subprocess.run(["lazygit"], shell=False)
        return

    if (
        not permission
        and shutil.which("gitui")
        and Confirm.ask(f"{LABEL_INFO} Commit files with gitui?")
    ):
        subprocess.run(["gitui"], shell=False)
        return

    if not permission:
        return

    subprocess.run(["git", "add", "."], shell=False)
    subprocess.run(["git", "stash"], shell=False)
    subprocess.run(["git", "pull"], shell=False)
    subprocess.run(["git", "stash", "drop"], shell=False)


@ci.command()
def addons(type: Literal["zip", "remote"] = "remote"):
    """
    JSON formatted list of addons.
    """
    ADDONS = __dir__ / "addons.jsonc"
    addons: dict[str, Addon] = {}

    with open(ADDONS) as file:
        addons = json5.loads("".join(line for line in file))["addons"]

    zips: dict[str, Addon] = {}
    remotes: dict[str, Addon] = {}

    if len(addons) <= 0:
        return print("{}")

    for name, addon in addons.items():
        if "source" not in addon:
            addon["source"] = "remote"

        if addon["source"] == "remote":
            remotes[name] = addon
            continue

        if addon["source"] == "zip":
            zips[name] = addon
            continue

    match type:
        case "remote":
            return print(json.dumps(remotes))

        case "zip":
            return print(json.dumps(zips))


if __name__ == "__main__":
    app()
