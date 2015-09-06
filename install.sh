#!/usr/bin/env bash

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
fi

sublVersion="$1"
if [ -z "$sublVersion" ]; then
  sublVersion='3'
fi

if [[ $platform == 'linux' ]]; then
  dir="$HOME/.config/sublime-text-$sublVersion"
elif [[ $platform == 'freebsd' ]]; then
  dir="$HOME/.config/sublime-text-$sublVersion"
elif [[ $OSTYPE == darwin* ]]; then
  dir="$HOME/Library/Application Support/Sublime Text $sublVersion"
else
  echo 'Unknown OS'
  exit 1
fi

mkdir -p $dir 2>/dev/null
cd $dir

if [ -d Packages ]; then
  rm -Rf Packages.bck
  mv Packages Packages.bck
fi

hg clone https://bitbucket.org/efolio/sublime-text-3-config Packages

PACKAGE_CTRL_DEST='Installed Packages/Package Control.sublime-package'
if [ ! -f "$PACKAGE_CTRL_DEST" ]; then
  echo "Installing package control…"
  mkdir "Installed Packages"
  PACKAGE_CTRL_URL='http://packagecontrol.io/Package Control.sublime-package'
  if hash curl 2>/dev/null; then
    curl "$PACKAGE_CTRL_URL" > "$PACKAGE_CTRL_DEST"
  else
    wget "$PACKAGE_CTRL_URL" -O "$PACKAGE_CTRL_DEST"
  fi
fi

echo '*** Install complete :)'
