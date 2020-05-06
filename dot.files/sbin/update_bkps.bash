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
readonly BKPTO="/mnt/el/Documents/BKP/LINUX" BKPFROM="paperjam" RCPNT="tsouchlarakis@gmail.com"

echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

declare -ra INC=( $($(type -P ls) /home/${BKPFROM}/.bkp.include.*) )

readonly EXC="/home/${BKPFROM}/.bkp.exclude"

# Full path executables, no aliases
declare -ra \
        NICEC=( "$(type -P nice)" "-n" "19" ) \
        TARCM=( "$(type -P tar)" "--create" "--gzip" "--exclude-from=${EXC}" \
		"--exclude-backups" "--one-file-system" ) \
        GPG2C=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" "--recipient" \
                "${RCPNT}" "--trust-model" "always" "--output" )

declare -r DT="$(date +%y%m%d)" TM="$(date +%H%M)" EP="$(date +%s)"

for BKP in "${INC[@]}"; do
    declare -a BKPS2DO+=( "${BKP##*.}" )
    declare -a ARCHEXT+=( "${BKP##*.}.tar.gz" )
done

if [[ -d "${BKPTO}" && "${EUID}" -eq "0" ]]; then
    for ((i = 0; i < ${#INC[*]}; i++ )); do
	if [[ ${BKPS2DO[i]} == "enc" ]]; then
	    ARCFL="${BKPTO}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHEXT[i]}"
	    #shellcheck disable=SC2086
	    time "${NICEC[@]}" "${TARCM[@]}" "--file" "${ARCFL}" $(cat ${INC[i]})
	else
	    ENCFL="${BKPTO}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHEXT[i]}.pgp"
	    #shellcheck disable=SC2086
	    time "${NICEC[@]}" "${TARCM[@]}" $(cat ${INC[i]}) | "${GPG2C[@]}" "${ENCFL}" "--encrypt"
	fi
    done
else
    echo -ne "${BKPTO} not found or root access requirements not met.\n" >&2
    exit 1
fi
