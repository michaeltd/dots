#!/usr/bin/env /bin/bash
# Script to unify archive extraction in linux CLI environments
# inflateThat.sh tsouchlarakis@gmail.com 2015/12/09

if [[ ! -x $(which 7z) || ! -x $(which tar) || ! -x $(which bunzip2) || ! -x $(which unrar) || ! -x $(which gunzip) || ! -x $(which unzip) || ! -x $(which uncompress) ]]; then
  printf "## %s uses the following commands/utilities:\n## 7z, tar, bunzip2, unrar, gunzip, unzip, uncompress.\n## Install them all for full functionality\n" "${0}"
fi # Warn for missing decompressors.

if [[ ! -z "${1}" && -f "${1}" && -r "${1}" ]] ; then # Check for arguments and validity.
  case "${1,,}" in # Compare lowercased filename for known extensions.
    *.7z | *.7za) 7z x "${1}" ;;
    *.tar) tar -xf "${1}" ;;
    *.tar.gz | *.tar.z | *.tgz) tar -xzf "${1}" ;;
    *.tar.bz2 | *.tbz2) tar -xjf "${1}" ;;
    *.tar.xz) tar -Jxf "${1}" ;;
    *.bz2) bunzip2 "${1}" ;;
    *.rar) unrar x "${1}" ;;
    *.gz) gunzip "${1}" ;;
    *.zip | *.jar) unzip "${1}" ;;
    *.z) uncompress "${1}" ;;
    *) # Exit on unknown extensions.
      printf "%s cannot be extracted.\n" "${1}"
      exit 1 ;;
  esac
else # Show error.
  printf "## Need one compressed file as parameter\n## %s is not a readable file.\n" "${1}"
  exit 1
fi
