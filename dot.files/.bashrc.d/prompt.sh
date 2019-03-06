# ~/.bashrc.d/prompt.sh
#
# https://gitlab.com/jallbrit/dotfiles/
# depending on privileges and terminal, use a colored prompt

if (( EUID != 0 )); then
    case "$TERM" in
        xterm-color|*-256color|rxvt-unicode)

	          # fancy, two-liner with bars
	          #PS1='\e[0;35m┌────[\[\033[1;32m\]\u@\h\e[0;35m]──────────────────────────[\t\e[0;35m]────┐ \n└───>[\w\e[0;36m] \$ \[\033[00m\]'

            # simple  PS1 using tput
	          PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]";;
        *)
            PS1='[\u@\h:\w]\$ ';;
    esac
fi
