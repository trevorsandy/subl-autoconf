#!/usr/bin/env bash

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
fi

if [[ $# == 0 ]]; then
  $1='3'
fi

if [[ $platform == 'linux' ]]; then
  dir="$HOME/.config/sublime-text-$1"
elif [[ $platform == 'freebsd' ]]; then
  dir="$HOME/.config/sublime-text-$1"
elif [[ $OSTYPE == darwin* ]]; then
  dir="$HOME/Library/Application Support/Sublime Text $1"
else
  echo 'Unknown OS'
  exit 1
fi

mkdir -p $dir 2>/dev/null
cd $dir

if [ -r Packages ]; then
  mv Packages Packages~
fi

hg clone https://bitbucket.org/efolio/sublime-text-3-config Packages

echo '*** Install complete :)'
