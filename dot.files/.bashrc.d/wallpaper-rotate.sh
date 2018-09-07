# WALLPAPER-ROTATE ============================================================
# Simple script to go through a directory of background images as wallpapers in a timely fashion

declare \
  USAGE="\nScript to rotate backgrounds in wm's with out such options (ie NOT kde, gnome or xfce4)\nUsage: source $(basename ${BASH_SOURCE[0]}) && wallpaper_rotate &\nAlternatively you can source this file in your startup scripts and start it from there.\nOther options include : \nwallpaper_rotate help - this message, \nwallpaper_rotate add 'adir' - add given directory to your list of directories with images, \nwallpaper_rotate remove 'adir' remove given directory off your list of directories with images,\nwallpaper_rotate without options will just start rotating images. \n" \
  BGSETTER="" \
  WPRC="${HOME}/.$(basename ${BASH_SOURCE[0]}).rc" \
  DEFAULT_WAIT="60s" \
  DEFAULT_DIRS=( "${HOME}/Pictures" ) \
  LS=$(which ls 2> /dev/null) \
  WPS=()

function wpDefaults {

  # Assign a WP setter, WP list and a swap delay
  # Find a setter or die trying
  if [[ -x $(which feh) ]]; then
    BGSETTER="feh --bg-scale"
  elif [[ -x $(which wmsetbg) ]]; then
    BGSETTER="wmsetbg"
  elif [[ -x $(which fvwm-root) ]]; then
    BGSETTER="fvwm-root"
  elif [[ -x $(which fbsetbg) ]]; then
    BGSETTER="fbsetbg"
  elif [[ -x $(which bsetbg) ]]; then
    BGSETTER="bsetbg"
  elif [[ -x $(which hsetroot) ]]; then
    BGSETTER="hsetroot -fill"
  elif [[ -x $(which xsetbg) ]]; then
    BGSETTER="xsetbg"
  elif [[ -x $(which xsetroot) ]]; then
    BGSETTER="xsetroot -bitmap"
  else
    printf "${USAGE}"
    return 1
  fi

  # If there is a readable settings file, read it
  if [[ -r ${WPRC} ]]; then
    source ${WPRC}
  else
    # or write it
    printf "DEFAULT_WAIT=\"60s\"\nDEFAULT_DIRS=( \"${HOME}/Pictures\" )\n" > ${WPRC}
  fi

  for D in ${DEFAULT_DIRS[@]}; do 
    declare -a PICS=( $(${LS} -A ${D}) )
    for P in ${PICS[@]}; do
      declare FN="${D}/${P}" FE="${P:(-4)}"
      if [[ -f "${FN}" && "${FE,,}" == ".jpg" || "${FE,,}" == ".jpe" || "${FE,,}" == ".png" || "${FE,,}" == ".gif" || "${FE,,}" == ".bmp" ]]; then
        WPS+=( "${FN}" )
      fi
    done
  done
}

function wpAddDir {
  wpDefaults || return 1
  if [[ -d "${1}" ]]; then 
    DEFAULT_DIRS+=( "${1}" )
  else
    printf "Not a directory\n"
    return 1
  fi
  longstring="${DEFAULT_DIRS[@]}"
  sed --follow-symlinks -i "s/^DEFAULT_DIRS.*//" "${WPRC}"
  printf "DEFAULT_DIRS=( %s )" "${longstring}" >> "${WPRC}"
}

function wpRemDir {
  wpDefaults || return 1
  for (( i=0; i<=${#DEFAULT_DIRS[@]}; i++ )); do  
    if [[ "${DEFAULT_DIRS[${i}]}" == "${1}" ]]; then
      unset 'DEFAULT_DIRS[i]'
    fi
  done
  longstring="${DEFAULT_DIRS[@]}"
  sed --follow-symlinks -i "s/^DEFAULT_DIRS.*//" "${WPRC}"
  printf "DEFAULT_DIRS=( %s )" "${longstring}" >> "${WPRC}"
}

function wallpaper_rotate {

  wpDefaults || return 1

  if [[ -n "$1" ]]; then 
    case "$1" in
      help*|halp*|?)
        printf "${USAGE}" 
        return 0 ;;
      add*)
        shift 
        wpAddDir "${1}"
        return 0 ;;
      rem*)
        shift 
        wpRemDir "${1}"
        return 0 ;;
      *)
        printf "${USAGE}" 
        return 0 ;;
    esac
  else
    while [[ true ]]; do
      # limit a random num to upper array bounds as a RundomNumber
      # let "RN = $RANDOM % ${#WPS[@]}"
      RN=$(shuf -n 1 -i 0-"${#WPS[@]}")
      # Get path and name of image as a selected WallPaper
      WP="${WPS[${RN}]}"
      # set wallpaper, wait
      ${BGSETTER} "${WP}"
      sleep "${DEFAULT_WAIT}"
    done
  fi
}
