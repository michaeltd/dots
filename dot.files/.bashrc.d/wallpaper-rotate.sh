# 
# WALLPAPER-ROTATE ============================================================
# Simple script to go through a directory of background images as wallpapers in a timely fashion

declare -a USAGE="\n  Script to rotate backgrounds in wm's with out such options,\n  ie NOT kde, gnome or xfce4.\n\n  Usage: source $(basename ${BASH_SOURCE[0]}) && wallpaper_rotate &\n\n  Alternatively you can source this file in your startup scripts \n  and start it from there.\n\n  Other options include : \n\n  wallpaper_rotate help - this message, \n  wallpaper_rotate add 'dir-path' - add a directory to your image list, \n  wallpaper_rotate del 'dir-path' - remove a directory from your image list,\n  wallpaper_rotate without options will start rotating images. \n" FEH=( "feh" "--bg-scale" ) WMSETBG=( "wmsetbg" ) FVWM_ROOT=( "fvwm-root" ) FBSETBG=( "fbsetbg" ) BSETBG=( "bsetbg" ) HSETROOT=( "hsetroot" "-fill" ) XSETBG=( "xsetbg" ) XSETROOT=( "xsetroot" "-bitmap" ) BGSRS=( FEH[@] WMSETBG[@] FVWM_ROOT[@] FBSETBG[@] BSETBG[@] HSETROOT[@] XSETBG[@] XSETROOT[@] ) BGSR="" WPRC="${HOME}/.$(basename ${BASH_SOURCE[0]}).rc" DEFAULT_WAIT="60s" DEFAULT_DIRS=( "${HOME}/Pictures" ) LS=$(which ls 2> /dev/null) WPS=()

function wpDefaults {

  if [[ "${BASH_VERSINFO[0]}" -lt "4" ]]; then 
    printf "For this to work properly you'll need bash major version greater than 4!"
    return "1"
  fi

  # Find a setter or die trying
  for (( x=0; x<="${#BGSRS[@]}"; x++ )); do 
    if [[ -n $(which "${!BGSRS[$x]:0:1}" 2> /dev/null) ]]; then
      declare -g BGSR="${x}"
      break
    fi
    # We'll never reach this far as xsetroot is part of any typical X11 istallation but it only works with bitmap files (-.-), so just to be on the safe side if(/when?) "What could possibly go wrong TM" or "Wayland TM" happens ...
    # x equals upper array bounds in last FOR iteration so if we havent braked yet (see l - 3) then we do not have a match. This is the most horrible piece of code i wrote in a really long time, it is bad, i am bad and i should feel bad.
    if (( "${x}" == "${#BGSRS[@]}" )); then 
      printf "  For this to work you need one of \n  feh, wmsetbg, fvwm-root, fbsetbg, \n  bsetbg, hsetroot, xsetbg, xsetroot installed.\n  Quithing.\n"
      return "1"
    fi
  done

  # If there is a readable settings file, read it
  if [[ -r "${WPRC}" ]]; then
    source "${WPRC}"
  else
    # or write it
    printf "DEFAULT_WAIT=\"60s\"\nDEFAULT_DIRS=( \"${HOME}/Pictures\" )\n" > ${WPRC}
  fi

  # Fill up a WallPaperS list
  for D in "${DEFAULT_DIRS[@]}"; do 
    declare -a PICS=( $("${LS}" -A "${D}") )
    for P in "${PICS[@]}"; do
      declare FN="${D}/${P}" FE="${P:(-4)}"
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
        if [[ "${DEFAULT_DIRS[${i}]}" == "${2}" ]]; then 
          unset 'DEFAULT_DIRS[i]'
        fi 
      done
    ;;
    add*) 
      if [[ -d "${2}" ]]; then 
        DEFAULT_DIRS+=( "${2}" )
      else 
        printf "Not a directory\n"; 
        return "1"
      fi
    ;;
  esac
  local sv="DEFAULT_DIRS=(" rv="DEFAULT_DIRS=( ${DEFAULT_DIRS[@]} )"
  sed --follow-symlinks -i "s|^${sv}.*|${rv}|g" "${WPRC}"
}

function wallpaper_rotate {

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
      "${!BGSRS[$BGSR]}" "${WP}"
      sleep "${DEFAULT_WAIT}"
    done
  fi
}
