#!/usr/bin/env bash
#
# ~/sbin/update_bkps.bash
#
# Configure backups with ~/.backup_include.(encrypt|compress).job_name definition files

# Prereq's you'll need for this to work:
# 0) add your users public key ($RECIPIENT) to root's keyring.
#    Root access is required for system wide backups.
# 1) ~/.backup_include.(compress|encrypt).job_name
# 2) ~/.backup_exclude (optional)
# 3) Update $DEFINITIONS(user to read files from), $BACKUP_TO(where to backup) and $RECIPIENT(pubkey to encrypt to).
#    Or call script with parameters: update_bkps.bash -f /path_to_defs -t /backups/folder -k some@key.org

# .backup_include.* file name explanation:
# /home/paperjam/.backup_include.*.job_name
#        1              2        3    4
# 1) This part will be given by your [-(-f)rom] switch (default /home/paperjam)
#    The script will use it as a starting point to search for all .backup_* related files.
#    The reason this var needs to be hardcoded or switched in is so you can run
#    this script from cronjobs.
# 2) .backup_include.* will be the search term for the definitions array.
# 4) This part should be aither *.encrypt.* or *.compress.*.
#    encrypt file definitions will result in encrypted tarballs,
#    compress file definitions will result in unencrypted tarballs.
# 5) The fifth and last part serves as the jobs name.
#    It will end up in the resulting *.pgp or *.tar.gz file name
#    so you know what you're dealing with at a quick glance.

# Example ~/.backup_include.*.* file contents:
# /home/paperjam/git/.
# /home/paperjam/Documents/.

# Example ~/.backup_exclude file contents:
# */.git/*
# */.github/*
# */node_modules/*

# You can ommit exlude file safely

main() {
    echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"
    # Some defaults
    local DEFINITIONS="/home/paperjam" BACKUP_TO="/mnt/el/Documents/BKP/LINUX" RECIPIENT="tsouchlarakis@gmail.com"

    while [[ -n "${1}" ]]; do
	case "${1}" in
	    "-f"|"--from") shift; DEFINITIONS="${1}";;
	    "-t"|"--to") shift; BACKUP_TO="${1}";;
	    "-k"|"--key") shift; RECIPIENT="${1}";;
	    "-d"|"--debug") set -x;;
	    *) echo -ne "Usage: $(basename "${BASH_SOURCE[0]}") [-(-f)rom /path/to/defs] [-(-t)o /path/to/backups] [-(-k)ey some@key.org] [-(-d)ebug]\n" >&2; return 1;;
	esac
	shift
    done
    #shellcheck disable=SC2207
    local -ra INCLUDES=( $($(type -P ls) "${DEFINITIONS}"/.backup_include.* 2>/dev/null) )
    [[ -r "${DEFINITIONS}/.backup_exclude" ]] && local -r EXCLUDE="${DEFINITIONS}/.backup_exclude"
    local -r JOB_FN="${BACKUP_TO}/${HOSTNAME}.$(date +%y%m%d.%H%M.%s)"

    # Full path executables, no aliases
    local -ra \
	  NICE_CMD=( "$(type -P nice)" "-n" "19" ) \
	  TAR_CMD=( "$(type -P tar)" "--create" "--gzip" "$([[ -n "${EXCLUDE}" ]] && echo -n "--exclude-from=${EXCLUDE}")" "--exclude-backups" "--one-file-system" ) \
	  PGP_CMD=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" "--recipient" "${RECIPIENT}" "--trust-model" "always" "--output" )

    # Sanity checks ...
    [[ ! -d "${DEFINITIONS}" ]] && echo -ne "${DEFINITIONS} not found.\n" >&2 && return 1
    [[ ! -d "${BACKUP_TO}" ]] && echo -ne "${BACKUP_TO} not found.\n" >&2 && return 1
    [[ -z "${INCLUDES[*]}" ]] && echo -ne "No job file definitions found.\nNothing left to do!" >&2 && return 1
    [[ "${EUID}" -ne "0" ]] && echo -ne "Root access requirements not met.\n" >&2 && return 1

    compress() {
	#shellcheck disable=SC2086,SC2046
	time "${NICE_CMD[@]}" "${TAR_CMD[@]}" "--file" "${JOB_FN}.${1##*.}.tar.gz" $(cat "${1}")
    }

    encrypt() {
	#shellcheck disable=SC2086,SC2046
	time "${NICE_CMD[@]}" "${TAR_CMD[@]}" $(cat "${1}") | "${PGP_CMD[@]}" "${JOB_FN}.${1##*.}.tar.gz.pgp" "--encrypt"
    }

    for INCLUDE in "${INCLUDES[@]}"; do
	if [[ ${INCLUDE} =~ (compress|encrypt) ]]; then
	    "${BASH_REMATCH[1]}" "${INCLUDE}"
	else
	    echo "$(basename "${INCLUDE}") does not appear to have 'compress' or 'encrypt' in its name." >&2
	fi
    done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
