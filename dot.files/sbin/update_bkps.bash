#!/usr/bin/env bash
#
# ~/sbin/update_bkps.bash
# Backup sensitive files, user files, system files.

echo -ne " -- $(basename "${BASH_SOURCE[0]}") --\n"

readonly ELDIR="/mnt/el/Documents/BKP/LINUX" UTB="paperjam"

declare -ra INC=( $($(type -P ls) /home/${UTB}/.bkp.include.*) )

readonly EXC="/home/${UTB}/.bkp.exclude"

readonly RCPNT="tsouchlarakis@gmail.com"

# Full path executables, no aliases
declare -ra \
        NICEC=( "$(type -P nice)" "-n" "19" ) \
        TARCM=( "$(type -P tar)" "--create" "--gzip" "--exclude-from=${EXC}" \
		"--exclude-backups" "--one-file-system" ) \
        GPG2C=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" "--recipient" \
                "${RCPNT}" "--trust-model" "always" "--output" )

declare -r DT="$(date +%Y%m%d)" TM="$(date +%H%M%S)" EP="$(date +%s)"

for BKP in "${INC[@]}"; do
    declare -a BKPS2DO+=( "${BKP: -3}" )
    declare -a ARCHEXT+=( "${BKP: -3}.tar.gz" )
done

if [[ -d "${ELDIR}" && "${EUID}" -eq "0" ]]; then
    for ((i = 0; i < ${#INC[*]}; i++ )); do
	if [[ ${BKPS2DO[i]} == "enc" ]]; then
	    ARCFL="${ELDIR}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHEXT[i]}"
	    #shellcheck disable=SC2086
	    time "${NICEC[@]}" "${TARCM[@]}" "--file" "${ARCFL}" $(cat ${INC[i]})
	else
	    ENCFL="${ELDIR}/${HOSTNAME}.${DT}.${TM}.${EP}.${ARCHEXT[i]}.pgp"
	    #shellcheck disable=SC2086
	    time "${NICEC[@]}" "${TARCM[@]}" $(cat ${INC[i]}) | "${GPG2C[@]}" "${ENCFL}" "--encrypt"
	fi
    done
else
    echo -ne "${ELDIR} not found or root access requirements not met.\n" >&2
    exit 1
fi
