# Automatic setup
# iex (iwr "https://raw.githubusercontent.com/GekkotaDev/codename-vista/refs/heads/main/install.ps1").Content

$GodotVersion = "4.6"

function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $Output,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Warn", "Error", "Log")]
        [String]
        $Type = "Log",

        [Parameter(Mandatory = $false)]
        [Boolean]
        $NoNewline = $false
    )

    if ($Output -eq " ") {
        Write-Output ""
        return
    }

    if ($Type -eq "Info") {
        Write-Host " " -NoNewline
        Write-Host " INFO " -NoNewline -BackgroundColor Blue
    }

    if ($Type -eq "Warn") {
        Write-Host " " -NoNewline
        Write-Host " WARN " -NoNewline -BackgroundColor Yellow
    }

    if ($Type -eq "Error") {
        Write-Host " ERROR " -NoNewline -BackgroundColor Red
    }

    if ($Type -eq "Log") {
        Write-Output $Output
        return
    }

    if ($NoNewline -eq $true) { Write-Host " $($Output)" -NoNewline  }
    else { Write-Host " $($Output)" }
}

function Query-Host {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $Output,

        [Parameter(Mandatory = $false)]
        [switch]
        $Loop = $true
    )

    while ($Loop) {
        Write-Log $Output -NoNewline
        $Result = (Read-Host " [y/n]").ToLower()

        if ($Result -eq "y") {
            return $true
        }

        if ($Result -eq "n") {
            return $false
        } 
    }

    return $false
}

function Test-Command($Command) {
    $Result = [bool](Get-Command -Name $Command -ErrorAction Ignore)
    return $Result -eq $false
}



Write-Log "If working on the codebase is a bit too much, there's also the lore" -Type Info
Write-Log "document (different from documentation/thesis paper) and the game" -Type Info
Write-Log "assets that need to be worked on." -Type Info
Write-Log " "
Write-Log " "
Write-Log " "



if (Test-Command "scoop") {
    Write-Log "An additional dependency needs to be manually installed before continuing." -Type Warn
    Write-Log "It is necessary in order to automatically install other necessary tooling." -Type Warn
    Write-Log " "
    Write-Log "To install scoop, run the following commands in Powershell" -Type Info
    Write-Log "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
    Write-Log "irm get.scoop.sh | iex"
    Write-Log " "
    Write-Log "By default, it will install to $home\scoop" -Type Info
    Write-Log "To change the install location, run this BEFORE installing." -Type Info
    Write-Log '$env:SCOOP="C:/path/to/my/folder"'
    return
}
else {
    Write-Log "Scoop detected. Proceeding to setup the development environment" -Type Info
}



if (Test-Command "git") { 
    Write-Log "Installing Git." -Type Info
    scoop install git
    Write-Log "Git installed." -Type Info
}
if (Test-Command "gh" ) { 
    Write-Log "Installing GitHub CLI (Command Line Interface)." -Type Info
    scoop install gh 
    Write-Log "GitHub CLI (Command Line Interface) installed." -Type Info
}

if (Test-Command "dotnet") {
    Write-Log "Installing C#." -Type Info
    scoop install dotnet-sdk
    Write-Log "C# installed." -Type Info

    Write-Log "Attempting to run dotnet tool restore in the project" -Type Info
    dotnet tool restore
}

if (Test-Command "uv") { 
    Write-Log "Installing uv." -Type Info
    scoop install uv
    uv python install "3.15"
    Write-Log "uv successfully set up." -Type Info

    Write-Log "This project uses a bunch of addons" -Type Info
    uv run tooling sync

    Write-Log " "
    Write-Log "We use addons as to not code things from scratch" -Type Info
    Write-Log "https://godotengine.org/asset-library/asset"
    Write-Log " "
}

if (Test-Command "godot-mono") {
    Write-Log "Installing Godot ${GodotVersion}" -Type Info
    scoop install "godot-mono@${GodotVersion}"
    Write-Log "Godot ${GodotVersion} installed." -Type Info
    Write-Log "HINT: Enter 'godot-mono' to open Godot from the terminal."
}



while ($true) {
    $registered = (Read-Host "Have you created a GitHub account yet? [y/n]").ToLower()
    
    if ($registered -eq "y") {
        $authenticated = (Read-Host "Have you authenticated Git with your Github account? [y/n]").ToLower()

        if ($authenticated -eq "y") { 
            Clear-Host
            break 
        }

        Write-Log "Please authenticate Git using your GitHub account" -Type Info
        Write-Log " "
        Write-Log "Select the following options" -Type Info
        Write-Log "GitHub.com"
        Write-Log "HTTPS"
        Write-Log "Yes"
        Write-Log "Login wth a web browser"
        gh auth login
        Write-Log "Please kindly inform me of your username on Github" -Type Info
        Write-Log "so that I may invite you to the codebase (otherwise" -Type Info
        Write-Log "it won't give you permission to edit)" -Type Info
        Read-Host "> PRESS ENTER TO CONTINUE"
        Clear-Host
        break
    }

    if ($registered -eq "n") {
        Write-Log "Please create a GitHub account." -Type Info
        return
    }
}



Write-Log "I assume that everything had been installed correctly by this script"
Write-Log "and it gave you all the necessary tooling. Additional programs such"
Write-Log "as your prefered editor, sprite/texture editor, etc. are up to your"
Write-Log "own discretion/as needed."
Write-Log " "
Write-Log "If you ever add an addon to addons.jsonc, remember to run this command"
Write-Log " "
Write-Log "uv run tooling sync"
Write-Log " "
Write-Log "And if it's a new plugin not used yet before to enable it in Godot."
Write-Log " "
Write-Log " "
Write-Log " "

$lecture = Query-Host "Would you like a quick lecture on Git?" -Loop

if ($lecture -eq $false) {
    Write-Log "Understandable, have a great day ✌️"
    return
}

Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "To get your own copy of any given codebase, you can run this command" -Type Info
Write-Log "in order to get one with Git already initialized on your computer." -Type Info
Write-Log " "
Write-Log "git clone https://github.com/username/repository.git <folder/to/place/it/inside>"
Write-Log " "
Write-Log "Where <folder/to/place/it/inside> is substituted with a path to the" -Type Info
Write-Log "folder you would like for it to be cloned to. For example, assuming" -Type Info
Write-Log "you were currently working in this directory/folder from the terminal" -Type Info
Write-Log " "
Write-Log "$($home)/Documents/Code/Games"
Write-Log " "
Write-Log "And you wanted to put it in $($home)/Documents/Code/Games/banana-project," -Type Info
Write-Log "you would want to run 'git clone' like this" -Type Info
Write-Log " "
Write-Log "git clone https://github.com/username/repository.git banana-project"
Write-Log " "
Write-Log "Or alternatively!" -Type Info
Write-Log " "
Write-Log "git clone https://github.com/username/repository.git $($home)/Documents/Code/Games/banana-project"
Write-Log " "
Read-Host "Press enter to continue."
Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "Now, proceed if you've gotten confirmation you were added as a" -Type Info
Write-Log "developer on the Github repository of our game. Here, you can clone" -Type Info
Write-Log "a copy of the thesis game repo onto your computer using the following command" -Type Info
Write-Log " "
Write-Log "git clone https://github.com/gekkotadev/codename-vista.git <folder/to/place/it/inside>"
Write-Log " "
Write-Log "Here, I'll automatically clone it for you. Just tell me where to clone" -Type Info
Write-Log "it. (or leave blank to clone it HERE)" -Type Info
Write-Log " "

$cloneTarget = Read-Host "Target folder?"
if ($cloneTarget -eq "") { $cloneTarget = "." }

git clone "https://github.com/gekkotadev/codename-vista.git" $cloneTarget

Write-Log " "
Write-Log "As a quick note, if you've downloaded a repository as a Zip file and" -Type Info
Write-Log "unzipped it somewhere, you can turn that folder into a Git repository" -Type Info
Write-Log "and synchronize it with the origin (the copy hosted on Github) using" -Type Info
Write-Log "the following commands." -Type Info
Write-Log " "
Write-Log 'cd "path/to/the/project"'
Write-Log 'if (Test-Path project.godot) { echo "Youre in the project folder ✅" }'
Write-Log "git init -b main"
Write-Log "git remote add origin https://github.com/gekkotadev/codename-vista.git"
Write-Log "git fetch"
Write-Log "git reset origin/main"
Write-Log "git checkout -t origin/main"
Write-Log " "
Read-Host "Press enter to continue."
Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "Now by this point you can start programming, adding new files and" -Type Info
Write-Log "making changes to existing files. One might assume that Git works" -Type Info
Write-Log "like Google Drive but it doesn't work that way, better to think of" -Type Info
Write-Log "more closely like a logbook" -Type Info
Write-Log " "
Write-Log "This enables Git to efficiently keep track of how a codebase evolves" -Type Info
Write-Log "through a quite complex algorithm underneath, enabling developers to" -Type Info
Write-Log "keep track of what's going on and to more easily roll back changes" -Type Info
Write-Log "that traditional live colloborative/cloud editing doesn't offer" -Type Info
Write-Log " "
Write-Log "In addition, this also grants additional benefits such as" -Type Info
Write-Log " "
Write-Log "- Being able to work on features in your local copy of the codebase"
Write-Log "  without fear that changes made by other developers would suddenly"
Write-Log "  break what you were working on."
Write-Log " "
Write-Log "- Being able to automatically run scripts automatically in response"
Write-Log "  to newly pushed commits on origin."
Write-Log " "
Write-Log "- Being able to review proposed code changes before they are merged"
Write-Log "  into origin through a process called pull requests."
Write-Log " "
Read-Host "Press enter to continue."
Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "You've heard of pull requests from earlier, a process where you can" -Type Info
Write-Log "propose codebase changes for review before they're merged. This is" -Type Info
Write-Log "particularly important to know when working collaboratively" -Type Info
Write-Log " "
Write-Log "This is something that happens 'transparently' (not something you" -Type Info
Write-Log "would actively think about). Create a branch like so" -Type Info
Write-Log " "
Write-Log "git checkout -b <branch-name>"
Write-Log " "
Write-Log "Make sure you've done this before adding, commiting, and pushing or" -Type Info
Write-Log "else you'll have to rebase or reset." -Type Info
Write-Log " "
Write-Log "I advise you make a descriptive name for the branch. Perhaps you're" -Type Info
Write-Log "working on updating the save system and would like for someone else" -Type Info
Write-Log "to review your work. How about this name for the branch" -Type Info
Write-Log " "
Write-Log "git checkout -b save-revamp"
Write-Log " "
Write-Log "You'll get to see it in action when you push your changes to origin" -Type Info
Write-Log " "
Write-Log "If you want to skip the review process then just switch back to the" -Type Info
Write-Log "main branch before adding, commiting, pushing any code." -Type Info
Write-Log " "
Write-Log "git checkout main"
Write-Log " "
Write-Log "Here's a short guide on branching. (the website itself is very useful)" -Type Info
Write-Log " "
Write-Log "https://rogerdudler.github.io/git-guide/#branching"
Write-Log " "
Write-Log "And explanations of the flags -b and -d" -Type Info
Write-Log " "
Write-Log "-b creates a new branch and switches to that branch"
Write-Log " "
Read-Host "Press enter to continue."
Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "In order for Git to keep track of the files that you've changed or" -Type Info
Write-Log "added, you can run git add. Here's some examples" -Type Info
Write-Log " "
Write-Log "git add install.ps1"
Write-Log "git add tests/test_feature.gd"
Write-Log "git add libraries/battle_system/**/*.gd"
Write-Log "git add ."
Write-Log " "
Write-Log "The last command in particular means 'I'm telling you I want you to" -Type Info
Write-Log "to keep track of all the files I've just changed' but that's not" -Type Info
Write-Log "recommended as it makes it difficult to give it a descriptive commit" -Type Info
Write-Log "message. What's a commit you may ask?" -Type Info
Write-Log " "
Read-Host "Press enter to continue."
Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "Commits are how you tell Git 'Yeah, I wanna log this down now'. Just" -Type Info
Write-Log "like logbooks you'll need attach useful messages describing what you" -Type Info
Write-Log "meant to do with these changes you've made" -Type Info
Write-Log " "
Write-Log "Here's how to commit. (not dating advice)" -Type Info
Write-Log " "
Write-Log 'git commit -m "implemented test for feature A"'
Write-Log " "
Read-Host "Press enter to continue."
Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "Now that you've commited your changes, you need to push them to the" -Type Info
Write-Log "MAIN copy that lives on a server (Github) that Git refers to as ORIGIN." -Type Info
Write-Log " "
Write-Log "To push changes to origin, you may run the following command." -Type Info
Write-Log " "
Write-Log "git push origin <branch-name>"
Write-Log " "
Write-Log "I hope you've remembered the name of the branch." -Type Info
Write-Log " "
Read-Host "Press enter to continue."
Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "Now one more thing. If you want to update your local copy of the" -Type Info
Write-Log "with the changes made at origin, run the following command" -Type Info
Write-Log " "
Write-Log "git pull"
Write-Log " "
Write-Log "But you may want to be aware of git pull --rebase" -Type Info
Write-Log " "
Write-Log "https://youtu.be/xN1-2p06Urc"
Write-Log " "
Write-Log "Where it can get tricky however are with merge conflicts. Oh no. This" -Type Info
Write-Log "video by Philomatics might help" -Type Info
Write-Log " "
Write-Log "https://youtu.be/DloR0BOGNU0"
Write-Log " "
Read-Host "Press enter to continue."
Write-Log " "
Write-Log " "
Write-Log " "

Write-Log "I think that'll get you to 90% of the Git commands you'll ever use" -Type Info
Write-Log "in your lifetime especially if you use an IDE like VSCode. The other" -Type Info
Write-Log "Git commands are more situational" -Type Info
Write-Log " "
Write-Log "If you're curious about other commands, here's one of them." -Type Info
Write-Log " "
Write-Log "git stash"
Write-Log " "
Write-Log "I think that's all you need to know about Git. Happy programming!" -Type Info
