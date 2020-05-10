#!/usr/bin/env bash
#
# https://tinyurl.com/create.php?source=create&url=https%3A%2F%2Fraw.githubusercontent.com%2Fmichaeltd%2Fdots%2Fmaster%2Fdot.files%2Fbin%2Fmichaeltd.bash&alias=mtd-card
# Write a nice business card on the terminal.
# ╭───────────────────────────────────────────────────────╮
# │                                                       │
# │           Michael Tsouchlarakis / michaeltd           │
# │                                                       │
# │        Work:  tsouchlarakis@gmail.com                 │
# │        FOSS:  Gentoo Linux avocado.                   │
# │                                                       │
# │     Twitter:  https://twitter.com/tsouchlarakismd     │
# │         npm:  https://npmjs.com/~michaeltd            │
# │      GitHub:  https://github.com/michaeltd            │ 
# │    LinkedIn:  https://linkedin.com/in/michaeltd       │
# │         Web:  https://michaeltd.netlify.com/          │
# │                                                       │
# │        Card:  curl -sL tinyurl.com/mtd-card|sh        │
# │                                                       │
# ╰───────────────────────────────────────────────────────╯
# Font attributes, colors, bg colors
declare -r reset="$(tput sgr0)" bold="$(tput bold)" dim="$(tput dim)" blink="$(tput blink)" underline="$(tput smul)" end_underline="$(tput rmul)" reverse="$(tput rev)" hidden="$(tput invis)" black="$(tput setaf 0)" red="$(tput setaf 1)" green="$(tput setaf 2)" yellow="$(tput setaf 3)" blue="$(tput setaf 4)" magenta="$(tput setaf 5)" cyan="$(tput setaf 6)" white="$(tput setaf 7)" default="$(tput setaf 9)" bg_black="$(tput setab 0)" bg_red="$(tput setab 1)" bg_green="$(tput setab 2)" bg_yellow="$(tput setab 3)" bg_blue="$(tput setab 4)" bg_magenta="$(tput setab 5)" bg_cyan="$(tput setab 6)" bg_white="$(tput setab 7)" bg_default="$(tput setab 9)"

l[0]="    ${green}╭───────────────────────────────────────────────────────╮"
l[1]="    ${green}│                                                       │"
l[2]="    ${green}│${reset}           ${bold}${blue}Michael Tsouchlarakis / michaeltd${reset}           ${green}│"
l[3]="    ${green}│                                                       │"
l[4]="    ${green}│${reset}        ${bold}Work:${reset}  tsouchlarakis@gmail.com                 ${green}│"
l[5]="    ${green}│${reset}        ${bold}FOSS:${reset}  Gentoo Linux avocado.                   ${green}│"
l[6]="    ${green}│                                                       │"
l[7]="    ${green}│${reset}     ${bold}Twitter:${reset}  ${dim}https://twitter.com/${reset}${magenta}tsouchlarakismd     ${green}│"
l[8]="    ${green}│${reset}         ${bold}npm:${reset}  ${dim}https://npmjs.com/${reset}~${red}michaeltd            ${green}│"
l[9]="    ${green}│${reset}      ${bold}GitHub:${reset}  ${dim}https://github.com/${reset}${green}michaeltd            ${green}│"
l[10]="    ${green}│${reset}    ${bold}LinkedIn:${reset}  ${dim}https://linkedin.com/in/${reset}${blue}michaeltd       ${green}│"
l[11]="    ${green}│${reset}         ${bold}Web:${reset}  ${dim}https://${yellow}michaeltd${reset}${dim}.netlify.com/${reset}          ${green}│"
l[12]="    ${green}│                                                       │"
l[13]="    ${green}│${reset}        ${bold}Card:${reset}  curl -sL tinyurl.com/mtd-card|sh        ${green}│"
l[14]="    ${green}│                                                       │"
l[15]="    ${green}╰───────────────────────────────────────────────────────╯"

echo
for i in "${!l[@]}"; do
    echo "${l[i]}"
done
echo
