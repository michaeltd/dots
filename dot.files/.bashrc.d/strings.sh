# ~/.bashrc.d/strings.sh
#
# string related functions

# STRINGS =====================================================================

function alphabetic_only {
  printf "%s\n" "${@//[![:alpha:]]}"
}

function alphanumeric_only {
  printf "%s\n" "${@//[![:alnum:]]}"
}

function digits_only {
  printf "%s\n" "${@//[![:digit:]]}"
}

function remove_spaces {
  # https://stackoverflow.com/questions/13659318/how-to-remove-space-from-string
  echo "${@}"|sed 's/ //g'
  # shopt -s extglob # Allow extended globbing
  # var=" lakdjsf   lkadsjf "
  # echo "${var//+([[:space:]])/}"
  # shopt -u extglob
}

function trim {
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  echo -n "$var"
}

function left_pad {
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
  # local var="$*"
  # remove leading whitespace characters
  # var="${@#"${@%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  # var="${var%"${var##*[![:space:]]}"}"
  # echo -n "$var"
  echo -n "${@#"${@%%[![:space:]]*}"}"
}

function right_pad {
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
  # local var="$*"
  # remove leading whitespace characters
  # var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  # var="${var%"${var##*[![:space:]]}"}"
  # echo -n "$var"
  echo -n "${@%"${@##*[![:space:]]}"}"
}
