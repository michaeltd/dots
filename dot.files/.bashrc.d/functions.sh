# ~/.bashrc.d/functions
#
# SCRAPPAD ====================================================================

# while read a ; do echo ${a//abc/XYZ} ; done < /tmp/file.txt > /tmp/file.txt.t ; mv /tmp/file.txt{.t,}
# echo "abcdef" |replace "abc" "XYZ" # mysqld

# UTILS =======================================================================

function printappsinpath {
  #!/bin/bash
  # The directories in $PATH are separated by ":", so we split by it to get individual directories
  for pdir in $(echo "$PATH" | tr ":" "\n"); do
    # We `find` all files in the directory which are executable and print the filename
    find "$pdir" -maxdepth 1 -executable -type f -printf "%f "
  done
  printf "\n"
}

function listCat {
    $(which ls) --color -al /usr/portage/${1}
}

function checkApp {
  if command -v $1 &> /dev/null; then
    return 0
  else
    printf "${red}Error:${reset} \"${bold}%s${reset}\" is not installed.\n" "${1}"
    return 1
  fi
}

# Line Count Directory ($1), for File Expression ($2).
# eg: lcdfe /my/awesome/project/ *\.html, lcdfe . *\.cpp, lcdfe ${HOME} *\.rc
function lcdfe {
  find "${1}" -iname "${2}" | xargs wc -l
}

# End stuff
function termapp {
  # kill -s 15 $(pgrep "${1}")
  pkill -TERM -u "${USER}" "${1}"
}

function killapp {
  # kill -s 9 $(pgrep "${1}")
  pkill -KILL -u "${USER}" "${1}"
}

# Create a new alias
function mkalias {
  echo "alias ${@}" >> ${HOME}/.bashrc.d/aliases
  alias "${@}"
}

# Remove an alias
function rmalias {
  unalias "${1}" # && sed --follow-symlinks -i "/alias $1\=/d" ${HOME}/.bashrc.d/aliases
}

# Functions to unify archive management in linux CLI environments
function compress {
  case "${1,,}" in
    *.tar.bz2) tar cjf $@;;
    *.tar.gz| *.tgz) tar czf $@;;
    *.zip) zip $@;;
    *.rar) rar a $@;;
    *) printf "${bold}Cannot${reset} operate on ${underline}unknown${end_underline} file extension \"${red}%s${reset}\".\n" "${1}";;
  esac
}

function extract {
  case "${1,,}" in # Compare lowercased filename for known extensions.
    *.7z| *.7za| *.exe| *.cab) 7z x "${1}";;
    *.tar) tar -xf "${1}";;
    *.tar.gz| *.tar.z| *.tgz) tar -xzf "${1}";;
    *.tar.bz2| *.tbz2) tar -xjf "${1}";;
    *.tar.xz| *.txz) tar -Jxf "${1}";;
    *.tar.lz) tar --lzip -xvf "${1}";;
    *.bz2) bunzip2 "${1}";;
    *.rar) rar x "${1}";;
    *.gz) gunzip "${1}";;
    *.zip| *.jar) unzip "${1}";;
    *.z ) uncompress "${1}";;
    * ) printf "${bold}Cannot${reset} operate on ${underline}unknown${end_underline} file extension \"${red}%s${reset}\".\n" "${1}";;
  esac
}

# Traverse directory structure given # of steps
function up {
  DEEP=$1
  for i in $(seq 1 ${DEEP:-"1"}); do
    cd ../
  done
}

function listenOnPort {
  # Returns service listening on given port
  if [[ -z "${1}" ]]; then
    printf "port number expected\n"
    return 1
  else
    lsof -n -iTCP:"${1}" |grep LISTEN
  fi
}

function checkDirSizes {
  # Report first params directory sizes in human readable format
  ls=$(which ls) # Workaround alias
  du=$(which du) #      >>
  if [[ -x "${ls}" && -x "${du}" ]]; then
    for d in $( "${ls}" --directory "${1-${HOME}}"/* ); do
      if [[ -d "${d}" ]]; then
        "${du}" -hs "${d}"
      fi
    done
  fi
}

function printMemUsage {
  #Report Total Used and Available mem in human readable format
  total=$(cat /proc/meminfo |head -1 |awk '{print $2}')
  avail=$(cat /proc/meminfo |head -2 |tail -1 |awk '{print $2}')
  used=$(expr ${total} - ${avail})
  totalMB=$(expr ${total} / 1024)
  availMB=$(expr ${avail} / 1024)
  usedMB=$(expr ${used} / 1024)

  printf "From a total of %dMB, you are using %dMB's, which leaves you with %dMB free memory.\n" ${totalMB} ${usedMB} ${availMB}

}

function services {
  if [[ -z "${1}" ]]; then
    printf "%s requires some parameters.\nUsage: %s start|stop all|service/es...\n" "${FUNCNAME[0]}" "${FUNCNAME[0]}"
    return 1
  elif [[ ("${1}" == "start" || "${1}" == "stop") && ("${2}" == "all") ]]; then
    declare -a srvcs=( "postgresql-10" "mysql" "mongodb" "apache2" "tomcat" "vsftpd" "sshd" "rsyncd" "dictd" "netdata" "webmin" )
  else
    declare -a srvcs=( "${@}" )
    unset srvcs[0]
  fi
  for srvc in "${srvcs[@]}"; do
    sudo rc-service "${srvc}" "${1}"
  done
}

function updateDate {
  sudo ntpdate 0.gentoo.pool.ntp.org
}

function showUptime {
  echo -ne "${blue}${HOSTNAME}${reset} uptime is: ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

function logMeOut {
  # Can't log out root like that
  if [ "${EUID}" -eq "0" ]; then
    printf "Can't log out root this way\n"
    return 1
  else
    kill -15 -1
  fi
}

function pingSubnet {
  for x in {1..254}; do
    for y in {1..254}; do
      (ping -c 1 -w 2 192.168.${x}.${y} > /dev/null && echo "UP 192.168.${x}.${y}" &);
    done
  done
}

# DATE-TIME ===================================================================

function unixepoch {
  if [[ -n "${1}" ]];then
    date +%s --date="${1}"
  else
    date +%s
  fi
}

function epochtodate {
  date +%Y/%m/%d --date="@${1-$(unixepoch)}"
}

function epochtotime {
  date +%H:%M:%S --date="@${1-$(unixepoch)}"
}

function epochtodatetime {
  date +%Y/%m/%d-%H:%M:%S --date="@${1-$(unixepoch)}"
}

# STRINGS =====================================================================

function alphabetic_only {
  printf "%s\n" "${@//[![:alpha:]]}"
}

function alphanumeric_only {
  printf "%s\n" "${@//[![:alnum:]]}"
}

function digits_only {
  printf "%s\n" "${@//[![:digit:]]}"
}

function remove_spaces {
  # https://stackoverflow.com/questions/13659318/how-to-remove-space-from-string
  echo "${@}"|sed 's/ //g'
  # shopt -s extglob # Allow extended globbing
  # var=" lakdjsf   lkadsjf "
  # echo "${var//+([[:space:]])/}"
  # shopt -u extglob
}

function trim {
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

# CRYPTO ======================================================================

function genpass {
  tr -dc [:punct:][:alnum:] < /dev/urandom |head -c ${1:-16}
  printf "\n"
}

# CHUBIN WORKS ================================================================

function cheat_sh {
  # https://github.com/chubin/cheat.sh
  curl cheat.sh/${1}
}

function rate_sx {
  # https://twitter.com/igor_chubin
  curl ${1-"usd"}.rate.sx
}

function wttr_in {
  # https://twitter.com/igor_chubin # Try wttr moon
  curl wttr.in/${1-"Athens"}
}

# GAMES =======================================================================

function rps {
  # Rock Paper Scissors mt 20170525

  declare -a op=("${red}Rock${reset}" "${green}Paper${reset}" "${blue}Scissors${reset}") oc=("${green}WIN${reset}" "${red}Defeat${reset}" "${blue}Draw${reset}")

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

function color_test {
  #   Daniel Crisman's ANSI color chart script from
  #   The Bash Prompt HOWTO: 6.1. Colours
  #   http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
  #
  #   This function echoes a bunch of color codes to the
  #   terminal to demonstrate what's available.  Each
  #   line is the color code of one forground color,
  #   out of 17 (default + 16 escapes), followed by a
  #   test use of that color on all nine background
  #   colors (default + 8 escapes).
  #

  T='gYw'   # The test text

  echo -e "\n         def     40m     41m     42m     43m     44m     45m     46m     47m";

  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m';

    do FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "

    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
      do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
  echo
}

function fancy_pacman {
	# from: http://dotshare.it/dots/562/

	f=3 b=4
	for j in f b; do
	  for i in {0..7}; do
	    printf -v $j$i %b "\e[${!j}${i}m"
	  done
	done
	bld=$'\e[1m'
	rst=$'\e[0m'
	inv=$'\e[7m'

  cat << EOF

$rst
 $f3  ▄███████▄                $f1  ▄██████▄    $f2  ▄██████▄    $f4  ▄██████▄    $f5  ▄██████▄    $f6  ▄██████▄
 $f3▄█████████▀▀               $f1▄$f7█▀█$f1██$f7█▀█$f1██▄  $f2▄█$f7███$f2██$f7███$f2█▄  $f4▄█$f7███$f4██$f7███$f4█▄  $f5▄█$f7███$f5██$f7███$f5█▄  $f6▄██$f7█▀█$f6██$f7█▀█$f6▄
 $f3███████▀      $f7▄▄  ▄▄  ▄▄   $f1█$f7▄▄█$f1██$f7▄▄█$f1███  $f2██$f7█ █$f2██$f7█ █$f2██  $f4██$f7█ █$f4██$f7█ █$f4██  $f5██$f7█ █$f5██$f7█ █$f5██  $f6███$f7█▄▄$f6██$f7█▄▄$f6█
 $f3███████▄      $f7▀▀  ▀▀  ▀▀   $f1████████████  $f2████████████  $f4████████████  $f5████████████  $f6████████████
 $f3▀█████████▄▄               $f1██▀██▀▀██▀██  $f2██▀██▀▀██▀██  $f4██▀██▀▀██▀██  $f5██▀██▀▀██▀██  $f6██▀██▀▀██▀██
 $f3  ▀███████▀                $f1▀   ▀  ▀   ▀  $f2▀   ▀  ▀   ▀  $f4▀   ▀  ▀   ▀  $f5▀   ▀  ▀   ▀  $f6▀   ▀  ▀   ▀
$bld
 $f3  ▄███████▄                $f1  ▄██████▄    $f2  ▄██████▄    $f4  ▄██████▄    $f5  ▄██████▄    $f6  ▄██████▄
 $f3▄█████████▀▀               $f1▄$f7█▀█$f1██$f7█▀█$f1██▄  $f2▄█$f7█ █$f2██$f7█ █$f2█▄  $f4▄█$f7█ █$f4██$f7█ █$f4█▄  $f5▄█$f7█ █$f5██$f7█ █$f5█▄  $f6▄██$f7█▀█$f6██$f7█▀█$f6▄
 $f3███████▀      $f7▄▄  ▄▄  ▄▄   $f1█$f7▄▄█$f1██$f7▄▄█$f1███  $f2██$f7███$f2██$f7███$f2██  $f4██$f7███$f4██$f7███$f4██  $f5██$f7███$f5██$f7███$f5██  $f6███$f7█▄▄$f6██$f7█▄▄$f6█
 $f3███████▄      $f7▀▀  ▀▀  ▀▀   $f1████████████  $f2████████████  $f4████████████  $f5████████████  $f6████████████
 $f3▀█████████▄▄               $f1██▀██▀▀██▀██  $f2██▀██▀▀██▀██  $f4██▀██▀▀██▀██  $f5██▀██▀▀██▀██  $f6██▀██▀▀██▀██
 $f3  ▀███████▀                $f1▀   ▀  ▀   ▀  $f2▀   ▀  ▀   ▀  $f4▀   ▀  ▀   ▀  $f5▀   ▀  ▀   ▀  $f6▀   ▀  ▀   ▀
$rst
EOF
}
