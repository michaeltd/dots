#!/usr/bin/env bash
#
# r/unixporn

set -euo pipefail
IFS=$'\t\n'

xlock() {
    if type -P i3lock &>/dev/null; then
	local -r image="/tmp/${$}.i3lock.png" blurtype="0x05"
	scrot -z "${image}"
	convert "${image}" -blur "${blurtype}" "${image}"
	i3lock -i "${image}"
	rm "${image}"
    elif type -P xscreensaver-command &>/dev/null; then
	xscreensaver-command -lock
    else
	printf "No suitable screen locker found!\n" >&2
	return 1
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && \
    scrptnm="$(basename "$(realpath "${BASH_SOURCE[0]}")")" && \
    "${scrptnm%.*}" "${@}"
