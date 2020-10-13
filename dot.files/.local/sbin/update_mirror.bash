#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096,SC2155
#

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
readonly sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

main() {
    
    local -ar nicec=( "nice" "-n" "19" ) \
	  rsncm=( "rsync" "--verbose" "--recursive" "--times" "--delete" "--exclude=*/msoft/*" )

    local dtmnt="/mnt/data/Documents" elmnt="/mnt/el/Documents"

    if [[ -d "${dtmnt}" && -d "${elmnt}" ]]; then
	"${nicec[@]}" "${rsncm[@]}" "${dtmnt}"/* "${elmnt}"
    else
	echo -ne "${sbn}: ${dtmnt} or ${elmnt} not found\n" >&2
	return 1
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
