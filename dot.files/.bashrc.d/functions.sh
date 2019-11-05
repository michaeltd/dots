# ~/.bashrc.d/functions.sh
#
# various functions
# SCRAPPAD ====================================================================

# while read a ; do echo ${a//abc/XYZ} ; done < /tmp/file.txt > /tmp/file.txt.t ; mv /tmp/file.txt{.t,}
# echo "abcdef" |replace "abc" "XYZ" # mysqld

findstringindir() {
  # https://stackoverflow.com/questions/16956810/how-do-i-find-all-files-containing-specific-text-on-linux
  grep -rnw "${2}" -e "${1}"
}

function allemojis () {
  for (( x = 2600; x <= 2700; x++ )); do
    echo -n -e " \u${x}"
    sleep .1
  done
  echo
}

function countdown {
  clear
  for i in `seq ${1-10} -1 0`
  do
    printf "%04d\n" "${i}"| figlet
    sleep 1
    clear
  done
  play -n synth .8 sine 4100 fade q 0.1 .3 0.1 repeat 3
}

# UTILS =======================================================================

# Run things in the background with Custom niceness and cli switches in a Mutex kind of way
# Usage : rcm niceness executable command line arguments
# Example: rcm 9 conky -qdc ~/.conkyrc
function rcm {

  if (( ${#} < 2 )); then
    echo -e "Usage: rcm niceness command [arguments ...]\neg: rcm 0 wicd-gtk -t"
    return 1
  fi

  bin=$(which "${2}")
  pid=$(pgrep -U "${USER}" -f "${2}")
  if [ -z "${pid}" ] && [ -x "${bin}" ]; then
    exec nice -n "${@}" &
  fi
}

function printappsinpath {
  # https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
  # The directories in $PATH are separated by ":",
  # so we split by it to get individual directories
  for pdir in $(echo "$PATH" | tr ":" "\n"); do
    # We `find` all files in the directory
    # which are executable and print the filename
    find "$pdir" -maxdepth 1 -executable -type f -printf "%f "
  done
  printf "\n"
}

function listcat {
  $(which ls) --color /usr/portage/${1}
}

function checkapp {
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
    *) printf "${bold}Cannot${reset} operate on ${underline}unknown${end_underline} file extension \"${red}%s${reset}\".\n" "${1}" >&2; return 1;;
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
    *.zip| *.jar| *.war) unzip "${1}";;
    *.z ) uncompress "${1}";;
    * ) printf "${bold}Cannot${reset} operate on ${underline}unknown${end_underline} file extension \"${red}%s${reset}\".\n" "${1}" >&2; return 1;;
  esac
}

# Traverse directory structure given # of steps
function up {
  DEEP=$1
  for i in $(seq 1 ${DEEP:-"1"}); do
    cd ../
  done
}

function listenonport {
  # Returns service listening on given port
  if [[ -z "${1}" ]]; then
    printf "port number expected\n" >&2
    return 1
  else
    lsof -n -iTCP:"${1}" |grep LISTEN
  fi
}

function checkdirsizes {
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

memsumapp() {
  ps -eo size,pid,user,command --sort -size | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |cut -d "" -f2 | cut -d "-" -f1|grep ${1}
}

function printmemusage {
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
    printf "%s requires some parameters.\nUsage: %s start|stop|restart all|service/es...\n" "${FUNCNAME[0]}" "${FUNCNAME[0]}" >&2
    return 1
  elif [[ ("${1}" == "start" || "${1}" == "stop" || "${1}" == "restart" || "${1}" == "status") && ("${2}" == "all") ]]; then
    declare -a srvcs=( "postgresql-11" "mysql" "mongodb" "apache2" "tomcat" "vsftpd" "sshd" "rsyncd" "dictd" )
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

function showuptime {
  echo -ne "${blue}${HOSTNAME}${reset} uptime is: ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

function logmeout {
  # Can't log out root like that
  if [ "${EUID}" -eq "0" ]; then
    printf "Can't log out root this way\n" >&2
    return 1
  else
    kill -15 -1
  fi
}

function pingsubnet {
  # One liner:
  # for sn in {1..254}.{1..254}; do (ping -c 1 -w 2 192.168.${sn} > /dev/null && echo "UP 192.168.${sn}" &); done
  for x in {1..254}; do
    for y in {1..254}; do
      (ping -c 1 -w 2 192.168.${x}.${y} > /dev/null && echo "UP 192.168.${x}.${y}" &);
    done
  done
}
