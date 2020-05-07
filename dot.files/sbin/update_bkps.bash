#!/usr/bin/env bash
#
# ~/sbin/update_bkps.bash
#
# Configure backups with ~/.bkp.inc.(enc|cmp).job definition files
# Prereq's you'll need for this to work:
# 0) add your users public key ($RCPNT) to root's keyring.
#    Root access is required for system wide backups.
# 1) ~/.bkp.inc.(cmp|enc).job_desc
# 2) ~/.bkp.exc (optional)
# 3) Update $bkpto(where to bkp), $bkpfrom(user to read files from) and $rcpnt(pubkey to encrypt to).
#    Or call script with parameters: sudo update_bkps.bash -f username -t /my/bkps -k some@key.org
# 4) Profit
# .bkp.inc.* file name explanation:
# /home/paperjam/.bkp.inc.enc.job
#        1        2    3   4   5 
# 1) This part will be given by your [-(-f)rom] switch (default paperjam)
#    The script will use it as a starting point to search for .bkp.inc.* files
#    The reason this var needs to be hardcoded or switched is so you can run
#    this script from cronjobs.
# 2&3) .bkp.inc.* will be the search term for the definitions array.
# 4) This part should be aither *.enc.* or *.cmp.*.
#    enc file definitions will result in encrypted backups,
#    cmp file definitions will result in compressed backups.
# 5) The last part is a job short description,
#    It will end up in the resulting *.pgp or *.tar.gz files
#    so you know what you're dealing with at a quick glance.
# Example ~/.bkp.inc.*.* file contents:
# /home/paperjam/git/.
# /home/paperjam/Documents/.
# Example ~/.bkp.exc file contents:
# */.git/*
# */.github/*
# */node_modules/*
# You can ommit exlude file safely

main() {
    echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"
    # Some defaults
    local BKPTO="/mnt/el/Documents/BKP/LINUX" BKPFROM="paperjam" RCPNT="tsouchlarakis@gmail.com"

    while [[ -n "${1}" ]]; do
	case "${1}" in
	    "-t"|"--to") shift; BKPTO="${1}";;
	    "-f"|"--from") shift; BKPFROM="${1}";;
	    "-k"|"--key") shift; RCPNT="${1}";;
	    "-d"|"--debug") set -x;;
	    *) echo -ne "Usage: sudo $(basename "${BASH_SOURCE[0]}") [-(-t)o /backup/to/] [-(-f)rom username] [-(-k)ey some@key.org] [-(-d)ebug]\n" >&2; return 1;;
	esac
	shift
    done

    #shellcheck disable=SC2207
    local -ra INC=( $($(type -P ls) /home/${BKPFROM}/.bkp.inc.*) )
    [[ -r "/home/${BKPFROM}/.bkp.exc" ]] && local -r EXC="/home/${BKPFROM}/.bkp.exc"
    local -r DT="$(date +%y%m%d)" TM="$(date +%H%M)" EP="$(date +%s)"
    
    # Full path executables, no aliases
    local -ra \
	  NICEC=( "$(type -P nice)" "-n" "19" ) \
	  TARCM=( "$(type -P tar)" "--create" "--gzip" "$([[ -n "${EXC}" ]] && echo -n "--exclude-from=${EXC}")" "--exclude-backups" "--one-file-system" ) \
	  GPG2C=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" "--recipient" "${RCPNT}" "--trust-model" "always" "--output" )

    # Sanity checks ...
    [[ ! -d "${BKPTO}" ]] && echo -ne "${BKPTO} not found.\n" >&2 && return 1
    [[ ! -d "/home/${BKPFROM}" ]] && echo -ne "/home/${BKPFROM} not found.\n" >&2 && return 1
    [[ -z "${INC[0]}" ]] && echo -ne "No job file definitions found.\nNothing left to do!" >&2 && return 1
    [[ "${EUID}" -ne "0" ]] && echo -ne "Root access requirements not met.\n" >&2 && return 1

    cmp() {
	#shellcheck disable=SC2086,SC2046
	time "${NICEC[@]}" "${TARCM[@]}" "--file" "${BKPTO}/${HOSTNAME}.${DT}.${TM}.${EP}.${1}" $(cat "${2}")
    }

    enc() {
	#shellcheck disable=SC2086,SC2046
	time "${NICEC[@]}" "${TARCM[@]}" $(cat "${2}") | "${GPG2C[@]}" "${BKPTO}/${HOSTNAME}.${DT}.${TM}.${EP}.${1}.pgp" "--encrypt"
    }

    for ((i = 0; i < ${#INC[*]}; i++ )); do
	[[ ${INC[i]} =~ (enc|cmp) ]] && "${BASH_REMATCH[1]}" "${INC[i]##*.}.tar.gz" "${INC[i]}"
    done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
