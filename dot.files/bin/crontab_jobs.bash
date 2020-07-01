#!/usr/bin/env bash
#
# gather cronjobs for use with a familiar environment (/bin/bash)

alarm() {
    echo -ne " -- ${FUNCNAME[0]} --\n"
    ~/bin/term_music.bash "${1}"
}

backup() {
    ~/sbin/update_backups.bash -f ~/".crontabbkps" -t "/mnt/el/Documents/BKP/LINUX/paperjam" -k "tsouchlarakis@gmail.com"
    ~/sbin/update_cleanup.bash -b "/mnt/el/Documents/BKP/LINUX/paperjam" -k 3
}

crontab_jobs() {
    #shellcheck disable=SC2155
    local -r usage="\n\tUsage: ${BASH_SOURCE[0]##*/} -(-a)larm ([genre]) | -(-b)ackup\n"

    if [[ -n "${1}" ]]; then
	while [[ -n "${1}" ]]; do
	    case "${1}" in
		"-a"|"--alarm") shift; alarm "${1}";;
		"-b"|"--backup") backup;;
		*) echo -ne "${usage}" >&2; return 1;;
            esac
	    shift
	done
    else
	echo -ne "${usage}" >&2; return 1
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && \
    scrptnm="$(basename "$(realpath "${BASH_SOURCE[0]}")")" && \
    "${scrptnm%.*}" "${@}"
