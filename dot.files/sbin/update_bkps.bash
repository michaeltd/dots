#!/usr/bin/env bash
#
# ~/sbin/update_bkps.bash
#
# Configure bkp jobs with ~/.bkp.inc.(enc|cmp).job files
# (enc.job files will be encrypted,
# cmp.job files will be compressed)
# Prereq's you'll need for this to work:
# 0) add your users public key ($RCPNT) to root's keyring.
#    Root access is required for system wide backups.
# 1) ~/.bkp.inc.(cmp|enc).job_desc
# 2) ~/.bkp.exc (optional)
# 3) Update bkpto(where to bkp) bkpfrom(user to read files from) and recipient(pubkey to encrypt to).
#    Or call script with parameters: sudo update_bkps.bash -f username -t /my/bkps -k mykey@name.org
# 4) Profit
# .bkp.inc.* file name explanation:
# /home/paperjam/.bkp.inc.enc.job
#        1        2    3   4   5 
# 1) This part will be given by your [-(-f)rom] switch (default paperjam)
#    The script will use it as a starting point to search for .bkp.inc.* files
# 2 & 3) In .bkp.inc.* files we will store the job definitions
# 4) This part should be aither *.enc.* or *.cmp.*.
#    enc file definitions will get encrypted,
#    cmp file definitions will get compressed.
# 5) The last part is a job short description,
#    It will end up in the resulting *.pgp or *.tar.gz files,
#    so we know what we're dealing with at a quick glance.
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
	    *) echo -ne "Usage: sudo $(basename "${BASH_SOURCE[0]}") [-(-t)o /backup/to/] [-(-f)rom username] [-(-k)ey some@email.org] [-(-d)ebug]\n" >&2; return 1;;
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

    # Some sanity checking ...
    [[ ! -d "${BKPTO}" ]] && echo -ne "${BKPTO} not found.\n" >&2 && return 1
    [[ ! -d "/home/${BKPFROM}" ]] && echo -ne "/home/${BKPFROM} not found.\n" >&2 && return 1
    [[ -z "${INC[0]}" ]] && echo -ne "No job file definitions found.\nNothing left to do!" >&2 && return 1
    [[ "${EUID}" -ne "0" ]] && echo -ne "Root access requirements not met.\n" >&2 && return 1

    for ((i = 0; i < ${#INC[*]}; i++ )); do
	[[ ${INC[i]} =~ (enc|cmp) ]] && local FUNC2DO="${BASH_REMATCH[1]}"
	local ARCHEXT="${INC[i]##*.}.tar.gz"
	case "${FUNC2DO}" in
	    "cmp")
		local CMPFL="${BKPTO}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHEXT}"
		#shellcheck disable=SC2086,SC2046
		time "${NICEC[@]}" "${TARCM[@]}" "--file" "${CMPFL}" $(cat ${INC[i]})
		;;
	    "enc")
		local ENCFL="${BKPTO}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHEXT}.pgp"
		#shellcheck disable=SC2086,SC2046
		time "${NICEC[@]}" "${TARCM[@]}" $(cat ${INC[i]}) | "${GPG2C[@]}" "${ENCFL}" "--encrypt"
		;;
	    *)
		echo -ne "Error in ${INC[i]} file name.\nIt needs a '*.enc|cmp.*' part in it.\n" >&2
	esac
    done
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
