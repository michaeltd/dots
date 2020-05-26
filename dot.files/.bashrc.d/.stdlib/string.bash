# ~/.bashrc.d/.stdlib/string.bash
#
# string related functions
#shellcheck shell=bash

split() {
    # from pure-bash-bible
    # Usage: split "string" "delimiter"
    IFS=$'\n' read -d "" -ra arr <<< "${1//${2}/$'\n'}"
    printf "${arr[*]}\n"
}

2lower_case() {
    printf '%s\n' "${*,,}"
}

2upper_case() {
    printf '%s\n' "${*^^}"
}

alphabetic_only() {
    # echo -ne "${@//[![:alpha:]]}\n"
    printf "${*//[![:alpha:]]}\n"
}

alphanumeric_only() {
    # echo -ne "${@//[![:alnum:]]}\n"
    printf "${*//[![:alnum:]]}\n"
}

digits_only() {
    # echo -ne "${@//[![:digit:]]}\n"
    printf "${*//[![:digit:]]}\n"
}

remove_spaces() {
    # https://stackoverflow.com/questions/13659318/how-to-remove-space-from-string
    # echo "${@}"|sed 's/ //g'
    # pure-bash-bible
    # shopt -s extglob # Allow extended globbing
    # var=" lakdjsf   lkadsjf "
    # echo "${var//+([[:space:]])/}"
    # shopt -u extglob

    shopt -s extglob # Allow extended globbing
    printf "${*//+([[:space:]])/}\n"
    shopt -u extglob
}

trim() {
    # # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
    # local var="$*"
    # # remove leading whitespace characters
    # var="${var#"${var%%[![:space:]]*}"}"
    # # remove trailing whitespace characters
    # var="${var%"${var##*[![:space:]]}"}"
    # echo -n "$var"
    
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    printf "${var}\n"
}

left_pad() {
    # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
    # local var="$*"
    # remove leading whitespace characters
    # var="${@#"${@%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    # var="${var%"${var##*[![:space:]]}"}"
    # echo -n "$var"
    printf "${@#"${@%%[![:space:]]*}"}\n"
}

right_pad() {
    # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
    # local var="$*"
    # remove leading whitespace characters
    # var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    # var="${var%"${var##*[![:space:]]}"}"
    # echo -n "$var"
    printf "${@%"${@##*[![:space:]]}"}\n"
}
