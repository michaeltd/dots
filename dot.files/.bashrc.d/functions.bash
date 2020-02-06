# ~/.bashrc.d/functions.bash
#
# various functions

#shellcheck shell=bash
# SCRAPPAD ====================================================================

# while read a ; do echo ${a//abc/XYZ} ; done < /tmp/file.txt > /tmp/file.txt.t ; mv /tmp/file.txt{.t,}
# echo "abcdef" |replace "abc" "XYZ" # mysqld

findstringindir() {
  # https://stackoverflow.com/questions/16956810/how-do-i-find-all-files-containing-specific-text-on-linux
  grep -rnw "${2}" -e "${1}"
}

allemojis() {
  for (( x = 2600; x <= 2700; x++ )); do
    echo -n -e " \u${x}"
    sleep .1
  done
  echo
}

countdown() {
  clear
  for i in $(seq "${1-10}" -1 0); do
    printf "%04d\n" "${i}" |figlet |lolcat
    sleep 1
    clear
  done
  play -n synth .8 sine 4100 fade q 0.1 .3 0.1 repeat 3
}

# UTILS =======================================================================

pyhttpserv() {
    #!/usr/bin/env bash
    #
    # pyhttpserv.bash Start an http server in current directory
    # https://twitter.com/climagic/status/1224732676361461765
    # python3 -m http.server 8080 # Start a simple webserver using python3 on external port 8080 and use the current directory you are in as the document root. Be careful with what you expose to the world. Use --bind 127.0.0.1 if you want to make it local only.
    # Or the old days with python 2: python -m SimpleHTTPServer 8080

    declare -a pv=( $(python --version) )

    if [[ "${pv[1]}" =~ ^3.* ]]; then
	python -m http.server 8080 --bind 127.0.0.1
    elif [[ "${pv[1]}" =~ ^2.* ]]; then
	python -m SimpleHTTPServer 8080
    else
	echo "Fatal: No suitable python version found!"
	return 1
    fi
}

# (R)un things in the background with (C)ustom niceness and cli switches in a (M)utex kind of way
# Usage : rcm niceness executable command line arguments
# Example: rcm 9 conky -qdc ~/.conkyrc
rcm() {

  (( ${#} < 2 )) && echo -e "Usage: rcm niceness command [arguments ...]\neg: rcm 0 wicd-gtk -t" && return 1
  #shellcheck disable=SC2155
  local bin=$(command -v "${2}") pid=$(pgrep -U "${USER}" -f "${2}")

  [[ -z "${pid}" && -x "${bin}" ]] && exec nice -n "${@}" &
}

printappsinpath() {
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

listcat() {
  #shellcheck disable=SC2230
  /bin/ls --color "/usr/portage/${1}"
}

checkapp() {
  if type -P "${1}" &> /dev/null; then
    return 0
  else
    #shellcheck disable=SC2154
    echo -ne "${red}Error:${reset} \"${bold}${1}${reset}\" is not installed.\n" >&2
    return 1
  fi
}

# Line Count Directory ($1), For file Extension (${2}).
# eg: lcdfe /my/awesome/project/ \*.html, lcdfe . \*.cpp, lcdfe ${HOME} \*.rc
lcdfe() {
  #find "${1}" -iname "${2}" | xargs wc -l
  find "${1}" -iname "${2}" -exec wc -l {} +
}

# End stuff
termapp() {
    # kill -s 15 $(pgrep "${1}")
    if [[ -n "${1}" ]]; then
	pkill -TERM -u "${USER}" "${1}"
    fi
}

killapp() {
  # kill -s 9 $(pgrep "${1}")
    if [[ -n "${1}" ]]; then
	pkill -KILL -u "${USER}" "${1}"
    fi
}

# Create a new alias
mkalias() {
  echo alias "${@}" >> "${HOME}/.bashrc.d/aliases.sh"
  alias "${@}"
}

# Remove an alias
rmalias() {
  unalias "${1}" # && sed --follow-symlinks -i "/alias $1\=/d" ${HOME}/.bashrc.d/aliases
}

# Functions to unify archive management in linux CLI environments
compress() {
  #shellcheck disable=SC2154,SC2068
  case "${1,,}" in
    *.tar.bz2) tar cjf $@;;
    *.tar.gz| *.tgz) tar czf $@;;
    *.zip) zip $@;;
    *.rar) rar a $@;;
    *) echo -ne "${bold}Cannot${reset} operate on ${underline}unknown${end_underline} file extension \"${red}${1}${reset}\".\n" >&2; return 1;;
  esac
}

extract() {
  case "${1,,}" in # Compare lowercased filename for known extensions.
    *.7z| *.7za| *.exe| *.cab) 7z x "${1}";;
    *.tar) tar -xf "${1}";;
    *.tar.gz| *.tar.z| *.tgz) tar -xzf "${1}";;
    *.tar.bz2| *.tbz2) tar -xjf "${1}";;
    *.tar.xz| *.txz) tar -xJf "${1}";;
    *.tar.lz) tar --lzip -xvf "${1}";;
    *.bz2) bunzip2 "${1}";;
    *.rar) rar x "${1}";;
    *.gz) gunzip "${1}";;
    *.zip| *.jar| *.war) unzip "${1}";;
    *.z ) uncompress "${1}";;
    * ) echo -ne "${bold}Cannot${reset} operate on ${underline}unknown${end_underline} file extension \"${red}${1}${reset}\".\n" >&2; return 1;;
  esac
}

# Traverse directory structure given # of steps
up() {
  DEEP="${1}"
  for i in $(seq 1 "${DEEP:-1}"); do
    cd ../
  done
}

listen_port() {
  # Returns service listening on given port
  if [[ -z "${1}" ]]; then
    printf "port number expected\n" >&2
    return 1
  else
    lsof -n -iTCP:"${1}" |grep LISTEN
  fi
}

dir_sizes() {
  # Report first params directory sizes in human readable format
  #shellcheck disable=SC2230
  ls=$(which ls) # Workaround alias
  #shellcheck disable=SC2230
  du=$(which du) #      >>
  if [[ -x "${ls}" && -x "${du}" ]]; then
    for d in $( "${ls}" --directory "${1-${HOME}}"/* ); do
      if [[ -d "${d}" ]]; then
        "${du}" -hs "${d}"
      fi
    done
  fi
}

mem_sum() {
  ps -eo size,pid,user,command --sort -size | \
    awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | \
    cut -d "" -f2 | \
    cut -d "-" -f1| \
    grep "${1}"
}

print_mem() {
  #Report Total Used and Available mem in human readable format
  total=$(head -1 /proc/meminfo |awk '{print $2}')
  avail=$(head -2 /proc/meminfo |tail -1 |awk '{print $2}')
  used=$(( total - avail ))
  totalMB=$(( total / 1024 ))
  availMB=$(( avail / 1024 ))
  usedMB=$(( used / 1024 ))
  #echo -ne "From a total of ${DARK_BLUE} ${totalMB}${reset} MB, you are using ${DARK_RED}${usedMB}${reset} MB's, which leaves you with ${DARK_GREEN}${availMB}${reset} MB free memory.\n"
  echo -ne "${LIGHT_BLUE}${totalMB}${reset} MB total, ${DARK_RED}${usedMB}${reset} MB used, ${DARK_GREEN}${availMB}${reset} MB free.\n"
}

services() {
  if [[ -z "${1}" ]]; then
    echo -ne "Usage: ${FUNCNAME[0]} start|stop|restart all|service[/s...]\n" >&2
    return 1
  elif [[ ("${1}" == "start" || "${1}" == "stop" || "${1}" == "restart" || "${1}" == "status") && ("${2}" == "all") ]]; then
    declare -a srvcs=( "postgresql-11" "mysql" "mongodb" "apache2" "tomcat" "vsftpd" "sshd" "rsyncd" )
  else
    declare -a srvcs=( "${@}" )
    unset "srvcs[0]"
  fi
  for srvc in "${srvcs[@]}"; do
    sudo rc-service "${srvc}" "${1}"
  done
}

update_date() {
  sudo ntpdate 0.gentoo.pool.ntp.org
}

show_uptime() {
  #shellcheck disable=SC2154
  echo -ne "${blue}${HOSTNAME}${reset} uptime is: "
  uptime | \
    awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

log_out() {
  # Can't log out root like that
  if [ "${EUID}" -eq "0" ]; then
    printf "Can't log out root this way\n" >&2
    return 1
  else
    kill -15 -1
  fi
}

ping_subnet() {
  # One liner:
  # for sn in {1..254}.{1..254}; do (ping -c 1 -w 2 192.168.${sn} > /dev/null && echo "UP 192.168.${sn}" &); done
  for x in {1..254}; do
    for y in {1..254}; do
      {
        ping -c 1 192.168.${x}.${y} &> /dev/null && echo "UP 192.168.${x}.${y}"
      } &
    done
  done
}

getmimetype(){
    file -b --mime-type "${1}"
}

getfiletype(){
    file -b "${1}"|awk '{print $1}'
}

showInterFaces() {
    ip -brief -color address show
}
