# ~/.bashrc.d/games.sh
#
# games

function rps {
  # Rock Paper Scissors mt 20170525

  declare -a op=("${red}Rock${reset}" "${green}Paper${reset}" "${blue}Scissors${reset}") oc=("${green}WIN${reset}" "${red}Defeat${reset}" "${yellow}Draw${reset}")

  declare -A rs[0,0]=${oc[2]} rs[0,1]=${oc[1]} rs[0,2]=${oc[0]} \
             rs[1,0]=${oc[0]} rs[1,1]=${oc[2]} rs[1,2]=${oc[1]} \
             rs[2,0]=${oc[1]} rs[2,1]=${oc[0]} rs[2,2]=${oc[2]}

  declare cs=0 us=0 ns=0 rd=0

  printf "${bold}Hello!${reset} Welcome to %s %s %s Game!\n" "${op[0]}" "${op[1]}" "${op[2]}"

  while [ true ]; do

    read -e -p "${op[0]}:1, ${op[1]}:2, ${op[2]}:3, Quit:0. What's your pick?: " ui

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
        let "rd++"
        let "ui--"

        ci=$(shuf -i 0-2 -n 1)

        printf "Round : %d is a %s. You selected %s, while the CPU rolled %s\n" "${rd}" "${rs[${ui},${ci}]}"  "${op[${ui}]}" "${op[${ci}]}"

        case "${rs[${ui},${ci}]}" in
          "${oc[0]}") let "us++";;
          "${oc[1]}") let "cs++";;
          "${oc[2]}") let "ns++";;
        esac

        printf "Player : %d, CPU : %d, Ties : %d\n" "${us}" "${cs}" "${ns}";;

      *)
        printf "${red}Error${reset}: You chose ${red}%s${reset}. Choose again from 0 to 3\n" "${ui}" ;;

    esac

  done
}

function russianRulette {
  # https://www.facebook.com/freecodecamp/photos/a.1535523900014339.1073741828.1378350049065059/2006986062868118/?type=3&theater
  # [ $[ $RANDOM % 6 ] == 0 ] && echo "BOOM!!!" || echo "LUCKY GUY!!!"

  let "RV = $RANDOM % 6";

  if [[ $RV == 0 ]]; then
    printf "${red}BOOM!!!${reset} ${bold}You've rolled a %s${reset}\n" "${RV}"
  else
    printf "${blue}LUCKY GUY!!!${reset} ${bold}You've rolled a %s${reset}\n" "${RV}"
  fi
}

# function color_test {
#   #   Daniel Crisman's ANSI color chart script from
#   #   The Bash Prompt HOWTO: 6.1. Colours
#   #   http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
#   #
#   #   This function echoes a bunch of color codes to the
#   #   terminal to demonstrate what's available.  Each
#   #   line is the color code of one forground color,
#   #   out of 17 (default + 16 escapes), followed by a
#   #   test use of that color on all nine background
#   #   colors (default + 8 escapes).
#   #

#   T='gYw'   # The test text

#   echo -e "\n         def     40m     41m     42m     43m     44m     45m     46m     47m";

#   for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
#              '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
#              '  36m' '1;36m' '  37m' '1;37m';

#     do FG=${FGs// /}
#     echo -en " $FGs \033[$FG  $T  "

#     for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
#       do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
#     done
#     echo;
#   done
#   echo
# }

#function fancy_pacman {
#	# from: http://dotshare.it/dots/562/
#
#	f=3 b=4
#	for j in f b; do
#	  for i in {0..7}; do
#	    printf -v $j$i %b "\e[${!j}${i}m"
#	  done
#	done
#	bld=$'\e[1m'
#	rst=$'\e[0m'
#	inv=$'\e[7m'
#
#  cat << EOF
#
#$rst
# $f3  ▄███████▄                $f1  ▄██████▄    $f2  ▄██████▄    $f4  ▄██████▄    $f5  ▄██████▄    $f6  ▄██████▄
# $f3▄█████████▀▀               $f1▄$f7█▀█$f1██$f7█▀█$f1██▄  $f2▄█$f7███$f2██$f7███$f2█▄  $f4▄█$f7███$f4██$f7███$f4█▄  $f5▄█$f7███$f5██$f7███$f5█▄  $f6▄██$f7█▀█$f6██$f7█▀█$f6▄
# $f3███████▀      $f7▄▄  ▄▄  ▄▄   $f1█$f7▄▄█$f1██$f7▄▄█$f1███  $f2██$f7█ █$f2██$f7█ █$f2██  $f4██$f7█ █$f4██$f7█ █$f4██  $f5██$f7█ █$f5██$f7█ █$f5██  $f6███$f7█▄▄$f6██$f7█▄▄$f6█
# $f3███████▄      $f7▀▀  ▀▀  ▀▀   $f1████████████  $f2████████████  $f4████████████  $f5████████████  $f6████████████
# $f3▀█████████▄▄               $f1██▀██▀▀██▀██  $f2██▀██▀▀██▀██  $f4██▀██▀▀██▀██  $f5██▀██▀▀██▀██  $f6██▀██▀▀██▀██
# $f3  ▀███████▀                $f1▀   ▀  ▀   ▀  $f2▀   ▀  ▀   ▀  $f4▀   ▀  ▀   ▀  $f5▀   ▀  ▀   ▀  $f6▀   ▀  ▀   ▀
#$bld
# $f3  ▄███████▄                $f1  ▄██████▄    $f2  ▄██████▄    $f4  ▄██████▄    $f5  ▄██████▄    $f6  ▄██████▄
# $f3▄█████████▀▀               $f1▄$f7█▀█$f1██$f7█▀█$f1██▄  $f2▄█$f7█ █$f2██$f7█ █$f2█▄  $f4▄█$f7█ █$f4██$f7█ █$f4█▄  $f5▄█$f7█ █$f5██$f7█ █$f5█▄  $f6▄██$f7█▀█$f6██$f7█▀█$f6▄
# $f3███████▀      $f7▄▄  ▄▄  ▄▄   $f1█$f7▄▄█$f1██$f7▄▄█$f1███  $f2██$f7███$f2██$f7███$f2██  $f4██$f7███$f4██$f7███$f4██  $f5██$f7███$f5██$f7███$f5██  $f6███$f7█▄▄$f6██$f7█▄▄$f6█
# $f3███████▄      $f7▀▀  ▀▀  ▀▀   $f1████████████  $f2████████████  $f4████████████  $f5████████████  $f6████████████
# $f3▀█████████▄▄               $f1██▀██▀▀██▀██  $f2██▀██▀▀██▀██  $f4██▀██▀▀██▀██  $f5██▀██▀▀██▀██  $f6██▀██▀▀██▀██
# $f3  ▀███████▀                $f1▀   ▀  ▀   ▀  $f2▀   ▀  ▀   ▀  $f4▀   ▀  ▀   ▀  $f5▀   ▀  ▀   ▀  $f6▀   ▀  ▀   ▀
#$rst
#EOF
#}
