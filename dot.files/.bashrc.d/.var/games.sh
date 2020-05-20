# ~/.bashrc.d/.var/games.sh
#
# games
#shellcheck shell=bash

rps() {
    # Font attributes     # Font colors     # Font background colors
    local reset="$(tput sgr0)" bold="$(tput bold)" dim="$(tput dim)" blink="$(tput blink)" underline="$(tput smul)" end_underline="$(tput rmul)" reverse="$(tput rev)" hidden="$(tput invis)" \
	  black="$(tput setaf 0)" red="$(tput setaf 1)" green="$(tput setaf 2)" yellow="$(tput setaf 3)" blue="$(tput setaf 4)" magenta="$(tput setaf 5)" cyan="$(tput setaf 6)" white="$(tput setaf 7)" default="$(tput setaf 9)" \
	  bg_black="$(tput setab 0)" bg_red="$(tput setab 1)" bg_green="$(tput setab 2)" bg_yellow="$(tput setab 3)" bg_blue="$(tput setab 4)" bg_magenta="$(tput setab 5)" bg_cyan="$(tput setab 6)" bg_white="$(tput setab 7)" bg_default="$(tput setab 9)"

    # Rock Paper Scissors mt 20170525
    local -ra op=( "${red}Rock${reset}" "${green}Paper${reset}" "${blue}Scissors${reset}" )
    local -ra oc=( "${green}WIN${reset}" "${red}Defeat${reset}" "${yellow}Draw${reset}" )
    local -rA rs=( [0,0]=${oc[2]} [0,1]=${oc[1]} [0,2]=${oc[0]} [1,0]=${oc[0]} [1,1]=${oc[2]} [1,2]=${oc[1]} [2,0]=${oc[1]} [2,1]=${oc[0]} [2,2]=${oc[2]} )
    local cs=0 us=0 ns=0 rd=0

    #shellcheck disable=SC2154
    printf "${bold}Hello!${reset} Welcome to %s %s %s Game!\n" "${op[0]}" "${op[1]}" "${op[2]}"

    while :; do
	read -rep "${op[0]}:1, ${op[1]}:2, ${op[2]}:3, Quit:0. What's your pick?: " ui
	case "${ui}" in
	    0)
		(( us > cs )) && bbmsg="${oc[0]}"
		(( us < cs )) && bbmsg="got ${oc[1]}ed by"
		(( us == cs )) && bbmsg="${oc[2]}ed with"

		printf "After %d rounds, you %s the CPU with %d:%d points and %d ties.\n" "${rd}" "${bbmsg}" "${us}" "${cs}" "${ns}"
		return;;
	    [1-3])
		(( rd++, ui-- ))
		ci="$(shuf -i 0-2 -n 1)"

		printf "Round : %d is a %s. You selected %s, while the CPU rolled %s\n" "${rd}" "${rs[${ui},${ci}]}"  "${op[${ui}]}" "${op[${ci}]}"

		case "${rs[${ui},${ci}]}" in
		    "${oc[0]}") (( us++ ));;
		    "${oc[1]}") (( cs++ ));;
		    "${oc[2]}") (( ns++ ));;
		esac
		printf "Player : %d, CPU : %d, Ties : %d\n" "${us}" "${cs}" "${ns}";;
	    *)
		printf "${red}Error${reset}: You chose ${red}%s${reset}. Choose again from 0 to 3\n" "${ui}" ;;
	esac
    done
}

russian_rulette() {
    # https://www.facebook.com/freecodecamp/photos/a.1535523900014339.1073741828.1378350049065059/2006986062868118/?type=3&theater
    # [ $[ $RANDOM % 6 ] == 0 ] && echo "BOOM!!!" || echo "click..."

    # Font attributes     # Font colors     # Font background colors
    local reset="$(tput sgr0)" bold="$(tput bold)" dim="$(tput dim)" blink="$(tput blink)" underline="$(tput smul)" end_underline="$(tput rmul)" reverse="$(tput rev)" hidden="$(tput invis)" \
	  black="$(tput setaf 0)" red="$(tput setaf 1)" green="$(tput setaf 2)" yellow="$(tput setaf 3)" blue="$(tput setaf 4)" magenta="$(tput setaf 5)" cyan="$(tput setaf 6)" white="$(tput setaf 7)" default="$(tput setaf 9)" \
	  bg_black="$(tput setab 0)" bg_red="$(tput setab 1)" bg_green="$(tput setab 2)" bg_yellow="$(tput setab 3)" bg_blue="$(tput setab 4)" bg_magenta="$(tput setab 5)" bg_cyan="$(tput setab 6)" bg_white="$(tput setab 7)" bg_default="$(tput setab 9)"

    RV=$(( RANDOM % 6 )); (( RV == 0 )) && \
	printf "${red}BOOM!!! [x.x]${reset} ${bold}You've rolled a ${reset}${red}%s${reset}\n" "${RV}" || \
	    printf "${green}click... [+.-]${reset} ${bold}You've rolled a ${reset}${green}%s${reset}\n" "${RV}"

    [[ "$(read -rp "Again? [Y/n]: " r;echo "${r:-y}")" =~ ^[Yy] ]] && russian_rulette
}
