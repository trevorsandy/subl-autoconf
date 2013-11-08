#!/usr/bin/env bash

save=$(pwd)

if [ "$OS" == 'Linux' ]; then
  cd "$HOME/.config/sublime-text-3"
else
  cd "$HOME/Library/Application Support/Sublime Text 3"
fi

hg clone https://bitbucket.org/efolio/sublime-text-3-config Packages
cd Packages

echo '*** Install plugin: "Theme - Nexus"'
git clone https://github.com/EleazarCrusader/nexus-theme.git "Theme - Nexus"

cd $save
echo '*** Install complete :)'
