#
# various functions
#shellcheck shell=bash disable=SC2207,SC2086,SC2009,SC2230,SC2154,SC2155,SC2068,SC2004

# SCRAPPAD ====================================================================

# allemojis() {
#     for (( x = 2600; x <= 2700; x++ )); do
# 	echo -n -e " \u${x}"
# 	sleep .1
#     done
#     echo
# }

case_randomizer() {
    [[ -z "${1}" ]] && \
	echo -ne "
	Name: ${FUNCNAME[0]}
	Description: Randomize letter case of arguments
	Example: ${FUNCNAME[0]} Hello World\n" >&2 && \
	return 1

    while [[ -n "${1}" ]]; do
	for (( i = 0; i < ${#1}; i++ )); do
	    local ltr="${1:i:1}"
	    (( RANDOM % 2 )) && echo -n "${ltr^}" || echo -n "${ltr,}"
	done
	echo -n " "
	shift
    done
    echo ""
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
    echo -ne "\n $(tput setaf 2)Hello$(tput sgr0) $(tput bold)${USER}$(tput sgr0), today is $(tput setaf 5)$(date '+%A, %B %d, %H:%M')$(tput sgr0)\n\n"
    curl https://wttr.in?0
    printf "\n"
}

# UTILS =======================================================================

purge_hist4() {
    [[ -z "${1}" ]] && \
	echo -ne "\n\tUsage: ${FUNCNAME[0]} expression(s)...\n\tDescription: Removes \"expression\" occurances from ${bh}\n\n" >&2 && \
        return 1

    local -r bh="${HOME}/.bash_history"
    while [[ -n "${1}" ]]; do
	local pre=( $(wc -l "${bh}") )
	sed -i '' -e /${1}/d "${bh}"
	local post=( $(wc -l "${bh}") )
	echo -ne "purged: $(( ${pre[0]} - ${post[0]} )) instances of \"${1}\" from ${bh}\n"
	shift
    done
}

top5cmds() {
    history | awk '{print $2}' | sort | uniq -c | sort -nr | head -n 5
}

command_line_from_pid() {
    ps -aux |grep "${1:-${$}}"|head -n 1|awk -v f=1 -v t=10 '{for(i=1;i<=NF;i++)if(i>=f&&i<=t)continue;else printf("%s%s",$i,(i!=NF)?OFS:ORS)}'
}

is_executable() {
    [[ -z "${1}" ]] && \
	echo -ne "Usage: ${FUNCNAME[0]} programm_handle\n" >&2 && \
	return 1
    type -P "${1}" &>/dev/null
}

srwpi() {
    # Set Random WallPaper Image
    local -r myusage="
    Description: Set a Random WallPaper Image from a directory with images.
    Usage: ${FUNCNAME[0]} images-directory | image-file\n\n" \
	  mypics="${HOME}/Wallpapers"

    if [[ -d "${1}" ]]; then
	feh -rz --bg-scale "${1}"
    elif [[ -f "${1}" ]] && [[ "$(file "${1}")" =~ image ]]; then
	feh --bg-scale "${1}"
    elif [[ -d "${mypics}" ]]; then
	feh -rz --bg-scale "${mypics}"
    else
	echo -ne "${myusage}"
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
	    # local -a srvcs=( "postgresql-12" "mongodb" "apache2" "tomcat" "vsftpd" "sshd" "rsyncd" )
	    type -P postgres &>/dev/null && local -a srvcs+=( "postgresql-12" )
	    type -P apache2 &>/dev/null && local -a srvcs+=( "apache2" )
	    type -P vsftpd &>/dev/null && local -a srvcs+=( "vsftpd" )
	    type -P sshd &>/dev/null && local -a srvcs+=( "sshd" )
	    type -P rsync &>/dev/null && local -a srvcs+=( "rsyncd" )
	else
	    local -a srvcs=( "${@}" )
	    unset "srvcs[0]"
	fi
	for srvc in "${srvcs[@]}"; do
	    sudo rc-service "${srvc}" "${1}"
	done
    }

    lspkgcat() {
	/bin/ls --color "/usr/portage/${1}"
    }

    alias show_deps='emerge -pvc'
fi

show_uptime() {
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

mem_usage() {
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

# End stuff
termproc() {
    if [[ -n "${1}" ]]; then
	pkill -TERM -u "${USER}" "${1}"
    else
	echo -ne "Usage: ${FUNCNAME[0]} process to terminate (sig #15)\n" >&2
	return 1
    fi
}

killproc() {
    if [[ -n "${1}" ]]; then
	pkill -KILL -u "${USER}" "${1}"
    else
	echo -ne "Usage: ${FUNCNAME[0]} process to kill (sig #9)\n" >&2
	return 1
    fi
}

rcm() {
    # (R)un things in the background with (C)ustom niceness and cli switches in a (M)utex kind of way
    # Usage : rcm niceness executable command line arguments
    # Example: rcm 9 conky -qdc ~/.conkyrc
    local thebin="$(command -v "${2}")" thepid="$(pgrep -U "${USER}" -f "${2}")"
    [[ "${#}" -lt "2" ]] && printf "\n\tUsage: %s niceness command [arguments ...]\n\teg: rcm 0 wicd-gtk -t\n\n" "${FUNCNAME[0]}" >&2 && return 1
    [[ -z "${thepid}" && -x "${thebin}" ]] && exec nice -n "${@}" &
}

# NET ==========================================================================

is_port_open() {
    sudo lsof -i TCP:"${1:-443}"
}

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
    if [[ -z "${1}" ]]; then
	printf 'Usage: %s port-number\n' "${FUNCNAME[0]}" >&2
	return 1
    else
	while [[ -n "${1}" ]]; do
	    sudo lsof -niTCP:"${1}" |grep LISTEN
	    shift
	done
    fi
}

# FS ===========================================================================

# Functions to unify archive management in linux CLI environments
compress() {
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
    while [[ -n "${1}" ]]; do
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
	    *.lzma) lzma -d "${1}";;
	    *) echo -ne "\n\tUnknown file extension ${1}.\n\n" >&2;;
	esac
	shift
    done
}

count_lines_4ext() {
    case $# in
	1) find ./ -mount -iname "${1}" -exec wc -l {} +;;
	2) find "${1}" -mount -iname "${2}" -exec wc -l {} +;;
    	*) echo -ne "
    Description: Count lines of files with given extension.
    Usage: ${FUNCNAME[0]} [directory] expression
    Examples: ${FUNCNAME[0]} /my/awesome/project/ *.html
              ${FUNCNAME[0]} *.cpp
              ${FUNCNAME[0]} .*rc\n\n" >&2
	   return 1;;
    esac
}

count_files_4ext() {
    case $# in
	1) find ./ -mount -iname "${1}" | wc -l;;
	2) find "${1}" -mount -iname "${2}" | wc -l;;
	*) echo -ne "
    Description: Count files of given extension.
    Usage: ${FUNCNAME[0]} [directory] expression
    Examples: ${FUNCNAME[0]} /my/awesome/project/ *.html
              ${FUNCNAME[0]} *.cpp
              ${FUNCNAME[0]} .*rc\n" >&2
	return 1;;
    esac
}

s4strInDir() {
    # https://stackoverflow.com/questions/16956810/how-do-i-find-all-files-containing-specific-text-on-linux
    local -r myusage="
    Description: ${FUNCNAME[0]} will search for given string in current (if not given) directory.
    Usage: ${FUNCNAME[0]} search-term [directory]
    Example: ${FUNCNAME[0]} author ./\n\n"
    
    [[ -z "${1}" ]] && \
	{ echo -ne "${myusage}" >&2; return 1; }
    grep -rnw "${2:-./}" -e "${1}"
}

convert_img() {
    local -r myusage="
    Description: ${FUNCNAME[0]} Converts image(s) from - To formats.
    Usage: ${FUNCNAME[0]} from to
    Example: ${FUNCNAME[0]} png jpg
    Requires: Imagemagick.\n\n"

    if type -P convert &>/dev/null && [[ "${#}" -eq "2" ]]; then
	for i in *."${1}"; do
	    convert "${i}" "${i/%.${1}/.${2}}" && rm -i "${i}"
	done
    else
	echo -ne "${myusage}" >&2
	return 1
    fi
}

mkbkp() {
    while [[ -n "${1}" ]]; do
	if [[ ! -r "${1}" ]]; then
	    echo -ne "\tUsage: ${FUNCNAME[0]} files/dirs-to-backup\n\tNot readable file/dir ${1}\n" >&2
	    shift
	    continue
	fi
	compress "${1%%/*}.$(date -u +%s).tgz" "${1}"
	shift
    done
}

get_mime_type() {
    file -b --mime-type "${1}"
}

get_file_type() {
    file -b "${1}" | awk '{print $1}'
}

dir_size() {
    # Report directory size summary (-s), in same fs (-x), in human readable format (-h)
    du -xhs "${1:-.}"
}

# https://stackoverflow.com/questions/4561895/how-to-recursively-find-the-latest-modified-file-in-a-directory
print_newest() {
    [[ -d "${1}" ]] || local dir='.'
    local results=($(find "${1:-${dir}}" -type f -printf '%T@ %p\n' | sort -nr | head -1))
    local stamp="$(date -d "@${results[0]}" +%s)"
    local datim="$(date -d "@${results[0]}" +%F\ %T)"
    local rpath="$(realpath "${results[*]:1}")"
    echo "${stamp} ${datim} \"${rpath}\""
}

print_oldest() {
    [[ -d "${1}" ]] || local dir='.'
    local results=($(find "${1:-${dir}}" -type f -printf '%T@ %p\n' | sort -n | head -1))
    local stamp="$(date -d "@${results[0]}" +%s)"
    local datim="$(date -d "@${results[0]}" +%F\ %T)"
    local rpath="$(realpath "${results[*]:1}")"
    echo "${stamp} ${datim} \"${rpath}\""
}

ls_executables() {
    # https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
    # The directories in $PATH are separated by ":", so we split by it to get individual directories
    for pdir in $(echo "$PATH" | tr ":" "\n"); do
	# We `find` all files in the directory which are executable and print the filename
	find "$pdir" -maxdepth 1 -executable -type f -printf "%f "
    done
    printf "\n"
}

takeass() {
    local -r myusage="
    Usage: ${FUNCNAME[0]} [#delay (in seconds, [0-9])]
    Requires: Imagemagick and ristretto\n\n"
    local -r fn="${HOME}/Pictures/ScreenShot-$(date -u +%s).png"

    if ! type -P import &>/dev/null || \
	    ! type -P ristretto &>/dev/null || \
	    [[ -z "${DISPLAY}" ]]; then
	echo -ne "${myusage}" >&2
	return 1
    fi

    if [[ -n "${1}" ]]; then
	if [[ "${1}" =~ ^[0-9]$ ]]; then
	    for (( i = $1; i >= 0; i-- )); do
		printf "%s " $i
		sleep 1
	    done
	    printf "\n"
	else
	    echo -ne "${myusage}" >&2
	    return 1
	fi
    fi
    import -window root "${fn}" && ristretto "${fn}"
}
