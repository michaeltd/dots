# ~/.bashrc.d/string.sh
#
# string related functions

split() {
  # from pure-bash-bible
  # Usage: split "string" "delimiter"
  IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
  printf '%s\n' "${arr[@]}"
}

alphabetic_only() {
  printf "%s\n" "${@//[![:alpha:]]}"
}

alphanumeric_only() {
  printf "%s\n" "${@//[![:alnum:]]}"
}

digits_only() {
  printf "%s\n" "${@//[![:digit:]]}"
}

remove_spaces() {
  # https://stackoverflow.com/questions/13659318/how-to-remove-space-from-string
  echo "${@}"|sed 's/ //g'
  # shopt -s extglob # Allow extended globbing
  # var=" lakdjsf   lkadsjf "
  # echo "${var//+([[:space:]])/}"
  # shopt -u extglob
}

trim() {
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  echo -n "$var"
}

left_pad() {
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
  # local var="$*"
  # remove leading whitespace characters
  # var="${@#"${@%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  # var="${var%"${var##*[![:space:]]}"}"
  # echo -n "$var"
  echo -n "${@#"${@%%[![:space:]]*}"}"
}

right_pad() {
  # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
  # local var="$*"
  # remove leading whitespace characters
  # var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  # var="${var%"${var##*[![:space:]]}"}"
  # echo -n "$var"
  echo -n "${@%"${@##*[![:space:]]}"}"
}
