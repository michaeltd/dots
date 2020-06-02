#!/usr/bin/env bash
#
# ~/bin/cronjobs.bash
# gather cronjobs for use with a familiar environment (/bin/bash)

#shellcheck disable=SC2155
declare -r usage="Usage: ${BASH_SOURCE[0]##*/} -(-a)larm | -(-b)ackup"

alarm() {
    echo -ne " -- ${FUNCNAME[0]} --\n"
    cvlc --random \
	 file:///mnt/data/Documents/Music/Stanley-Clarke/ \
	 file:///mnt/data/Documents/Music/Marcus-Miller/ \
	 file:///mnt/data/Documents/Music/Jaco-Pastorius/ \
	 file:///mnt/data/Documents/Music/Esperanza-Spalding/ \
	 file:///mnt/data/Documents/Music/Mark-King/Level-Best/
}

backup() {
    ~/sbin/update_backups.bash -f ~/".crontabbkps" -t "/mnt/el/Documents/BKP/LINUX/paperjam" -k "tsouchlarakis@gmail.com"
    ~/sbin/update_cleanup.bash -b "/mnt/el/Documents/BKP/LINUX/paperjam" -k 2
}

crontab() {
    if [[ -z "${1}" ]]; then
	echo "${usage}" >&2; exit 1
    else
	while [[ -n "${1}" ]]; do
	    case "${1}" in
		"-a"|"--alarm") alarm;;
		"-b"|"--backup") backup;;
		*) echo "${usage}" >&2; exit 1;;
            esac
            shift
	done
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && crontab "${@}"
