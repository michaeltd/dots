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
    play -q -n synth .8 sine 4100 fade q 0.1 .3 0.1 repeat 3
}

# igor chubbin =================================================================

chtsh() {
    # https://github.com/chubin/cheat.sh
    curl "cht.sh/${1}"
}

ccxrates() {
    # https://twitter.com/igor_chubin
    curl "https://${1:-eur}.rate.sx"
}

wttrin() {
    # https://twitter.com/igor_chubin # Try wttr moon
    curl "https://wttr.in/${1:-moon}"
}

# UTILS =======================================================================

webp2jpg() {
    [[ -z "${1}" ]] && \
	echo -ne "Usage: ${FUNCNAME[0]} files to convert\n" && \
	return 1
    for i in ${@}; do
	ffmpeg -i "${i}" "${i}.jpg"
    done
}

bash_load_times() {
    time bash -ic exit
}

emacs_load_times(){
    time emacs --eval='(kill-emacs)'
}

term_geom() {
    echo "${COLUMNS}x${LINES}"
}

hello_world() {
    echo -ne "\n ${green}Hello${reset} ${bold}${USER}${reset}, today is ${cyan}$(date '+%A, %B %d')${reset}\n\n"
    curl https://wttr.in?0
    printf "\n"
}

makebackup() {
    [[ ! -f "${1}" ]] && \
	echo -ne "Usage: ${FUNCNAME[0]} file-2-backup\n" && \
	return 1
    cp -v "${1}" "${1}.bkp.$(date +%s)"
}

pyhttpserv() {
    # pyhttpserv.bash Start an http server in current directory
    # https://twitter.com/climagic/status/1224732676361461765
    # python3 -m http.server 8080 \
    # Start a simple webserver using python3 on external port 8080 \
    # and use the current directory you are in as the document root. \
    # Be careful with what you expose to the world. \
    # Use --bind 127.0.0.1 if you want to make it local only.
    # Or the old days with python 2: python -m SimpleHTTPServer 8080
    local -a pv=( $(python --version) )
    if [[ "${pv[1]}" =~ ^3.* ]]; then
	python -m http.server 8080 --bind 127.0.0.1
    elif [[ "${pv[1]}" =~ ^2.* ]]; then
	python -m SimpleHTTPServer 8080
    else
	echo "Fatal: No suitable python version found!" >&2
	return 1
    fi
}

rcm() {
    # (R)un things in the background with (C)ustom niceness and cli switches in a (M)utex kind of way
    # Usage : rcm niceness executable command line arguments
    # Example: rcm 9 conky -qdc ~/.conkyrc
    (( ${#} < 2 )) && echo -ne "Usage: ${FUNCNAME[0]} niceness command [arguments ...]\neg: rcm 0 wicd-gtk -t\n" >&2 && return 1
    #shellcheck disable=SC2155
    local -r bin=$(type -P "${2}") pid=$(pgrep -U "${USER}" -f "${2}")
    [[ -z "${pid}" && -x "${bin}" ]] && exec nice -n "${@}" &>/dev/null &
}

list_cat() {
    #shellcheck disable=SC2230
    /bin/ls --color "/usr/portage/${1}"
}

check_app() {
    [[ -z "${1}" ]] && echo -ne "Usage: ${FUNCNAME[0]} executable" >&2 && return 1
    type -P "${1}" &> /dev/null
}

# Line Count Directory ($1), For file Extension (${2}).
# eg: lcdfe /my/awesome/project/ \*.html, lcdfe . \*.cpp, lcdfe ${HOME} \*.rc
lcdfe() {
    #find "${1}" -iname "${2}" | xargs wc -l
    find "${1}" -iname "${2}" -exec wc -l {} +
}

# End stuff
term_app() {
    # kill -s 15 $(pgrep "${1}")
    if [[ -n "${1}" ]]; then
	pkill -TERM -u "${USER}" "${1}"
    else
	echo -ne "Usage: ${FUNCNAME[0]} process-2-TERM\n" >&2
	return 1
    fi
}

kill_app() {
    # kill -s 9 $(pgrep "${1}")
    if [[ -n "${1}" ]]; then
	pkill -KILL -u "${USER}" "${1}"
    else
	echo -ne "Usage: ${FUNCNAME[0]} process-2-KILL\n" >&2
	return 1
    fi
}

# Create a new alias
mkalias() {
    echo alias "${@}" >> "${HOME}/.bashrc.d/aliases.bash"
    alias "${@}"
}

# Remove an alias
rmalias() {
    unalias "${1}" # && sed --follow-symlinks -i "/alias $1\=/d" ${HOME}/.bashrc.d/aliases.bash
}

# Functions to unify archive management in linux CLI environments
compress() {
    #shellcheck disable=SC2154,SC2068
    case "${1,,}" in
	*.tar.bz2|*.tbz2) tar cjf $@;;
	*.tar.gz|*.tgz) tar czf $@;;
	*.zip) zip $@;;
	*.rar) rar a $@;;
	*.7z|*.7za) 7z a $@;;
	*) echo -ne "${bold}Cannot${reset} operate on ${underline}unknown${end_underline} file extension \"${red}${1}${reset}\".\n" >&2;return 1;;
    esac
}

extract() {
    case "${1,,}" in # Compare lowercased filename for known extensions.
	*.7z|*.7za|*.exe|*.cab) 7z x "${1}";;
	*.tar) tar -xf "${1}";;
	*.tar.gz|*.tgz|*.tar.z) tar -xzf "${1}";;
	*.tar.bz2|*.tbz2) tar -xjf "${1}";;
	*.tar.xz|*.txz) tar -xJf "${1}";;
	*.tar.lz) tar --lzip -xf "${1}";;
	*.bz2) bunzip2 "${1}";;
	*.rar) rar x "${1}";;
	*.gz) gunzip "${1}";;
	*.zip|*.jar|*.war) unzip "${1}";;
	*.z) uncompress "${1}";;
	*) echo -ne "${bold}Cannot${reset} operate on ${underline}unknown${end_underline} file extension \"${red}${1}${reset}\".\n" >&2; return 1;;
    esac
}

# Traverse directory structure given # of steps
up() {
    DEEP="${1}"
    for i in $(seq 1 "${DEEP:-1}");do
	cd ../
    done
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
	declare -a srvcs=( "postgresql-12" "mysql" "mongodb" "apache2" "tomcat" "vsftpd" "sshd" "rsyncd" )
    else
	declare -a srvcs=( "${@}" )
	unset "srvcs[0]"
    fi
    for srvc in "${srvcs[@]}"; do
	sudo rc-service "${srvc}" "${1}"
    done
}

set_date() {
    sudo ntpdate 0.gentoo.pool.ntp.org
}

show_uptime() {
    #shellcheck disable=SC2154
    echo -ne "${blue}${HOSTNAME}${reset} uptime is: "
    uptime|awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

log_out() {
    # Can't log out root like that
    [[ "${EUID}" -eq "0" ]] && printf "Can't log out root this way\n" >&2 && return 1
    kill -15 -1
}

# NET ==========================================================================

ping_subnet() {
    # One liner:
    # for sn in {1..254}.{1..254}; do (ping -c 1 -w 2 192.168.${sn} > /dev/null && echo "UP 192.168.${sn}" &); done
    for x in {1..254}; do
	for y in {1..254}; do
	    (ping -c 1 192.168.${x}.${y} &> /dev/null && echo "UP 192.168.${x}.${y}" &) &
	done
    done
}

tcp_port_scan() {
    # echo "Scanning TCP ports..."
    for p in {1..1023}; do
	# (echo > /dev/tcp/localhost/$p) > /dev/null 2>&1 && echo "$p open"
	(echo > /dev/tcp/localhost/$p) > /dev/null 2>&1 && echo "${p}"
    done
}

listening_on() {
    # Returns service listening on given port
    [[ -z "${1}" ]] && \
	printf "Usage: ${FUNCNAME[0]} port-number\n" >&2 && \
	return 1
    while [[ -n "${1}" ]]; do
	sudo lsof -niTCP:"${1}" |grep LISTEN
	shift
    done
}

show_interfaces() {
    ip -brief -color address show
}

# FS ===========================================================================

get_mime_type(){
    file -b --mime-type "${1}"
}

get_file_type(){
    file -b "${1}"|awk '{print $1}'
}

dir_sizes() {
    # Report first params directory sizes in human readable format
    #shellcheck disable=SC2230
    local ls=$(which ls) du=$(which du)
    if [[ -x "${ls}" && -x "${du}" ]]; then
	for d in $( "${ls}" --directory "${1-${HOME}}"/* ); do
	    if [[ -d "${d}" ]]; then
		"${du}" -hs "${d}"
	    fi
	done
    fi
}

print_apps_in_path() {
    # https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
    # The directories in $PATH are separated by ":",
    # so we split by it to get individual directories
    for pdir in $(echo "$PATH" | tr ":" "\n");do
	# We `find` all files in the directory
	# which are executable and print the filename
	find "$pdir" -maxdepth 1 -executable -type f -printf "%f "
    done
    printf "\n"
}

