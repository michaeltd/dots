# ~/.bashrc.d/colors.sh
#
# colors for general use

# Font attributes
export reset="$(tput sgr0)" bold="$(tput bold)" dim="$(tput dim)" blink="$(tput blink)" underline="$(tput smul)" end_underline="$(tput rmul)" reverse="$(tput rev)" hidden="$(tput invis)"

# Font colors
export black="$(tput setaf 0)" red="$(tput setaf 1)" green="$(tput setaf 2)" yellow="$(tput setaf 3)" blue="$(tput setaf 4)" magenta="$(tput setaf 5)" cyan="$(tput setaf 6)" white="$(tput setaf 7)" default="$(tput setaf 9)"

# Font background colors
export bg_black="$(tput setab 0)" bg_red="$(tput setab 1)" bg_green="$(tput setab 2)" bg_yellow="$(tput setab 3)" bg_blue="$(tput setab 4)" bg_magenta="$(tput setab 5)" bg_cyan="$(tput setab 6)" bg_white="$(tput setab 7)" bg_default="$(tput setab 9)"

#	Colors:
export LIGHT_BLACK='\e[1;30m' LIGHT_RED='\e[1;31m' LIGHT_GREEN='\e[1;32m' LIGHT_YELLOW='\e[1;33m' LIGHT_BLUE='\e[1;34m' LIGHT_MAGENT='\e[1;35m' LIGHT_CYAN='\e[1;36m' LIGHT_WHITE='\e[1;37m'

export DARK_BLACK='\e[0;30m' DARK_RED='\e[0;31m' DARK_GREEN='\e[0;32m' DARK_YELLOW='\e[0;33m' DARK_BLUE='\e[0;34m' DARK_MAGENT='\e[0;35m' DARK_CYAN='\e[0;36m' DARK_WHITE='\e[0;37m'
