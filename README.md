# Sublime text 2/3 configuration

This is a great and clean Sublime Text configuration that will automatically install the following packages, aside Package Control:

* [AdvancedNewFile](https://packagecontrol.io/packages/AdvancedNewFile)
* [Auto Semi-Colon](https://packagecontrol.io/packages/Auto%20Semi-Colon)
* [AutoFileName](https://packagecontrol.io/packages/AutoFileName)
* [Babel](https://packagecontrol.io/packages/Babel)
* [Babel Snippets](https://packagecontrol.io/packages/Babel%20Snippets)
* [Better CoffeeScript](https://packagecontrol.io/packages/Better%20CoffeeScript)
* [BracketHighlighter](https://packagecontrol.io/packages/BracketHighlighter)
* [Color Highlighter](https://packagecontrol.io/packages/Color%20Highlighter)
* [DocBlockr](https://packagecontrol.io/packages/DocBlockr)
* [Dotfiles Syntax Highlighting](https://packagecontrol.io/packages/Dotfiles%20Syntax%20Highlighting)
* [Emmet](https://packagecontrol.io/packages/Emmet)
* [INI](https://packagecontrol.io/packages/INI)
* [Jade](https://packagecontrol.io/packages/Jade)
* [Markdown Preview](https://packagecontrol.io/packages/Markdown%20Preview)
* [MarkdownEditing](https://packagecontrol.io/packages/MarkdownEditing)
* [Monokai Extended](https://packagecontrol.io/packages/Monokai%20Extended)
* [Package Control](https://packagecontrol.io/packages/Package%20Control)
* [Pretty JSON](https://packagecontrol.io/packages/Pretty%20JSON)
* [Pretty YAML](https://packagecontrol.io/packages/Pretty%20YAML)
* [Sass](https://packagecontrol.io/packages/Sass)
* [SCSS](https://packagecontrol.io/packages/SCSS)
* [SideBarEnhancements](https://packagecontrol.io/packages/SideBarEnhancements)
* [Smart Duplicate](https://packagecontrol.io/packages/Smart%20Duplicate)
* [Stylus](https://packagecontrol.io/packages/Stylus)
* [SublimeLinter](https://packagecontrol.io/packages/SublimeLinter)
* [SublimeLinter-contrib-standard](https://packagecontrol.io/packages/SublimeLinter-contrib-standard)
* [SublimeLinter-jshint](https://packagecontrol.io/packages/SublimeLinter-jshint)
* [SyncedSideBar](https://packagecontrol.io/packages/SyncedSideBar)
* [Terminal](https://packagecontrol.io/packages/Terminal)
* [tern_for_sublime](https://packagecontrol.io/packages/tern_for_sublime)
* [Theme - Nexus](https://packagecontrol.io/packages/Theme%20-%20Nexus)
* [ToggleQuotes](https://packagecontrol.io/packages/ToggleQuotes)
* [TrailingSpaces](https://packagecontrol.io/packages/TrailingSpaces)
* [Unicode Character Highlighter](https://packagecontrol.io/packages/Unicode%20Character%20Highlighter)
* [WordHighlight](https://packagecontrol.io/packages/WordHighlight)

This configuration uses the [Nexus Theme](https://github.com/EleazarCrusader/nexus-theme), the [standardJS](http://standardjs.com/index.html) code style and the [tern](http://ternjs.net/) JavaScript code-analysis engine.

The install script will try to install the following npm package if it can find the `npm` command:

* `standard --fix`

It will also install tern and auto-configure it!

## Prerequisites

You need:

* Git                   https://git-scm.com
* Node.js/npm           https://nodejs.org - optional
* Sublime Text 2/3 :)   https://www.sublimetext.com/3
* wget/curl             https://www.gnu.org/software/wget https://curl.haxx.se

## Install

### Linux / MacOS

You can install this via the command line with either `curl` or `wget`.

#### via `curl`:

`curl -L "https://raw.githubusercontent.com/nicolas-goudry/subl-autoconf/master/install.sh" | bash -s 3`

#### via `wget`:

`wget --no-check-certificate "https://raw.githubusercontent.com/nicolas-goudry/subl-autoconf/master/install.sh" -O - | bash -s 3`

You can replace the `bash -s 3` by `bash -s 2` in the install command if you are using Sublime Text 2 and not Sublime Text 3 ;)

If running from a cloned repository simply run:

For Sublime Text 3 `./install.sh`
For Sublime Text 2 `./install.sh 2`

### Windows

Clone this repository anywhere, then simply launch `install.vbs` by double-click or from command line with `cscript install.vbs`.

If you're using command-line, you can add a parameter matching Sublime Text version you are targeting, by default it will target version 3.

### Post Install

After installation, completely close and relaunch (2x) Sublime Text to finish automatic configuration.

You can view the configuration status in the console accessible at the bottom left application window.




