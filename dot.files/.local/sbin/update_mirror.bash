#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
#shellcheck disable=SC2155
readonly sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

update_mirror() {
    
    local -ar nicec=( "nice" "-n" "19" ) \
	  rsncm=( "rsync" "--verbose" "--recursive" "--times" "--delete" "--exclude=*/msoft/*" )

    local dtmnt="/mnt/data/Documents" elmnt="/mnt/el/Documents"

    if [[ -d "${dtmnt}" && -d "${elmnt}" ]]; then
	time "${nicec[@]}" "${rsncm[@]}" "${dtmnt}"/* "${elmnt}"
    else
	echo -ne "${sbn}: ${dtmnt} or ${elmnt} not found\n" >&2
	return 1
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "${sbn%.*}" "${@}"
