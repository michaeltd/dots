# ~/.bashrc.d/games.sh
#
# games
#shellcheck shell=bash

rps() {
  # Rock Paper Scissors mt 20170525
  declare -a op=("${red}Rock${reset}" "${green}Paper${reset}" "${blue}Scissors${reset}")
  declare -a oc=("${green}WIN${reset}" "${red}Defeat${reset}" "${yellow}Draw${reset}")
  declare -A rs[0,0]=${oc[2]} rs[0,1]=${oc[1]} rs[0,2]=${oc[0]} \
             rs[1,0]=${oc[0]} rs[1,1]=${oc[2]} rs[1,2]=${oc[1]} \
             rs[2,0]=${oc[1]} rs[2,1]=${oc[0]} rs[2,2]=${oc[2]}

  declare cs=0 us=0 ns=0 rd=0

  #shellcheck disable=SC2154
  printf "${bold}Hello!${reset} Welcome to %s %s %s Game!\n" "${op[0]}" "${op[1]}" "${op[2]}"

  while :
  do

    read -rep "${op[0]}:1, ${op[1]}:2, ${op[2]}:3, Quit:0. What's your pick?: " ui

    case "${ui}" in
      0)
        if (( us > cs )); then
          bbmsg="${oc[0]}"
        elif (( us < cs )); then
          bbmsg="got ${oc[1]}ed by"
        elif (( us == cs )); then
          bbmsg="${oc[2]}ed with"
        fi

        printf "After %d rounds, you %s the CPU with %d:%d points and %d ties.\n" "${rd}" "${bbmsg}" "${us}" "${cs}" "${ns}"

        return 0 ;;

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
  # [ $[ $RANDOM % 6 ] == 0 ] && echo "BOOM!!!" || echo "LUCKY GUY!!!"

  RV=$(( RANDOM % 6 ));

  if [[ $RV == 0 ]]; then
    printf "${red}BOOM!!!${reset} ${bold}You've rolled a %s${reset}\n" "${RV}"
  else
    printf "${blue}LUCKY GUY!!!${reset} ${bold}You've rolled a %s${reset}\n" "${RV}"
  fi

  if [[ "$(read -rp "Again? [Y/n]: " r;echo "${r:-y}")" == "y" ]]; then
    russian_rulette
  fi
}
