#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#
# dots/setup_termux_on_android.bash 
# Migrates my .dots in android.

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#shellcheck disable=SC2155
declare -r sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

cd "${sdn}" || exit 1

pkg install git build-essential ncurses-utills vim emacs tmux htop mc cowsay fortune neofetch

git clone https://GitHub.com/michaeltd/dots/ ~/.dots

git clone https://GitHub.com/michaeltd/.emacs.d ~/.emacs.d

git clone https://GitHub.com/michaeltd/lolcat ~/lolcat

