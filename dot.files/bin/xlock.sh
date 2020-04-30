#!/bin/sh
#
# r/unixporn

main() {
    if [ $(type -P i3lock) ]; then
	local -r IMAGE="/tmp/${$}.i3lock.png" BLURTYPE="0x05"
	scrot -z "${IMAGE}"
	convert "${IMAGE}" -blur "${BLURTYPE}" "${IMAGE}"
	i3lock -i "${IMAGE}"
	rm "${IMAGE}"
    elif [ $(type -P xscreensaver-command) ]; then
	xscreensaver-command -lock
    else
	printf "No suitable screen locker found!\n" >&2
	exit 1
    fi
}

main
