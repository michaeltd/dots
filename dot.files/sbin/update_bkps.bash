#!/usr/bin/env bash
#
# ~/sbin/update_bkps.bash
#
# Configure bkp jobs with ~/.bkp.include.job files
#
# Prereq's you'll need for this to work:
#
# 0) add your users public key ($RCPNT) to root's keyring
# 1) ~/.bkp.include.myawesomebkpjob
# 2) ~/.bkp.exclude
# fill out above files with include and exclude rules respectively
# 3) Update bkpto(where to bkp) bkpfrom(user to read files from) and recipient(pubkey to encrypt to).
# 4) Profit
#
# Example ~/.bkp.include.usr file:
#
# /home/paperjam/git/.
# /home/paperjam/Documents/.
#
# Example ~/.bkp.exclude file:
#
# */.git/*
# */.github/*
# */node_modules/*
#

main(){
    local -r BKPTO="/mnt/el/Documents/BKP/LINUX" BKPFROM="paperjam" RCPNT="tsouchlarakis@gmail.com"

    echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"
    #shellcheck disable=SC2207
    local -ra INC=( $($(type -P ls) /home/${BKPFROM}/.bkp.include.*) )

    local -r EXC="/home/${BKPFROM}/.bkp.exclude"

    # Full path executables, no aliases
    local -ra \
        NICEC=( "$(type -P nice)" "-n" "19" ) \
        TARCM=( "$(type -P tar)" "--create" "--gzip" "--exclude-from=${EXC}" \
	    "--exclude-backups" "--one-file-system" ) \
        GPG2C=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" "--recipient" \
	    "${RCPNT}" "--trust-model" "always" "--output" )

    local -r DT="$(date +%y%m%d)" TM="$(date +%H%M)" EP="$(date +%s)"

    for BKP in "${INC[@]}"; do
	local -a BKPS2DO+=( "${BKP##*.}" )
	local -a ARCHEXT+=( "${BKP##*.}.tar.gz" )
    done

    if [[ -d "${BKPTO}" && "${EUID}" -eq "0" ]]; then
	for ((i = 0; i < ${#INC[*]}; i++ )); do
	    if [[ ${BKPS2DO[i]} == "enc" ]]; then
		local ARCFL="${BKPTO}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHEXT[i]}"
		#shellcheck disable=SC2086,SC2046
		time "${NICEC[@]}" "${TARCM[@]}" "--file" "${ARCFL}" $(cat ${INC[i]})
	    else
		local ENCFL="${BKPTO}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHEXT[i]}.pgp"
		#shellcheck disable=SC2086,SC2046
		time "${NICEC[@]}" "${TARCM[@]}" $(cat ${INC[i]}) | "${GPG2C[@]}" "${ENCFL}" "--encrypt"
	    fi
	done
    else
	echo -ne "${BKPTO} not found or root access requirements not met.\n" >&2
	return 1
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "${@}"
