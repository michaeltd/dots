#!/usr/bin/env bash
#
# ~/sbin/cleanup_bkps.bash - de-clutter backups
# This will work for any directory containing *.tar.gz* backups (eg: name.tar.gz, name.tar.gz.pgp)
# that have an epoch date field in their filename seperated by periods(.) (eg: 190326.1553569476.enc.tar.gz.pgp)
#
#shellcheck source=/dev/null

set -euo pipefail
IFS=$'\t\n'

main() {

    echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

    local backup_dir="/mnt/el/Documents/BKP/LINUX" days2keep="14" remove_backups="1" nothing2do="0"

    # Source explicitly for non interactive shells.
    srcspath="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")/.bashrc.d/.stdlib"

    while [[ -n "${*}" ]]; do
	case "${1}" in
	    "-b"|"--bkpdir") shift; local backup_dir="${1}";;
	    "-s"|"--simulate") local remove_backups="0";;
	    "-k"|"--keep") shift; local days2keep="${1}";;
	    "-d"|"--debug") set -x;;
	    *) echo -ne "Usage: ${BASH_SOURCE[0]##*/} [-(-b)kpdir /backups/directory/] [-(-s)imulate] [-(-k)eep # (int days)] [-(-d)ebug]\n" >&2; return 1;;
	esac
	shift
    done

    local -ra sources=( "${srcspath}/"*.bash ) backups=( "${backup_dir}"/*.tar.gz* )
    
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
	if [[ "$(epochdd "$(max "${dts[@]}")" "${dts[y]}")" -ge "${days2keep}" ]]; then
	    nothing2do="1"
	    if [[ "$(lastdayofmonth "@${dts[y]}")" == "$(date +%d --date="@${dts[y]}")" ]]; then
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

    [[ "${nothing2do}" -eq "0" ]] && echo "Nothing left to do!" >&2
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
