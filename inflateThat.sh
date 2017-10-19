#!/usr/bin/env bash
# Script to unify archive extraction in linux CLI environments
# inflateThat.sh tsouchlarakis@gmail.com 2015/12/09

if [[ -x $(which 7z) && -x $(which tar) && -x $(which bunzip2) && -x $(which unrar) && -x $(which gunzip) && -x $(which unzip) && -x $(which uncompress) ]]; then
  printf "OK\n"
else
  printf "This script uses 7z, tar, bunzip2, unrar, gunzip, unzip and uncompress commands.\nInstall them for full functionality\n"
fi

if [[ -z "${1}" ]] ; then
  printf "Need one compressed file as parameter\n"
  exit 1
elif [[ -f "${1}" && -r "${1}" ]] ; then
  case "${1,,}" in
    *.7z.7za) 7z "${1}" ;;
    *.tar.bz2) tar -xjf "${1}" ;;
    *.tar.gz) tar -xzf "${1}" ;;
    *.tar.z) tar -xzf "${1}" ;;
    *.tar.xz) tar -Jxf "${1}" ;;
    *.bz2) bunzip2 "${1}" ;;
    *.rar) unrar x "${1}" ;;
    *.gz) gunzip "${1}" ;;
    *.jar) unzip "${1}" ;;
    *.tar) tar -xf "${1}" ;;
    *.tbz2) tar -xjf "${1}" ;;
    *.tgz) tar -xzf "${1}" ;;
    *.zip) unzip "${1}" ;;
    *.z) uncompress "${1}" ;;
    *)
      printf "%s cannot be extracted.\n" "${1}"
      exit 1
      ;;
  esac
else
  printf "%s is not a readable file.\n" "${1}"
  exit 1
fi
