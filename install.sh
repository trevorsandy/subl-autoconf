#!/bin/bash -e
# Trevor SANDY July 04 2017

# a little help...
if [ "$1" = -h ] || [ "$1" = --help ]; then
  echo
  echo "This is a great and clean Sublime Text configuration that will automatically"
  echo "install the following packages, aside Package Control:"
  echo
  echo "- AdvancedNewFile              - Jade                - SublimeLinter"
  echo "- Auto Semi-Colon              - Markdown Preview    - SublimeLinter-contrib-standard"
  echo "- AutoFileName                 - MarkdownEditing     - SublimeLinter-jshint"
  echo "- Babel                        - Monokai Extended    - SyncedSideBar"
  echo "- Babel Snippets               - Package Control     - Terminal"
  echo "- Better CoffeeScript          - Pretty JSON         - tern_for_sublime (Requres npm)"
  echo "- BracketHighlighter           - Pretty YAML         - Theme - Nexus"
  echo "- Color Highlighter            - Sass                - ToggleQuotes"
  echo "- DocBlockr                    - SCSS                - TrailingSpaces"
  echo "- Dotfiles Syntax Highlighting - SideBarEnhancements - Unicode Character Highlighter"
  echo "- Emmet                        - Smart Duplicate     - WordHighlight"
  echo "- INI                          - Stylus"
  echo
  echo "This configuration uses the Nexus Theme, the standardJS code style and the tern JavaScript code-analysis engine."
  echo
  echo "This script will try to install the following npm package if npm is available (sudo password required on Linux):"
  echo
  echo "- standard --fix"
  echo
  echo "It will also install tern and auto-configure it!"
  echo
  echo "If an abnormal end is encountered, the script will attempt to reverse already installed components."
  echo
  echo "Prerequisites:"
  echo
  echo "- Git                https://git-scm.com"
  echo "- Node.js/npm        https://nodejs.org (optional)"
  echo "- Sublime Text 2/3   https://www.sublimetext.com/3"
  echo "- wget/curl          https://www.gnu.org/software/wget https://curl.haxx.se"
  echo
  echo "Install:"
  echo
  echo "You can execute $0 as is or with argument 2 (Sublime Text 2) or 3 (Sublime Text 3)."
  echo "If no argument is specified, Sublime Text 3 is expected by default."
  echo
  echo "Example commands:"
  echo "- for Sublime Text 3: $ $0"
  echo "- for Sublime Text 2: $ $0 2"
  echo
  echo "After installation, completely close and relaunch (2x) Sublime Text to finish automatic configuration."
  echo "You can view the configuration stats in the console accessible at the bottom left application window."
  echo
  exit 0
fi

# set some useful vars
osDist=`uname`
launchDir=`pwd`
sublVersion="$1"
if [ -f /etc/lsb-release ]; then
  . /etc/lsb-release
  osName=$DISTRIB_ID
elif [ -f /etc/arch_version ]; then
  osName=Arch
elif [ -f /etc/redhat-release ]; then
  osName=RedHat
elif [ -f /etc/SuSE-release ]; then
  osName=SuSE
else
  osName=$(uname -s)
fi
# if no Sublime Text version specified, use ver 3
if [ -z "$sublVersion" ]; then
  sublVersion="3"
fi

# let's start...
echo ">>>> Processing updates for Sublime Text $sublVersion... <<<<"

# which OS ? So we can set proper install directory
if [ "$osDist" = Linux ]; then
  sublDir="$HOME/.config/sublime-text-$sublVersion"
elif [ "$osDist" = FreeBSD ]; then
  sublDir="$HOME/.config/sublime-text-$sublVersion"
elif [ "$osDist" = Darwin  ]; then
  sublDir="$HOME/Library/Application Support/Sublime Text $sublVersion"
else
  echo "- CRITICAL: Unknown OS."
  echo "- The script will terminate."
  exit 1
fi

# I'd like a steaming hot order of curl or wget please.
echo "- Checking for curl or wget..."
if [ -f /usr/bin/curl ]; then
  echo "- curl found."
elif [ -f /usr/bin/wget ]; then
  echo "- wget found."
else
  echo "- CRITICAL: curl not found, wget not found."
  echo "- The script will terminate."
  exit 1
fi

# do we have Git ? We'll need this to download the control package
echo "- Checking for Git..."
if [ -f /usr/bin/git ]; then
  echo "- Git found."
else
  echo "- NOTICE: Git not found."
  # it's not the end of the World if we have a User directory, if not, it is.
  if [ -d "$launchDir/User" ]; then
    echo "           Enter 'n' to exit or any key to continue."
    read -n 1 -p "           Would you like to continue ? : " input
    echo
    if [ "$input" = "n" ] || [ "$input" = "N" ]; then
      echo "- You exited the script."
      exit 0
    fi
  else
    echo "- CRITICAL: No way to clone User packages repo."
    echo "- The script will terminate."
    exit 1
  fi
fi

# and what about npm ?
echo "- Checking for npm..."
if [ -f /usr/bin/npm ] || [ -f /usr/local/bin/npm ]; then
  echo "- npm found."
else
  # we'll need this for the extra package dependencies but we'll survive if we don't have it
  echo "- NOTICE: 'npm' not found."
  echo "           Enter 'n' to exit or any key to continue."
  read -n 1 -p "           Would you like to continue ? : " input
  echo
  if [ "$input" = "n" ] || [ "$input" = "N" ]; then
    echo "- You exited the script."
    exit 1
  fi
fi

# is Sublime Text installed ?
if [ -d "$sublDir" ]; then
  cd "$sublDir"
else
  echo "- CRITICAL: Could not find Sublime Text $sublVersion directory $sublDir."
  echo "- The script will terminate."
  exit 1
fi

# I don't like deleting stuff so let's increment the backup package directory name
# for the hokey paths with dots (Linux), we'll use a symlink
if [ "$osName" != Darwin ]; then
	echo "- Using symbolic link 'symLink' for $sublDir."
	ln -sf "$sublDir" symLink
	f="symLink/Packages"
else
	f="$sublDir/Packages"
fi
ext=".bck"
if [[ -e "$f$ext" ]] ; then
    i=1
    f="${f%.*}";
    while [[ -e "${f}_${i}${ext}" ]]; do
        let i++
    done
    f="${f}_${i}${ext}"
else
   f="${f}${ext}"
fi
packagesBak="$f"

# backup Packages directory
echo "- Replace Packages/User directory..."
if [ -d Packages ]; then
  echo "- Backup existing Package directory to $packagesBak..."
  mv "$sublDir/Packages" "$packagesBak"
	# cleanup our mess
	if [ "$osName" != Darwin ]; then
		rm -f symLink
	fi
fi
# we need a new Packages directory
mkdir Packages

# let's check if we have the replacement User directory for the Packages directory
# if we don't have it, download from git repo...
if [ -d "$launchDir/User" ]; then
  cp -r "$launchDir/User" ./Packages
else
  echo "- Folder $launchDir/User not found - downloading it..."
  cd "$launchDir"
	rm -rf subl-autoconf
  git clone https://github.com/nicolas-goudry/subl-autoconf.git
  cd "$sublDir"
  cp -r "$launchDir/subl-autoconf/User" ./Packages
fi

# do we need to create an Installed Packages directory ?
if [ ! -d "Installed Packages" ]; then
  mkdir "Installed Packages"
fi

# do we need to install the Package Control package ?
PACKAGE_CTRL_DEST="Installed Packages/Package Control.sublime-package"
if [ ! -f "$PACKAGE_CTRL_DEST" ]; then
  echo "- Installing package control..."
  PACKAGE_CTRL_URL="http://packagecontrol.io/Package Control.sublime-package"
  if hash curl 2>/dev/null; then
    curl --silent "$PACKAGE_CTRL_URL" -o "$PACKAGE_CTRL_DEST"
  else
    wget "$PACKAGE_CTRL_URL" -O "$PACKAGE_CTRL_DEST"
  fi
else
  echo "- Package '$PACKAGE_CTRL_DEST' exists - download skipped."
fi

# is npm installed ?
if hash npm 2>/dev/null; then
  npmStd=
  npmStdFmt=
  echo "- NOTICE: 'npm' is available. You can install additional dependent packages for the packages just installed."
  echo "           Enter n to decline or any key to continue."
  read -n 1 -p "           Install additional dependent packages? : " input
  echo

  # we have more goodies, do yo want to continue ?
  if [ ! "$input" = "n" ] && [ ! "$input" = "N" ]; then
    echo "- npm is installing dependent packages. This can take some time..."

    # check if npm dependencies are already installed ? Install if not.
    echo "- Checking status of package standard --fix..."
		npmStd=`npm list -g standard | sed -n '2p' | cut -d' ' -f 2`
    if [ "$npmStd" = "(empty)" ]; then
      if [ "$osName" = Darwin ]; then
        npm i -g standard --fix
      else
        # we'll need root-level access for this on Linux - using sudo
        echo  "Install standard --fix requires root-level access:"
        sudo npm i -g standard --fix
      fi
      echo "- Package standard --fix installed."
    else
      echo "- Package standard --fix already installed globally."
    fi

    # setup the Tern stuff
    echo "- Configure tern_for_sublime package..."
    cd Packages
    if [ ! -d tern_bin ]; then
      mkdir tern_bin
    fi
    cd tern_bin
		echo "- Download package.json..."
    TERN_JSON_URL="https://raw.githubusercontent.com/ternjs/tern_for_sublime/master/package.json"
    TERN_JSON_DEST="package.json"
    if hash curl 2>/dev/null; then
      curl --silent "$TERN_JSON_URL" -o "$TERN_JSON_DEST"
    else
      wget "$TERN_JSON_URL" -O "$TERN_JSON_DEST"
    fi
    echo "- 1. Install Tern dependencies..."
    npm i

    # ok, let's be sure Tern stuff was setup ok before continuing...
    cd ../
    if [ -f tern_bin/node_modules/tern/bin/tern ]; then
        echo "- 2. Configure tern_for_sublime..."

        # create the Tern configuration file
        ternPath="$sublDir/Packages/tern_bin/node_modules/tern/bin/tern"
        cat <<pEOF > "$sublDir/Packages/User/Tern.sublime-settings"
{
  "tern_argument_hints": true,
  "tern_output_style": "tooltip",
  "tern_argument_completion": true,
  "tern_command": [
    "node",
    "$ternPath",
    "--no-port-file"
  ]
}
pEOF
			echo "- Created $sublDir/User/Tern.sublime-settings."
    else
      # looks like we had some problem to setup Tern stuff - let's cleanup and terminate
      echo "- WARNING: Tern dependencies install failed - removing partial content..."

			#temp start ****************************************
			read -n1 -r -p "Press space key to continue..." sKey
			#temp end

      rm -rf tern_bin

      # only remove npm dependent packages if we installed them.
      echo "- Checking npm additional dependencies..."
      if [ "$npmStd" = "(empty)" ]; then
        if [ "$osName" = Darwin ]; then
          npm -g uninstall standard --save
        else
          # we'll need root-level access for this on Linux - using sudo
          echo  "Uninstall standard --fix requires root-level access:"
          sudo npm -g uninstall standard --save
        fi
        echo "- npm package standard uninstalled."
      fi

      echo "- Done."
    fi
  else
    # your loss Boss!
    echo "- NOTICE: You declined to install extra packages."
    echo "          This means the dependent packages for some installed Sublime Text packages will not be installed."
  fi
else
  echo "- NOTICE: I have to inform your that npm (node.js) was not found!"
  echo "          This means the dependent packages for some installed Sublime Text packages will not be installed."
  if [ "$osDist" = Darwin ]; then
    echo "          To make this right, install Node.js 'brew install Node'"
  elif [ "$osName" = Ubuntu ] || [ "$osName" = Debian ]; then
    echo "          To make this right, install Node.js 'sudo apt-get install -y nodejs'; 'sudo apt-get install npm'"
  elif [ "$osName" = Arch ]; then
    echo "          To make this right, install Node.js 'sudo pacman -S nodejs npm'"
  elif [ "$osName" = RedHat ]; then
    echo "          To make this right, install Node.js 'sudo yum install nodejs npm'"
  fi
  echo "          and relaunch $0"
fi

# all done - Cheers!
echo ">>>> Install complete, glad to be of help :) <<<<"
