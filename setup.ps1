#/////////////////////#
# !/!             !/! #
# !/! SCROLL DOWN !/! #
# !/!             !/! #
#/////////////////////#
function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $Output,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Warn", "Error", "Log")]
        [String]
        $Type = "Log"
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

    Write-Output " $($Output)"
}

function Test-Command($Command) {
    $Result = [bool](Get-Command -Name $Command -ErrorAction Ignore)
    return $Result -eq $false
}

#////////////////////#
# !/!            !/! #
# !/! START HERE !/! #
# !/!            !/! #
#////////////////////#

#? Reference
#?
#? $home = C:/Users/myname
#?
#? Test-Command verifies is something is properly installed or not.

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
    Write-Log "To change the install location, run this." -Type Info
    Write-Log '$env:SCOOP="C:/path/to/my/folder"'
    return
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
    Write-Log "uv successfully setup." -Type Info

    Write-Log "This project uses a bunch of addons" -Type Info
    uv run tooling sync

    Write-Log " "
    Write-Log "We use addons as to not code things from scratch" -Type Info
    Write-Log "https://godotengine.org/asset-library/asset"
    Write-Log " "
}


while ($true) {
    $registered = (Read-Host "Have you created a GitHub account yet? [y/n]").ToLower()
    
    if ($registered -eq "y") {
        $authenticated = (Read-Host "Have you authenticated Git with your Github account? [y/n]").ToLower()

        if ($authenticated -eq "y") { break }

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

Write-Log " "
Write-Log "Assuming everything went right, the required tooling should have been installed." -Type Info
Write-Log "If you haven't installed Godot with C# support (.NET), please install it now." -Type Info
Write-Log " "
Write-Log " "
Write-Log "Here's some of the important Git commands." -Type Info
Write-Log " "
Write-Log "IF you're in an empty folder, you can grab a copy of the codebase via the following" -Type Info
Write-Log "git clone https://github.com/gekkotadev/codename-vista.git ."
Write-Log " "
Write-Log "If you downloaded this via zip file, you can turn this into a Git repository via the following" -Type Info
Write-Log 'cd "path/to/the/project"'
Write-Log 'if (Test-Path project.godot) { echo "Youre in the project folder ✅" }'
Write-Log "git init -b main"
Write-Log "git remote add origin https://github.com/gekkotadev/codename-vista.git"
Write-Log "git fetch"
Write-Log "git reset origin/main"
Write-Log "git checkout -t origin/main"
Write-Log " "
Write-Log "Much like a logbook, to record changes you've made to the codebase run this command" -Type Info
Write-Log "git add ."
Write-Log " "
Write-Log "To record only specific files and not all changes made, run this instead" -Type Info
Write-Log "git add path/to/file.txt"
Write-Log " "
Write-Log "But of course you need a description of your changes" -Type Info
Write-Log 'git commit -m "Created blog post."'
Write-Log " "
Write-Log 'And finally, lets send it off to the "central repository" so to speak -- the main copy we have on the server.' -Type Info
Write-Log "git push origin main"
Write-Log " "
Write-Log 'Now why do we want to push our changes to the so called "central repository"?' -Type Info
Write-Log "So everyone can get an updated copy of the code and even run some automated tests and stuff" -Type Info
Write-Log " "
Write-Log "But if you're afraid of your changes breaking something else, we can always create a pull request" -Type Info
Write-Log "https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests"
Write-Log " "
Write-Log "If you got an experiment you want to try, try branches" -Type Info
Write-Log "https://rogerdudler.github.io/git-guide/#branching"
Write-Log "https://stackoverflow.com/a/40308297"
