#!/bin/env /bin/bash

# Report first params directory sizes in human readable format
function checkDirSizes {
  # Workaround alias issues
  ls=$(which ls)
  du=$(which du)
  # Have real ls
  if [ -x "${ls}" ]; then
    # Have real du
    if [ -x "${du}" ]; then
      for d in $("${ls}" --directory "${1-${HOME}}"/*); do
        if [ -d "${d}" ]; then
          "${du}" -hs "${d}"
        fi
      done
    fi
  fi
}

#Report Total Used and Available mem in human readable format
function printMemUsage {
  total=$(cat /proc/meminfo |head -1 |awk '{print $2}')
  avail=$(cat /proc/meminfo |head -2 |tail -1 |awk '{print $2}')
  used=$(expr ${total} - ${avail})
  totalMB=$(expr ${total} / 1024)
  availMB=$(expr ${avail} / 1024)
  usedMB=$(expr ${used} / 1024)

  printf "From a total of %dMB, you are using %dMB's, which leaves you with %dMB free memory.\n" $totalMB $usedMB $availMB

}

# Rock Paper Scissors mt 20170525
function rps {
  declare -a op; declare -a oc; declare -A rs
  op=("Rock" "Paper" "Scissors")
  oc=("WIN" "Defeat" "Draw")
  rs[0,0]=${oc[2]}; rs[0,1]=${oc[1]}; rs[0,2]=${oc[0]}
  rs[1,0]=${oc[0]}; rs[1,1]=${oc[2]}; rs[1,2]=${oc[1]}
  rs[2,0]=${oc[1]}; rs[2,1]=${oc[0]}; rs[2,2]=${oc[2]}
  cs=0; us=0; ns=0; rd=0

  printf "Hello! Welcome to %s %s %s Game!\n" ${op[0]} ${op[1]} ${op[2]}
  while true; do
    read -e -p "${op[0]}:1, ${op[1]}:2, ${op[2]}:3, Quit:0. What's your pick?: " ui
    let "ui = $ui - 1"
    ci=$(shuf -i 0-2 -n 1)
    if [ "$ui" -eq "-1" ]; then
      if [ "$us" -gt "$cs" ] ; then
        bbmsg="${oc[0]}"
      elif [ "$us" -lt "$cs" ] ; then
        bbmsg="got ${oc[1]}ed by"
      elif [ "$us" -eq "$cs" ] ; then
        bbmsg="${oc[2]}ed with"
      fi
      printf "After %d rounds, you %s the CPU with %d:%d points and %d ties.\n" $rd "${bbmsg}" $us $cs $ns
      return 0
    fi
    let "rd++"
    printf "Round : %d is a %s. You selected %s, while the CPU rolled %s\n" $rd ${rs["${ui}","${ci}"]}  ${op["${ui}"]} ${op["${ci}"]}
    case ${rs["${ui}","${ci}"]} in
      ${oc[0]}) let "us++";;
      ${oc[1]}) let "cs++";;
      ${oc[2]}) let "ns++";;
    esac
    printf "Player : %d, CPU : %d, Ties : %d\n" $us $cs $ns
  done
}

# https://www.facebook.com/freecodecamp/photos/a.1535523900014339.1073741828.1378350049065059/2006986062868118/?type=3&theater
# [ $[ $RANDOM % 6 ] == 0 ] && echo "BOOM!!!" || echo "LUCKY GUY!!!"
function russianRulette {

  let "RV = $RANDOM % 6";

  if [[ $RV == 0 ]]; then
    echo "BOOM!!! You've rolled a ${RV}"
  else
    echo "LUCKY GUY!!! You've rolled a ${RV}"
  fi
}

function servStuff {
  if [ -z "${1}" ]; then
    printf "Usage: servStuff start||stop\n"
    return 1
  elif [ "${EUID}" -ne "0" ]; then
    printf "servStuff requires root privilages.\n"
    sudo -E servStuff "${1}"
    return $?
  else
    srvcs="postgresql-9.5 apache2 vsftpd sshd rsyncd dictd ntpd"
    for srvc in $srvcs; do
        rc-service "${srvc}" "${1}"
    done
  fi
}

function helloWorld {
  read -e -p "Give me a Name : " name
  echo "Hello ${name}"
}

# http://www.accuweather.com/
function accuWeather {
  URL='http://www.accuweather.com/en/gr/athens/182536/weather-forecast/182536'
  wget -q -O- "$URL" | awk -F\' '/acm_RecentLocationsCarousel\.push/{print $2": "$16", "$12"°" }'| head -1
}

# https://twitter.com/igor_chubin # Try wttr moon
function wttr {
  if [ -z "$1" ]; then
    curl wttr.in/Athens
  else
    curl wttr.in/"${1}"
  fi
}

# (L)ist(T)esting(E)(B)uilds
function lteb {
	ua=$(uname -a|grep -i gentoo)
	if [ -z "${ua}" ]; then
    echo "Usage: You need to find a Gentoo box first"
    return 1
  else
		equery list '*' | sed 's/\(.*\)/=\1 ~amd64/'
	fi
}

# (M)ain(T)ainer(L)ess(E)(B)uilds
# https://wiki.gentoo.org/wiki/Project:Proxy_Maintainers/
function mtleb {
	ua=$(uname -a|grep -i gentoo)
	if [ -z "${ua}" ]; then
    echo "Usage: You need to find a Gentoo box first"
    return 1
	else
		fgrep -l maintainer-needed /usr/portage/*/*/metadata.xml |cut -d/ -f4-5 |fgrep -x -f <(EIX_LIMIT=0 eix -I --only-names)
	fi
}

function runCmd {
  DIALOG=${1-"Xdialog"}
  #TMPFILE="/tmp/input.box.txt"
  TMPFILE=/tmp/"${RANDOM}".input.box.txt

  $DIALOG \
    --title "Command Input" \
    --default-button "ok" \
    --inputbox "Enter command to continue" \
    10 40 \
    command 2> $TMPFILE
	#Exit code
  RETVAL=$?
  USRINPUT=$(cat ${TMPFILE})
  $USRINPUT
  return $?
}

# Take a parameter and respawn it periodicaly if it crashes. check interval is second param seconds
function keepParamAlive {
	# Endless loop.
  while [ true ]; do
		# Get a pid.
    pid=`pgrep -x ${1}`
		# If there is no proc associated with it,
    if [[ -z "${pid}" ]]; then
			# Start Param to background.
      ${1} &
    else
			# wait $second parameter's ''seconds
      sleep ${2-"60"}
    fi
  done
}

# Pipe furtune or second param throu cowsay and lolcat for some color magic
# requires fortune cowsay lolcat
function lol {
  file=${1-"tux"}
  if [[ -z "${2}" ]]; then
    cmmnd="fortune"
  else
    cmmnd="echo -e ${2}"
  fi
  $cmmnd |cowsay -f $file |lolcat
}

# For use with WindowMaker
# Replace "${APPS}" list with your desired applets.
function startApps {
  # Fill a list with the applets you need
  APPS="wmfire wmclockmon wmsystray wmMatrix wmbinclock wmbutton wmifinfo wmnd wmmon wmcpuload wmsysmon wmmemload wmacpi wmtime wmcalc wmSpaceWeather wmudmount wmmp3"
  for APP in $APPS ; do
    # Just in case (WM restarts do happen you know ...)
    killall $APP
    $APP &
  done
}

# For use with WindowMaker
# Run this to update your Root menu to reflect themes or apps changes
function regenMenu {
  # Backup Root menu
  cp ~/GNUstep/Defaults/WMRootMenu ~/GNUstep/Defaults/`date +%y%m%d%H%M%S`WMRootMenu
  # Write new menu
  wmgenmenu > ~/GNUstep/Defaults/WMRootMenu
}

# Script to give one comand to extract any kind of file
# from https://www.facebook.com/TekNinjakevin
function deflateThat {
  if [[ -r "${1}" ]] ; then
    case "${1}" in
      *.7z.7za) 7z "${1}" ;;
      *.tar.bz2) tar xjf "${1}" ;;
      *.tar.gz) tar xzf "${1}" ;;
      *.tar.Z) tar xzf "${1}" ;;
      *.tar.z) tar xzf "${1}" ;;
      *.tar.xz) tar Jxf "${1}" ;;
      *.bz2) bunzip2 "${1}" ;;
      *.rar) unrar x "${1}" ;;
      *.gz) gunzip "${1}" ;;
      *.jar) unzip "${1}" ;;
      *.tar) tar xf "${1}" ;;
      *.tbz2) tar xjf "${1}" ;;
      *.tgz) tar xzf "${1}" ;;
      *.zip) unzip "${1}" ;;
      *.Z) uncompress "${1}" ;;
      *) echo "'${1}' cannot be extracted." ;;
    esac
  else
    echo "'${1}' is not readable."
  fi
}

function updateDate {
  if [ "${EUID}" -ne "0" ]; then
    printf "Need root privilages\n"
    sudo -E updateDate
    return $?
  else
    ntpdate 0.gentoo.pool.ntp.org
  fi
}

function showUptime {
  echo -ne "${green}$HOSTNAME ${green}uptime is ${green} \t ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

# Call that to logout
function logMeOut {
  # Can't log out root like that
  if [ "${EUID}" -eq "0" ]; then
    printf "Can't log out root this way\n"
    return 1
  else
    kill -15 -1
  fi
}

# Take a screenshot imagemagic
# Requires Imagemagic Viewnior
function imageMagicScreenShot {
  PI=${1-"2"}
  FN="${HOME}"/imagemagic-`date +%y%m%d%H%M%S`.png
  import -pause $PI -window root $FN
  viewnior $FN
}

function test {
  echo $0
}
