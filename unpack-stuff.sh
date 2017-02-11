#!/bin/bash
# script to give one comand to extract any kind of file

if [ -f "$1" ] ; then
  case "$1" in
    *.7z.7za) 7z "$1" ;;
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.tar.Z) tar xzf "$1" ;;
    *.tar.z) tar xzf "$1" ;;
    *.tar.xz) tar Jxf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.jar) unzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *) echo "'$1' cannot be extracted." ;;
  esac
else
  echo "'$1' is not a file."
fi
