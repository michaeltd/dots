#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash source=/dev/null disable=SC1008,SC2096,SC2155,SC2207,SC2206,SC2154
#
# This will work for any directory containing ${HOSTNAME}.*.tar.gz* backups (eg: tuxbox.name.tar.gz, tuxbox.name.tar.gz.pgp)
# that have an epoch date field in their filename (eg: tuxbox.190326.1553569476.enc.tar.gz.pgp).
#

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

main() {
    local backup_dir="/mnt/data/Documents/bkp/linux" days2keep="3" nothing2bdone="1"
    local myusage="
    Usage: ${sbn} [-(-b)ackups /backups/directory/] [-(-k)eep #] [-(-d)ebug]

    -(-b)ackups 	      backups location, eg: /backups/directory/
    -(-k)eep # 		      backups to keep in days, eg:7
    -(-d)ebug		      display lots of letters.
"

    log2err() { echo -ne "${sbn}: ${*}\n" >&2; }
    
    while [[ -n "${*}" ]]; do
	case "${1}" in
	    -b|--backups) shift; local backup_dir="${1}";;
	    -k|--keep) shift; local days2keep="${1}";;
	    -d|--debug) set -x;;
	    *) log2err "${myusage}"; return 1;;
	esac
	shift
    done
    # Source explicitly for non interactive shells.
    srcspath="${sdn}/../../.bashrc.d/stdlib"

    local -ra sources=( "${srcspath}"/*.bash ) backups=( "${backup_dir}/${HOSTNAME}."*.tar.gz* )

    for src in "${sources[@]}"; do
	source "${src}" || { log2err "${src} not readable."; return 1; }
    done

    [[ -e "${backups[0]}" ]] || { log2err "No backups found!"; return 1; }

    for x in "${!backups[@]}"; do
	local bfn="${backups[x]##*/}"
	if [[ "${bfn}" =~ ([0-9]{10}) ]]; then
	    local fns[x]="${bfn}"
	    local dts[x]="${BASH_REMATCH[1]}"
	fi
    done

    for (( y = 0; y < ${#fns[@]}; y++ )); do
	local -a name_parts=( $(split "${fns[y]}" '.') )
	local -a same_job_backups=( ${backup_dir}/${HOSTNAME}.??????.????.??????????.${name_parts[4]}.tar.gz* )
	if [[ "$(epoch_diff "$(max "${dts[@]}")" "${dts[y]}")" -ge "${days2keep}" && "${#same_job_backups[@]}" -gt "${days2keep}" ]]; then
	    nothing2bdone="0"
	    if [[ "$(last_dom "@${dts[y]}")" == "$(date --date="@${dts[y]}" +%d)" ]]; then
		mkdir -vp "${backup_dir}/bkp" && cp -v "${backup_dir}/${fns[y]}" "${backup_dir}/bkp/${fns[y]}"
	    fi
	    rm -v "${backup_dir}/${fns[y]}"
	fi
    done
    [[ "${nothing2bdone}" -eq "1" ]] && log2err "It seems there's nothing to be done!"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
