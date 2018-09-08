#!/usr/bin/env bash
#~/bin/wallpaper-rotate.sh
# Simple script to go through a directory of background images as wallpapers in a timely fashion

declare -a WPUSAGE="\n  Script to rotate backgrounds in wm's with out such options,\n  ie NOT kde, gnome or xfce4. \n\n  Usage: $(basename ${BASH_SOURCE[0]}) &\n\n  Alternatively you can execute this file from your startup scripts \n\n  Other options include :\n  $(basename ${BASH_SOURCE[0]}) help - this message,\n  $(basename ${BASH_SOURCE[0]}) add 'dir-path' - add a directory to your image list, \n  $(basename ${BASH_SOURCE[0]}) del 'dir-path' - remove a directory from your image list,\n  $(basename ${BASH_SOURCE[0]}) without options will start rotating images. \n" FEH=( "feh" "--bg-scale" ) WMSETBG=( "wmsetbg" ) FVWM_ROOT=( "fvwm-root" ) FBSETBG=( "fbsetbg" ) BSETBG=( "bsetbg" ) HSETROOT=( "hsetroot" "-fill" ) XSETBG=( "xsetbg" ) XSETROOT=( "xsetroot" "-bitmap" ) BGSRS=( FEH[@] WMSETBG[@] FVWM_ROOT[@] FBSETBG[@] BSETBG[@] HSETROOT[@] XSETBG[@] XSETROOT[@] ) BGSR WPRC="${HOME}/.$(basename ${BASH_SOURCE[0]}).rc" DEFAULT_WAIT="60s" DEFAULT_DIRS=( "${HOME}/Pictures" ) LS=$(which ls 2> /dev/null) WPS=()

if [[ "${BASH_VERSINFO[0]}" -lt "4" ]];then # bash version info check
  printf "For this to work properly you'll need bash major version greater than 4!"
  exit "1"
fi

for (( x=0; x<="${#BGSRS[@]}"; x++ )); do # Find a setter
  bgsrs+="${!BGSRS[$x]:0:1} "
  if [[ -n $(which "${!BGSRS[$x]:0:1}" 2> /dev/null) ]]; then
    BGSR="${x}"
    break # Break on first match.
  fi
done

if [[ -z "${BGSR}" ]]; then # Quit on no setter
  printf "${WPUSAGE}"
  printf "\n  For this to work you need one of :\n  ${bgsrs}\n  installed. None found. Quithing.\n"
  exit "1"
fi

if [[ ! -r "${WPRC}" ]]; then # If there's no readable settings file, write it
  printf "DEFAULT_WAIT=\"60s\"\nDEFAULT_DIRS=( \"${HOME}/Pictures\" )\n" > "${WPRC}"
fi

source "${WPRC}" # and read it

for D in "${DEFAULT_DIRS[@]}"; do # Fill up a WallPaperS list
  PICS=( $("${LS}" -A "${D}") )
  for P in "${PICS[@]}"; do
    FN="${D}/${P}" FE="${P:(-4)}"
    if [[ -f "${FN}" && "${FE,,}" == ".jpg" || "${FE,,}" == ".jpe" || "${FE,,}" == ".png" || "${FE,,}" == ".gif" || "${FE,,}" == ".bmp" ]];then
      WPS+=( "${FN}" )
    fi
  done
done

if [[ -n "${1}" ]];then
  case "${1}" in
    del*|rem*|add*)
      if [[ "${1}" =~ "add" ]];then
        if [[ -d "${2}" ]];then
          DEFAULT_DIRS+=( "${2}" )
        else
          printf "%s Is not a directory\n" "${2}"
          exit "1"
        fi
      else
        for (( i=0; i<="${#DEFAULT_DIRS[@]}"; i++ ));do
          if [[ "${DEFAULT_DIRS[${i}]}" == "${2}" ]]; then
            unset 'DEFAULT_DIRS[i]'
          fi
        done
      fi
      # https://stackoverflow.com/questions/525592/find-and-replace-inside-a-text-file-from-a-bash-command
      sv="DEFAULT_DIRS" rv="DEFAULT_DIRS=( ${DEFAULT_DIRS[@]} )"
      sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}" ;;
    *)
      printf "${WPUSAGE}"
      exit "0" ;;
  esac
else
  while [[ true ]];do
    # limit a random num to upper array bounds as a RundomNumber
    # let "RN = $RANDOM % ${#WPS[@]}"
    RN=$(shuf -n 1 -i 0-"${#WPS[@]}")
    # Get path and name of image as a selected WallPaper
    WP="${WPS[${RN}]}"
    # set wallpaper, wait
    "${!BGSRS[${BGSR}]}" "${WP}"
    sleep "${DEFAULT_WAIT}"
  done
fi
