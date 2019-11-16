#!/bin/bash
#
# https://www.reddit.com/r/unixporn/comments/amurfb/tmux_working_on_making_a_pocket_vim_machine/

printf "${green}Hello ${bold}%s${reset}, today is ${bold}%s${reset}\n" "${USER}" "$(date '+%A, %B %d')"

curl https://wttr.in?0
