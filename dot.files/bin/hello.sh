#!/bin/bash
#
# https://www.reddit.com/r/unixporn/comments/amurfb/tmux_working_on_making_a_pocket_vim_machine/

#shellcheck disable=SC2154
echo -ne "${green}Hello${reset} ${bold}${USER}${reset}, today is ${cyan}$(date '+%A, %B %d')${reset}\n"

curl "https://wttr.in?0"
