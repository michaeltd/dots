#!/bin/bash
#
# ~/bin/cronjobs.bash
# gather cronjobs for use with a familiar environment (/bin/bash)

__usage="Usage: $(basename "${BASH_SOURCE[0]}") -(-a)larm | -(-b)ackup"

alarm() {
    cvlc --random file:///mnt/data/Documents/Music/Stanley-Clarke/ file:///mnt/data/Documents/Music/Marcus-Miller/ file:///mnt/data/Documents/Music/Jaco-Pastorius/ file:///mnt/data/Documents/Music/Esperanza-Spalding/ file:///mnt/data/Documents/Music/Mark-King/Level\ Best/
}

backup() {

    local bkpt="/mnt/el/Documents/BKP/LINUX/${USER}" bkpd="${HOME}" \
          xcldf="${HOME}/.bkp.exclude" rcpnt="tsouchlarakis@gmail.com"

    local outfl="${bkpt}/${USER}.$(date +%y%m%d).$(date +%H%M%S).$(date +%s).tar.gz.pgp" \
          LS="$(type -P ls)"

    # Just in case
    mkdir -p "${bkpt}"

    if [[ -d "${bkpt}" ]]; then
	# Bkp & encrypt things.
	nice -n 9 tar -cz --exclude-from="${xcldf}" \
	     --exclude-backups --one-file-system "${bkpd}"/. \
            | gpg2 --batch --yes --quiet --recipient "${rcpnt}" \
		   --trust-model always --output "${outfl}" --encrypt

	# Keep two most recent bkps
	~/sbin/cleanup_bkps.sh --directory "${bkpt}" --keep 2
    else
	echo "FATAL: Backup location: \"${bkpt}\" is not a directory"
	exit 1
    fi
}

main() {
    if [[ -z "${1}" ]]; then
	echo "${__usage}" >&2; exit 1
    else
	while [[ -n "${1}" ]]; do
	    case "${1}" in
		"-a"|"--alarm") alarm;;
		"-b"|"--backup") backup;;
		*) echo "${__usage}" >&2; exit 1;;
            esac
            shift
	done
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi
