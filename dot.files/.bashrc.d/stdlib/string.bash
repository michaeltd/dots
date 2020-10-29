#
# string related functions
#shellcheck shell=bash disable=SC2048,SC2086,SC2046,SC2005,SC2059

ascii2bin() {
    # https://unix.stackexchange.com/questions/98948/ascii-to-binary-and-binary-to-ascii-conversion-tools
    echo -n $* | while IFS= read -r -n1 char
    do
        echo "obase=2; $(printf '%d' "'$char")" | bc | tr -d '\n'
        echo -n " "
    done
    printf "\n"
}

bin2ascii() {
    chrbin() {
	echo $(printf \\$(echo "ibase=2; obase=8; $1" | bc))
    }
    for bin in $*
    do
        chrbin $bin | tr -d '\n'
    done
    printf "\n"
}

is_ucase(){
    [[ "${1}" == "${1^^}" ]]
}

is_lcase(){
    [[ "${1}" == "${1,,}" ]]
}

split() {
    # from pure-bash-bible
    # Usage: split "string" "delimiter"
    IFS=$'\n' read -d "" -ra arr <<< "${1//${2}/$'\n'}"
    printf "%s\n" "${arr[*]}"
}

2lower_case() {
    printf '%s\n' "${*,,}"
}

2upper_case() {
    printf '%s\n' "${*^^}"
}

alphabetic_only() {
    printf "%s\n" "${*//[![:alpha:]]}"
}

alphanumeric_only() {
    printf "%s\n" "${*//[![:alnum:]]}"
}

digits_only() {
    printf "%s\n" "${*//[![:digit:]]}"
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
    printf "%s\n" "${*//+([[:space:]])/}"
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
    
    local var="${*}"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    printf "%s\n" "${var}"
}

left_pad() {
    # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
    # local var="$*"
    # remove leading whitespace characters
    # var="${@#"${@%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    # var="${var%"${var##*[![:space:]]}"}"
    # echo -n "$var"
    printf "%s\n" "${@#"${@%%[![:space:]]*}"}"
}

right_pad() {
    # https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
    # local var="$*"
    # remove leading whitespace characters
    # var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    # var="${var%"${var##*[![:space:]]}"}"
    # echo -n "$var"
    printf "%s\n" "${@%"${@##*[![:space:]]}"}"
}
