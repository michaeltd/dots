#!/usr/bin/env bash
#
# ~/sbin/update_bkps.bash
#
# Configure backups with ~/.backup_include.(encrypt|compress).job_name definition files

# Prereq's you'll need for this to work:
# 0) add your users public key ($recipient) to root's keyring.
#    Root access is required for system wide backups.
# 1) ~/.backup_include.(compress|encrypt).job_name
# 2) ~/.backup_exclude (optional)
# 3) Update $definitions(user to read files from), $backup_to(where to backup) and $recipient(pubkey to encrypt to).
#    Or call script with parameters: update_bkps.bash -f /path_to_defs -t /backups/folder -k some@key.org

# .backup_include.*.* file name explanation:
# /home/paperjam/.backup_include.*.job_name
#        1              2        3    4
# 1) This part will be given by your [-(-f)rom] switch (default /home/paperjam)
#    The script will use it as a starting point to search for all .backup_* related files.
#    The reason this var needs to be hardcoded or switched in is so you can run
#    this script from cronjobs.
# 2) .backup_include.* will be the search term for the definitions array.
# 3) This part should be aither *.encrypt.* or *.compress.*.
#    encrypt file definitions will result in encrypted tarballs,
#    compress file definitions will result in unencrypted tarballs.
# 4) The fifth and last part serves as the jobs name.
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
    echo -ne " -- ${BASH_SOURCE[0]##*/} --\n"
    # Some defaults
    local definitions="/home/paperjam" backup_to="/mnt/el/Documents/BKP/LINUX" recipient="tsouchlarakis@gmail.com"

    while [[ -n "${1}" ]]; do
	case "${1}" in
	    "-f"|"--from") shift; definitions="${1}";;
	    "-t"|"--to") shift; backup_to="${1}";;
	    "-k"|"--key") shift; recipient="${1}";;
	    "-d"|"--debug") set -x;;
	    *) echo -ne "Usage: ${BASH_SOURCE[0]##*/} [-(-f)rom /path/to/defs] [-(-t)o /path/to/backups] [-(-k)ey some@key.org] [-(-d)ebug]\n" >&2; return 1;;
	esac
	shift
    done

    #shellcheck disable=SC2207
    local -ra includes=( $("$(type -P ls)" "${definitions}"/.backup_include.*) )
    local -r exclude="${definitions}/.backup_exclude" job_fn="${backup_to}/${HOSTNAME}.$(date +%y%m%d.%H%M.%s)"

    [[ ! -d "${definitions}" ]] && echo -ne "${definitions} is not a directory.\n" >&2 && return 1
    [[ -z "${includes[0]}" ]] && echo -ne "No job file definitions found.\nNothing left to do!" >&2 && return 1
    [[ ! -d "${backup_to}" ]] && echo -ne "${backup_to} is not a directory.\n" >&2 && return 1

    # Full path executables, no aliases
    local -ra nice_cmd=( "$(type -P nice)" "-n" "19" ) \
	  tar_cmd=( "$(type -P tar)" "--create" "--gzip" "$([[ -r "${exclude}" ]] && echo -n "--exclude-from=${exclude}")" "--exclude-backups" "--one-file-system" ) \
	  pgp_cmd=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" "--recipient" "${recipient}" "--trust-model" "always" "--output" )

    compress() {
	#shellcheck disable=SC2086,SC2046
	time "${nice_cmd[@]}" "${tar_cmd[@]}" "--file" "${job_fn}.${1##*.}.tar.gz" $(cat "${1}")
    }

    encrypt() {
	#shellcheck disable=SC2086,SC2046
	time "${nice_cmd[@]}" "${tar_cmd[@]}" $(cat "${1}") | "${pgp_cmd[@]}" "${job_fn}.${1##*.}.tar.gz.pgp" "--encrypt"
    }

    for include in "${includes[@]}"; do
	[[ ${include} =~ (compress|encrypt) ]] && "${BASH_REMATCH[1]}" "${include}"
    done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
