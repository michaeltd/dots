# 
# WALLPAPER-ROTATE ============================================================
# Simple script to go through a directory of background images as wallpapers in a timely fashion

declare -a FEH=( "feh" "--bg-scale" ) WMSETBG=( "wmsetbg" ) FVWM_ROOT=( "fvwm-root" ) FBSETBG=( "fbsetbg" ) BSETBG=( "bsetbg" ) HSETROOT=( "hsetroot" "-fill" ) XSETBG=( "xsetbg" ) XSETROOT=( "xsetroot" "-bitmap" ) BGSRS=( FEH[@] WMSETBG[@] FVWM_ROOT[@] FBSETBG[@] BSETBG[@] HSETROOT[@] XSETBG[@] XSETROOT[@] ) BGSR WPRC="${HOME}/.$(basename ${BASH_SOURCE[0]}).rc" DEFAULT_WAIT="60s" DEFAULT_DIRS=( "${HOME}/Pictures" ) LS=$(which ls 2> /dev/null) WPS=()

function wpDefaults {
  # bash version info check
  if [[ "${BASH_VERSINFO[0]}" -lt "4" ]]; then 
    printf "For this to work properly you'll need bash major version greater than 4!"
    return "1"
  fi

  # Find a setter
  for (( x=0; x<="${#BGSRS[@]}"; x++ )); do 
    bgsrs+="${!BGSRS[$x]:0:1} "
    if [[ -n $(which "${!BGSRS[$x]:0:1}" 2> /dev/null) ]]; then
      BGSR="${x}"
      break # Break on first match.
    fi
  done

  # Quit on no setter
  if [[ -z "${BGSR}" ]]; then 
    printf "${USAGE}"
    printf "\n  For this to work you need one of :\n  ${bgsrs}\n  installed. None found. Quithing.\n"
    return "1"
  fi

  # If there is a readable settings file, read it
  if [[ -r "${WPRC}" ]]; then
    source "${WPRC}"
  else
    # or write it
    printf "DEFAULT_WAIT=\"60s\"\nDEFAULT_DIRS=( \"${HOME}/Pictures\" )\n" > "${WPRC}"
  fi

  # Fill up a WallPaperS list
  for D in "${DEFAULT_DIRS[@]}"; do 
    PICS=( $("${LS}" -A "${D}") )
    for P in "${PICS[@]}"; do
      FN="${D}/${P}" FE="${P:(-4)}"
      if [[ -f "${FN}" && "${FE,,}" == ".jpg" || "${FE,,}" == ".jpe" || "${FE,,}" == ".png" || "${FE,,}" == ".gif" || "${FE,,}" == ".bmp" ]]; then
        WPS+=( "${FN}" )
      fi
    done
  done
}

function wpDirManager {
  wpDefaults || return "${?}"
  case "${1}" in
    del*|rem*) 
      for (( i=0; i<="${#DEFAULT_DIRS[@]}"; i++ )); do 
        [[ "${DEFAULT_DIRS[${i}]}" == "${2}" ]] && unset 'DEFAULT_DIRS[i]'
      done
    ;;
    add*) 
      if [[ -d "${2}" ]]; then 
        DEFAULT_DIRS+=( "${2}" )
      else 
        printf "%s Is not a directory\n" "${2}"
        return "1"
      fi
    ;;
  esac
  sv="DEFAULT_DIRS=(" rv="DEFAULT_DIRS=( ${DEFAULT_DIRS[@]} )"
  sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}"
}

function wallpaper_rotate {
  declare -g USAGE="\n  Script to rotate backgrounds in wm's with out such options,\n  ie NOT kde, gnome or xfce4.\n\n  Usage: source $(basename ${BASH_SOURCE[0]}) && ${FUNCNAME[0]} &\n\n  Alternatively you can source this file in your startup scripts \n  and start it from there.\n\n  Other options include : \n\n  ${FUNCNAME[0]} help - this message, \n  ${FUNCNAME[0]} add 'dir-path' - add a directory to your image list, \n  ${FUNCNAME[0]} del 'dir-path' - remove a directory from your image list,\n  ${FUNCNAME[0]} without options will start rotating images. \n"
  wpDefaults || return "${?}"
  if [[ -n "${1}" ]]; then 
    case "${1}" in
      del*|rem*|add*) wpDirManager "${@}"; return "${?}";;
      *) printf "${USAGE}"; return "0";;
    esac
  else
    while [[ true ]]; do
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
}
