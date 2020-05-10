#!/usr/bin/env bash
#
# ~/sbin/cleanup_bkps.bash - de-clutter backups
# This will work for any directory containing *.tar.gz* backups (eg: name.tar.gz, name.tar.gz.pgp)
# that have an epoch date field in their filename seperated by periods(.) (eg: 190326.1553569476.enc.tar.gz.pgp)
#
#shellcheck source=/dev/null

main() {
    
    echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"

    backup_dir="/mnt/el/Documents/BKP/LINUX" days2keep="14" remove_backups="0" nothing2do="0"

    # Source explicitly for non interactive shells.
    srcspath="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")/.bashrc.d/.stdlib"

    local -ra srcs=( "${srcspath}/time.bash" \
			   "${srcspath}/string.bash" \
			   "${srcspath}/math.bash" )

    while [[ -n "${1}" ]]; do
	case "${1}" in
	    "-b"|"--bkpdir") shift; backup_dir="${1}";;
	    "-s"|"--simulate") remove_backups="1";;
	    "-k"|"--keep") shift; days2keep="${1}";;
	    "-d"|"--debug") set -x;;
	    *) echo -ne "Usage: ${BASH_SOURCE[0]##*/} [-(-b)kpdir /backups/directory/] [-(-s)imulate] [-(-k)eep # (int, days. default: 14)] [-(-d)ebug (default: off)]\n" >&2; return 1;;
	esac
	shift
    done

    # No root access or No backups directory
    # (( EUID != 0 )) && echo -ne "privileged access requirements not met.\n" >&2 && return 1
    [[ ! -d "${backup_dir}" ]] && echo -ne "${backup_dir} is not a directory.\n" >&2 && return 1

    if [[ -d "${srcspath}" ]]; then
	for src in "${srcs[@]}"; do
	    if [[ -r "${src}" ]]; then
		source "${src}"
	    else
		echo -ne "${src} not readable.\n" >&2
		return 1
	    fi
	done
    else
	echo -ne "${srcspath} not found.\n" >&2
	return 1
    fi

    #shellcheck disable=SC2207
    files=( "${backup_dir}"/*.tar.gz* )

    for (( x = 0; x < ${#files[@]}; x++ )); do
	bfn="${files[x]##*/}"
	for part in $(split "${bfn}" .); do
	    if [[ "${part}" =~ ^[0-9]{10}$ ]]; then
		fns[x]="${bfn}"
		dts[x]="${part}"
	    fi
	done
    done

    for (( y = 0; y < ${#fns[@]}; y++ )); do
	if [[ "$(epochdd "$(max "${dts[@]}")" "${dts[y]}")" -ge "${days2keep}" ]]; then
	    nothing2do="1"
	    if [[ "${remove_backups}" -eq "1" ]]; then
		if [[ "$(lastdayofmonth "@${dts[y]}")" == "$(date +%d --date="@${dts[y]}")" ]]; then
		    #shellcheck disable=SC2154
		    echo "Not running: ${bold}'mkdir -vp ${backup_dir}/bkp && cp -v ${backup_dir}/${fns[y]} ${backup_dir}/bkp/${fns[y]}'${reset}"
		fi
		echo "Not running: ${bold}'rm -v ${backup_dir}/${fns[y]}'${reset}"
	    else
		if [[ "$(lastdayofmonth "@${dts[y]}")" == "$(date +%d --date="@${dts[y]}")" ]]; then
		    mkdir -vp "${backup_dir}/bkp" && cp -v "${backup_dir}/${fns[y]}" "${backup_dir}/bkp/${fns[y]}"
		fi
		rm -v "${backup_dir}/${fns[y]}"
	    fi
	fi
    done

    [[ "${nothing2do}" -eq "0" ]] && echo "Nothing left to do!" >&2
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
