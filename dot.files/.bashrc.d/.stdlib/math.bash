# ~/.bashrc.d/.stdlib/math.bash
#
# math related functions
#shellcheck shell=bash

# https://unix.stackexchange.com/questions/98948/ascii-to-binary-and-binary-to-ascii-conversion-tools
ascii2bin() {
    ordbin() {
	a=$(printf '%d' "'$1")
	echo "obase=2; $a" | bc
    }
    echo -n $* | while IFS= read -r -n1 char
    do
        ordbin $char | tr -d '\n'
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

ascii2b64(){
    echo "${*}" | base64
}

b642ascii(){
    echo "${*}" | base64 -d
}

is_numeric() {
    [[ "${1}" =~ ^[-|+]?[0-9]+([.][0-9]+)?$ ]]
}

is_integer() {
    [[ "${1}" =~ ^[-|+]?[0-9]+?$ ]]
}

is_decimal() {
    [[ "${1}" =~ ^[-|+]?[0-9]+[.][0-9]+?$ ]]
}

in_range() {
    [ "${#}" -ne "3" ] && \
	echo -ne "\n\tUsage: ${FUNCNAME[0]} min max num\n\n" >&2 && \
	return 1
    [ "${3}" -ge "${1}" -a "${3}" -le "${2}" ]
}

between() {
    [[ "${#}" -ne "3" ]] && \
	echo -ne "\n\tUsage: ${FUNCNAME[0]} lbound ubound check\n\n" >&2 && \
	return 1
    (( $3 >= $1 && $3 <= $2 ))
}

calc() {
    echo "scale=6;${*}"| bc -l
}

max() {
    printf "%d\n" "${@}" | sort -rn | head -1
}

min() {
    printf "%d\n" "${@}" | sort -n | head -1
}

avrg() {
    local i=0 sum=0 usage="\n\tUsage: ${FUNCNAME[0]} #1 #2 #3...\n\n"
    die() { echo -ne "${usage}" >&2; return 1; }
    [[ -z "${*}" ]] && { die; return $?; }
    while [[ -n "${*}" ]]; do
	is_numeric "${1}" || { die; return $?; }
	(( i++ ))
	# (( sum += $1 ))
	sum="$(calc "${sum} + ${1}")"
	shift
    done
    printf "%f\n" "$(calc "${sum} / ${i}")"
}

sqrt() {
    echo "scale=6;sqrt(${1})"| bc -l
}

sqr() {
    echo "scale=6;${1}^2"| bc -l
}

pwr() {
    echo "scale=6;${1}^${2}"| bc -l
}

# Trigonometric functions
# https://advantage-bash.blogspot.com/2012/12/trignometry-calculator.html
sin() {
    echo "scale=6;s(${1})" | bc -l
}

cos() {
    echo "scale=6;c(${1})" | bc -l
}

tan() {
    echo "scale=6;s(${1})/c(${1})" | bc -l
}

csc() {
    echo "scale=6;1/s(${1})" | bc -l
}

sec() {
    echo "scale=6;1/c(${1})" | bc -l
}

ctn() {
    echo "scale=6;c(${1})/s(${1})" | bc -l
}

asin() {
    if (( $(echo "${1} == 1" | bc -l) )); then
	echo "90"
    elif (( $(echo "${1} < 1" | bc -l) )); then
	echo "scale=6;a(sqrt((1/(1-(${1}^2)))-1))" | bc -l
    elif (( $(echo "${1} > 1" | bc -l) )); then
	echo "error"
    fi
}

acos() {
    if (( $(echo "${1} == 0" | bc -l) )); then
	echo "90"
    elif (( $(echo "${1} <= 1" | bc -l) )); then
	echo "scale=6;a(sqrt((1/(${1}^2))-1))" | bc -l
    elif (( $(echo "${1} > 1" | bc -l) )); then
	echo "error"
    fi
}

atan() {
    echo "scale=6;a(${1})" | bc -l
}

acot() {
    echo "scale=6;a(1/${1})" | bc -l
}

asec() {
    echo "scale=6;a(sqrt((${1}^2)-1))" | bc -l
}

acsc() {
    echo "scale=6;a(1/(sqrt(${1}^2)-1))" | bc -l
}
