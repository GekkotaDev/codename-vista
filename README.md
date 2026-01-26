<hgroup>
  <h1 align="center">
    <code>CODENAME</code> <i>Vista</i>
  </h1>
  <p align="center">
    <i>WIP game in relation to university thesis.</i>
  </p>
</hgroup>

<p align="center">
  <img src="./docs/assets/images/wip.png" width="255" />
  <p align="center">🤫</p>
</p>

## 🛠️ Development

<details>
  <summary>
    <b>Prerequisites</b>
  </summary>

  - Godot 4.5.x+
  - [`uv`](https://docs.astral.sh/uv/getting-started/installation/)
    - [Python](https://docs.astral.sh/uv/guides/install-python/)
  - [.NET SDK](https://dotnet.microsoft.com/en-us/download)
  - [Git](https://git-scm.com)

  This is automatically taken care of by [`setup.ps1`](./setup.ps1)

  If you wish to use that instead clone the project onto a folder on your computer
  and open up Powershell to run the following.
  ```pwsh
  # cd means "Change Directory/Folder"
  cd "path/to/the/project"
  
  # Verify if you're in the project folder
  if (Test-Path project.godot) { echo "You're in the project folder ✅" }

  # Run the setup script
  ./setup.ps1
  ```
</details>

<details>
  <summary>
    <b>Guides</b>
  </summary>

  Got lost? Here's some generally (though non-specific) useful resources.

  - [Official Godot Engine Documentation]: in addition to documentation for the
    engine's features, you'll find a comprehensive set of tutorials, resources,
    and guides available.
  - [Additional Godot learning resources](https://docs.godotengine.org/en/stable/community/tutorials.html)
  - [git - the simple guide - no deep s#!t]: straight to the point tutorial on how to use 
    Git on a new blank project but works well as a reference guide too.
  - [The Catalog of Design Patterns]: Or what exactly does this person mean when they say
    things such as "observers", "factory methods", etc. Not crucial to know, just
    something to look up in case of confusion.
</details>

[Official Godot Engine documentation]: https://docs.godotengine.org/
[git - the simple guide - no deep s#!t]: https://rogerdudler.github.io/git-guide/
[The Catalog of Design Patterns]: https://refactoring.guru/design-patterns/catalog
