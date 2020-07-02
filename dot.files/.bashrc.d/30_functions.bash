#
# various functions

#shellcheck shell=bash
# SCRAPPAD ====================================================================

# while read a ; do echo ${a//abc/XYZ} ; done < /tmp/file.txt > /tmp/file.txt.t ; mv /tmp/file.txt{.t,}
# echo "abcdef" |replace "abc" "XYZ" # mysqld

# allemojis() {
#     for (( x = 2600; x <= 2700; x++ )); do
# 	echo -n -e " \u${x}"
# 	sleep .1
#     done
#     echo
# }

focolol(){
    fortune -o|cowsay -f "${1:-eyes}"|lolcat
}

mycountdown() {
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

hello_world() {
    echo -ne "\n $(tput setaf 2)Hello$(tput sgr0) $(tput bold)${USER}$(tput sgr0), today is $(tput setaf 5)$(date '+%A, %B %d')$(tput sgr0)\n\n"
    curl https://wttr.in?0
    printf "\n"
}

# UTILS =======================================================================

is_executable() {
    [[ -z "${1}" ]] && echo -ne "Usage: ${FUNCNAME[0]} executable" >&2 && return 1
    command -v "${1}" >/dev/null 2>&1 
}

lcdfe() {
    # Line Count Directory ($1), For file Extension (${2}).
    # eg: lcdfe /my/awesome/project/ \*.html, lcdfe . \*.cpp, lcdfe ${HOME} \*.rc
    find "${1}" -iname "${2}" -exec wc -l {} +
}

rwpi() {
    local -r usage="\n\tUsage: ${FUNCNAME[0]} images-directory\n\tSet a Random WallPaper Image from a directory with images.\n\n" \
	  mypics="${HOME}/Pictures/dPic/r"
    if [[ -d "${1}" ]]; then
	feh -rz --bg-scale "${1}"
    elif [[ -f "${1}" ]] && [[ "$(file "${1}")" =~ image ]]; then
	feh --bg-scale "${1}"
    elif [[ -d "${mypics}" ]]; then
	feh -rz --bg-scale "${mypics}"
    else
	echo -ne "${usage}"
    fi
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

    local -r pv="$(python --version 2>&1)"
    if [[ "${pv}" =~ ^Python\ 3. ]]; then
	python -m http.server 8080 --bind 127.0.0.1
    elif [[ "${pv}" =~ ^Python\ 2. ]]; then
	python -m SimpleHTTPServer 8080
    else
	echo "Fatal: No suitable python version found!" >&2
	return 1
    fi
}

rncmmd(){
    # Oneliner: TMPFILE=/tmp/${RANDOM}.input.box.txt && dialog --title 'Command Input' --default-button 'ok' --inputbox 'Enter command to continue' 10 40 command 2> ${TMPFILE} && $(cat ${TMPFILE})
    local -r DIALOG="$(type -P Xdialog || type -P dialog)" TMPFILE="/tmp/${$}.${RANDOM}.input.box.txt"
    "${DIALOG}" --title "Command Input" --default-button "ok" --inputbox "Enter command to continue" 10 40 command 2> "${TMPFILE}"
    #shellcheck disable=SC2091
    "$(cat "${TMPFILE}")"
    return "${?}"
}

# Create a new alias
mkalias() {
    echo alias "${*}" >> "${HOME}/.bashrc.d/aliases.bash"
    alias "${*}"
}

# Remove an alias
rmalias() {
    unalias "${1}" && sed --follow-symlinks -i "/alias $1\=/d" "${HOME}/.bashrc.d/aliases.bash"
}

# Traverse directory structure given # of steps
up() {
    local -r deep="${1}"
    for i in $(seq 1 "${deep:-1}"); do
	cd ..
    done
}

# SYSTEM =======================================================================

if command -v emerge &>/dev/null; then
    services() {
	[[ -z "${1}" ]] && \
	    echo -ne "Usage: ${FUNCNAME[0]} start|stop|restart all|service[/s...]\n" >&2 && \
	    return 1
	if [[ "${1}" == "start" || "${1}" == "stop" || "${1}" == "restart" || "${1}" == "status" ]] && [[ "${2}" == "all" ]]; then
	    local -a srvcs=( "postgresql-12" "mongodb" "apache2" "tomcat" "vsftpd" "sshd" "rsyncd" )
	else
	    local -a srvcs=( "${@}" )
	    unset "srvcs[0]"
	fi
	for srvc in "${srvcs[@]}"; do
	    sudo rc-service "${srvc}" "${1}"
	done
    }

    list_cat() {
	#shellcheck disable=SC2230
	/bin/ls --color "/usr/portage/${1}"
    }
fi

fixel() {
    if [[ -d /mnt/el/Documents ]]; then
	ls /mnt/el/
    else
	sudo mount /mnt/el
    fi
}

# SYS INFO =====================================================================

show_uptime() {
    #shellcheck disable=SC2154
    echo -ne "${blue}${HOSTNAME}${reset} uptime is: "
    uptime|awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

mem_sum() {
    ps -eo size,pid,user,command --sort -size | \
	awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | \
	cut -d "" -f2 | \
	cut -d "-" -f1| \
	grep "${1}"
}

mem_useage() {
    #Report Total Used and Available mem in human readable format
    total=$(head -1 /proc/meminfo |awk '{print $2}')
    avail=$(head -2 /proc/meminfo |tail -1 |awk '{print $2}')
    used=$(( total - avail ))
    totalMB=$(( total / 1024 ))
    availMB=$(( avail / 1024 ))
    usedMB=$(( used / 1024 ))
    echo -ne "${totalMB} MB total, ${usedMB} MB used, ${availMB} MB free.\n"
}

# PROCESSES ====================================================================

logmeout() {
    # Can't log out root like that
    [[ "${EUID}" -eq "0" ]] && printf "Can't log out root this way\n" >&2 && return 1
    kill -15 -1
}

# # End stuff
termproc() {
    # kill -s 15 $(pgrep "${1}")
    if [[ -n "${1}" ]]; then
	pkill -TERM -u "${USER}" "${1}"
    else
	echo -ne "Usage: ${FUNCNAME[0]} process-2-TERM\n" >&2
	return 1
    fi
}

killproc() {
    # kill -s 9 $(pgrep "${1}")
    if [[ -n "${1}" ]]; then
	pkill -KILL -u "${USER}" "${1}"
    else
	echo -ne "Usage: ${FUNCNAME[0]} process-2-KILL\n" >&2
	return 1
    fi
}

rcm() {
    # (R)un things in the background with (C)ustom niceness and cli switches in a (M)utex kind of way
    # Usage : rcm niceness executable command line arguments
    # Example: rcm 9 conky -qdc ~/.conkyrc
    #shellcheck disable=SC2155
    local thebin="$(command -v "${2}")" thepid="$(pgrep -U "${USER}" -f "${2}")"
    [[ "${#}" -lt "2" ]] && printf "\n\tUsage: %s niceness command [arguments ...]\n\teg: rcm 0 wicd-gtk -t\n\n" "${FUNCNAME[0]}" >&2 && return 1
    [[ -z "${thepid}" && -x "${thebin}" ]] && exec nice -n "${@}" &
}

# NET ==========================================================================

ping_subnet() {
    # One liner: for sn in {1..254}.{1..254}; do (ping -c 1 -w 2 192.168.${sn} > /dev/null && echo "UP 192.168.${sn}" &); done
    for x in {1..254}; do
	for y in {1..254}; do
	    (ping -c 1 "192.168.${x}.${y}" &> /dev/null && echo "UP 192.168.${x}.${y}" &) &
	done
    done
}

tcp_port_scan() {
    for p in {1..1023}; do
	(echo > "/dev/tcp/localhost/${p}") > /dev/null 2>&1 && echo "${p}"
    done
}

listening_on() {
    # Returns service listening on given port
    [[ -z "${1}" ]] && \
	printf "Usage: %s port-number\n" "${FUNCNAME[0]}" >&2 && \
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

# Functions to unify archive management in linux CLI environments
compress() {
    #shellcheck disable=SC2154,SC2068
    case "${1,,}" in
	*.tar.bz2|*.tbz2) tar cjf $@;;
	*.tar.gz|*.tgz) tar czf $@;;
	*.zip) zip $@;;
	*.rar) rar a $@;;
	*.7z|*.7za) 7z a $@;;
	*) echo -ne "\n\tCannot operate on unknown file extension ${1}.\n\n" >&2;return 1;;
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
	*) echo -ne "\n\tCannot operate on unknown file extension ${1}.\n\n" >&2; return 1;;
    esac
}

s4strInDir() {
    # https://stackoverflow.com/questions/16956810/how-do-i-find-all-files-containing-specific-text-on-linux
    [[ -z "${1}" ]] && \
	echo -ne "\n\tUsage: ${FUNCNAME[0]} search-term [directory]\n\t(S)earch (4) (s)tring (in) (D)irectory.\n\teg: ${FUNCNAME[0]} author ./\n\n" && \
	return 1
    grep -rnw "${2:-./}" -e "${1}"
}

cif2(){
    [[ "${#}" -ne "2" ]] && \
	echo -ne "\n\tUsage: ${FUNCNAME[0]} from to\n\tConvert Image(s) From - To formats.\n\teg: ${FUNCNAME[0]} png jpg\n\n" && \
	return 1
    for i in *"${1}"; do
	convert "${i}" "${i/%.${1}/.${2}}" # && rm "${i}"
    done
}

mkbkp() {
    [[ ! -f "${1}" ]] && echo -ne "\n\tUsage: ${FUNCNAME[0]} file-2-backup\n\n" && return 1
    compress "${1}.$(date +%s).tgz" "${1}"
}

get_mime_type(){
    file -b --mime-type "${1}"
}

get_file_type(){
    file -b "${1}"|awk '{print $1}'
}

dir_sizes() {
    # Report first params directory sizes in human readable format
    #shellcheck disable=SC2230,SC2155
    local ls=$(which ls) du=$(which du)
    if [[ -x "${ls}" && -x "${du}" ]]; then
	for d in $( "${ls}" --directory "${1-${HOME}}"/* ); do
	    if [[ -d "${d}" ]]; then
		"${du}" -hs "${d}"
	    fi
	done
    fi
}

lsbin() {
    # https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
    # The directories in $PATH are separated by ":", so we split by it to get individual directories
    for pdir in $(echo "$PATH" | tr ":" "\n");do
	# We `find` all files in the directory which are executable and print the filename
	find "$pdir" -maxdepth 1 -executable -type f -printf "%f "
    done
    printf "\n"
}
