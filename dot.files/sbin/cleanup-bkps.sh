#!/bin/sh
#
# ~/sbin/cleanup-bkps.sh - de-clutter backups
#
# This will work for any directory containing *tar.gz* backups
# (eg: name.tar.gz, name.tar.gz.asc)
# that have a YYMMDD formated date field in their filename seperated by periods(.)
# (eg: 190326.1553569476.enc.tar.gz.asc)

# BacKuPs Directory => BKPD
BKPD="/mnt/el/Documents/BKP/LINUX"

# BacKuPs to Keep => BKPK (in days)
BKPK="14"

# BacKuPs Remove => BKPR (1 remove, 0 don't)
BKPR="1"

printf " -- %s --\n" "$(basename ${BASH_SOURCE[0]})"

if [[ -n "${1}" ]]
then

  while [[ -n "${1}" ]]
  do

    case "${1}" in

      "--directory")

        shift; BKPD="${1}"
        ;;
      "--simulate")

        BKPR="0"
        ;;
      "--remove")

        BKPR="1"
        ;;
      *)

        printf "Usage: $(basename ${BASH_SOURCE[0]}) [--directory /backups/directory/] ([--simulate]|[--remove (default)])\n" >&2

        exit 1
        ;;
    esac

    shift
  done
fi

# No root access
# (( EUID != 0 )) && printf "privileged access requirements not met.\n" >&2 && exit 1

# No backups directory
[ ! -d "${BKPD}" ] && printf "${BKPD} is not a directory.\n" >&2 && exit 1

# Load explicitly for non interactive shells.
source /home/paperjam/.bashrc.d/.stdl/time.sh # for datedd()
source /home/paperjam/.bashrc.d/.stdl/string.sh # for split()
source /home/paperjam/.bashrc.d/.stdl/math.sh # for max()

FILES=( $($(which ls) -t1 ${BKPD}/*tar.gz* 2> /dev/null) )

# File loop to gather stats
for (( x = 0; x < ${#FILES[@]}; x++ ))
do

  BFN="$(basename ${FILES[$x]})"

  # Name loop to extract dates
  for PART in $(split ${BFN} .)
  do

    # 6 digits field check (six digit dates eg: 190508)
    if [[ "${PART}" =~ ^[0-9]{6}$ ]]
    then

      FNS+=( "${BFN}" )
      DTS+=( "${PART}" )
    fi
  done
done

# File NameS loop to execute on stats
for (( y = 0; y < ${#FNS[@]}; y++ ))
do

  if (( $(datedd $(max ${DTS[@]}) ${DTS[$y]}) >= BKPK ))
  then

    printf "${bold}${blue}will remove:${reset} %s, created: %s.\n" \
           "${red}${FNS[$y]}${reset}" \
           "${underline}${green}$(date -d ${DTS[$y]} +%Y/%m/%d_%H:%M:%S)${reset}${end_underline}"

    printf "${bold}rm -v %s${reset}: " "${red}${FNS[$y]}${reset}"

    (( BKPR == 0 )) && printf "\n" || rm -v "${BKPD}/${FNS[$y]}"
  fi
done
