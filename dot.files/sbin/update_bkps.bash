#!/usr/bin/env bash
#
# ~/sbin/update_bkps.bash
#
# Configure backups with ~/.backup_include.(encrypt|compress).job_name definition files

# Prereq's you'll need for this to work:
# 1) ~/.backup_include.(compress|encrypt).job_name
# 2) ~/.backup_exclude (optional)
# 3) Update $definitions (location to read definitions from), $backup_to (where to backup) and $recipient (pubkey to encrypt to).
#    Or call script with parameters: update_bkps.bash -f /path/to/defs -t /path/to/backups -k some@key.org
# NOTE: add your $recipient public key to root's keyring, If you link this to /etc/cron.anything

# .backup_include.*.* file name explanation:
# /path/to/defs/.backup_include.*.job_name
# '            '               ' '        '
#       1              2        3    4
# 1) This part will be given by your [-(-f)rom] switch (default /home/username)
#    The script will use it as a starting point to search for all .backup_* related files.
# 2) .backup_include.* will be the search term for the definitions array.
# 3) This part should be aither *.encrypt.* or *.compress.*.
#    encrypt file definitions will result in encrypted tarballs,
#    compress file definitions will result in unencrypted tarballs.
# 4) The fifth and last part serves as the jobs name.
#    It will end up in the resulting *.pgp or *.tar.gz file name.

# Sample ~/.backup_include.*.* file contents:
# /home/username/git/.
# /home/username/Documents/.

# Sample ~/.backup_exclude file contents:
# */.git/*
# */.github/*
# */node_modules/*

# You can ommit exlude file safely

set -uo pipefail
IFS=$'\t\n'

main() {
    echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"
    local definitions="/home/paperjam" backup_to="/mnt/el/Documents/BKP/LINUX" recipient="tsouchlarakis@gmail.com"

    while [[ -n "${*}" ]]; do
	case "${1}" in
	    "-f"|"--from") shift; definitions="${1}";;
	    "-t"|"--to") shift; backup_to="${1}";;
	    "-k"|"--key") shift; recipient="${1}";;
	    "-d"|"--debug") set -x;;
	    *) echo -ne "Usage: ${BASH_SOURCE[0]##*/} [-(-f)rom /path/to/defs] [-(-t)o /path/to/backups] [-(-k)ey some@key.org] [-(-d)ebug]\n" >&2; return 1;;
	esac
	shift
    done

    local -ra includes=( "${definitions}"/.backup_include.* )
    local -r exclude="${definitions}/.backup_exclude" job_fn="${backup_to}/${HOSTNAME}.$(date +%y%m%d.%H%M.%s)"

    [[ -e "${includes[0]}" ]] || { echo -ne "No job file definitions found.\nNothing left to do!\n" >&2; return 1; }
    [[ -d "${backup_to}" ]] || { echo -ne "${backup_to} is not a directory.\n" >&2; return 1; }

    local -ra nice_cmd=( "nice" "-n" "19" ) \
	  tar_cmd=( "tar" "--create" "--gzip" "$([[ -r "${exclude}" ]] && echo -n "--exclude-from=${exclude}")" "--exclude-backups" "--one-file-system" ) \
	  pgp_cmd=( "gpg" "--batch" "--yes" "--quiet" "--recipient" "${recipient}" "--trust-model" "always" "--output" )

    compress() {
	#shellcheck disable=SC2046
	time "${nice_cmd[@]}" "${tar_cmd[@]}" "--file" "${job_fn}.${1##*.}.tar.gz" $(cat "${1}")
    }

    encrypt() {
	#shellcheck disable=SC2046
	time "${nice_cmd[@]}" "${tar_cmd[@]}" $(cat "${1}") | "${pgp_cmd[@]}" "${job_fn}.${1##*.}.tar.gz.pgp" "--encrypt"
    }

    for include in "${includes[@]}"; do
	[[ ${include} =~ (compress|encrypt) ]] && "${BASH_REMATCH[1]}" "${include}"
    done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
