#!/usr/bin/env bash
#
# This will work for any directory containing ${HOSTNAME}.*.tar.gz* backups (eg: tuxbox.name.tar.gz, tuxbox.name.tar.gz.pgp)
# that have an epoch date field in their filename (eg: tuxbox.190326.1553569476.enc.tar.gz.pgp).
#
#shellcheck source=/dev/null

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
#shellcheck disable=SC2155
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

update_cleanup() {
    echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"
    local backup_dir="/mnt/data/Documents/BKP/LINUX" days2keep="3" remove_backups="1" nothing2do="1"
    local myusage="
    Usage: ${BASH_SOURCE[0]##*/} [-(-b)ackups /backups/directory/] [-(-k)eep #] [-(-s)simulate] [-(-d)ebug]

    -(-b)ackups 	      backups location, eg: /backups/directory/
    -(-k)eep # 		      backups to keep in days, eg:7
    -(-s)simulate 	      show what would be done.
    -(-d)ebug		      display lots of letters.
"

    while [[ -n "${*}" ]]; do
	case "${1}" in
	    -b|--backups) shift; local backup_dir="${1}";;
	    -k|--keep) shift; local days2keep="${1}";;
	    -s|--simulate) local remove_backups="0";;
	    -d|--debug) set -x;;
	    *) echo -ne "${myusage}" >&2; return 1;;
	esac
	shift
    done
    # Source explicitly for non interactive shells.
    srcspath="${sdn}/../../.bashrc.d/.stdlib"

    local -ra sources=( "${srcspath}"/*.bash ) backups=( "${backup_dir}/${HOSTNAME}."*.tar.gz* )

    for src in "${sources[@]}"; do
	source "${src}" || { echo -ne "${src} not readable.\n" >&2; return 1; }
    done

    [[ -e "${backups[0]}" ]] || { echo -ne "No backups found!\n" >&2; return 1; }

    for x in "${!backups[@]}"; do
	bfn="${backups[x]##*/}"
	if [[ "${bfn}" =~ ([0-9]{10}) ]]; then
	    fns[x]="${bfn}"
	    dts[x]="${BASH_REMATCH[1]}"
	fi
    done

    for (( y = 0; y < ${#fns[@]}; y++ )); do
	#shellcheck disable=SC2207
	local -a name_parts=( $(split "${fns[y]}" '.') )
	#shellcheck disable=SC2206
	local -a same_job_backups=( ${backup_dir}/${HOSTNAME}.??????.????.??????????.${name_parts[4]}.tar.gz* )
	if [[ "$(epoch_dd "$(max "${dts[@]}")" "${dts[y]}")" -ge "${days2keep}" && "${#same_job_backups[@]}" -gt "${days2keep}" ]]; then
	    nothing2do="0"
	    if [[ "$(last_dom "@${dts[y]}")" == "$(date +%d --date="@${dts[y]}")" ]]; then
	    	#shellcheck disable=SC2154
		if [[ "${remove_backups}" -eq "1" ]]; then
		    mkdir -vp "${backup_dir}/bkp" && cp -v "${backup_dir}/${fns[y]}" "${backup_dir}/bkp/${fns[y]}"
		else
		    echo "Not running: mkdir -vp ${backup_dir}/bkp && cp -v ${backup_dir}/${fns[y]} ${backup_dir}/bkp/${fns[y]}"
		fi
	    fi
	    if [[ "${remove_backups}" -eq "1" ]]; then
		rm -v "${backup_dir}/${fns[y]}"
	    else
		echo "Not running: rm -v ${backup_dir}/${fns[y]}"
	    fi
	fi
    done

    [[ "${nothing2do}" -eq "1" ]] && echo "Nothing left to do!" >&2
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "${sbn%.*}" "${@}"
