#
# date, time related functions
#shellcheck shell=bash

is_date()
{
    [[ -z "${1}" ]] && return 1  # apparently `date -d ""` echoes today's day and returns 0
    date -d "${1}" &> /dev/null
}

is_epoch()
{
    date -d "@${1}" &> /dev/null
}

day_diff()
{
    if [[ "${#}" -eq "2" ]]; then
	echo -ne "$(( (${1} - ${2}) / (60 * 60 * 24) ))\n"
    else
	echo -ne "Usage: ${FUNCNAME[0]} epoch1 epoch2.\n" >&2
	return 1
    fi
}

epoch_dd()
{
    day_diff "${1}" "${2}"
}

date_dd()
{
    day_diff "$(date +%s --date="${1}")" "$(date +%s --date="${2}")"
}

#shellcheck disable=SC2120
unix_epoch()
{
    if [[ -n "${1}" ]]; then
	date +%s --date="${1}"
    else
	date +%s
    fi
}

epoch2date()
{
    #shellcheck disable=SC2119
    date +%Y/%m/%d --date="@${1-$(unix_epoch)}"
}

epoch2time()
{
    #shellcheck disable=SC2119
    date +%H:%M:%S --date="@${1-$(unix_epoch)}"
}

epoch2datetime()
{
    #shellcheck disable=SC2119
    date +%Y/%m/%d-%H:%M:%S --date="@${1-$(unix_epoch)}"
}

week_day()
{
    date -d @"${1:-$(unix_epoch)}" +%u
}

last_dom()
{
    # https://en.wikipedia.org/wiki/Leap_year
    # if (year is not divisible by 4) then (it is a common year)
    # else if (year is not divisible by 100) then (it is a leap year)
    # else if (year is not divisible by 400) then (it is a common year)
    # else (it is a leap year)
    # https://stackoverflow.com/questions/3220163/how-to-find-leap-year-programatically-in-c/11595914#11595914
    # https://www.timeanddate.com/date/leapyear.html
    # https://medium.freecodecamp.org/test-driven-development-what-it-is-and-what-it-is-not-41fa6bca02a2
    # Feature: Every year that is exactly divisible by four is a leap year, except for years that are exactly divisible by 100, but these centurial years are leap years if they are exactly divisible by 400.
    #
    # - divisible by 4
    # - but not by 100
    # - years divisible by 400 are leap anyway
    #
    # What about leap years in Julian calendar? And years before Julian calendar?

    local y m
    if [[ -n "${1}" ]]; then
	date --date="${1}" &>/dev/null || return 1
	y=$(date +%Y --date="${1}")
	m=$(date +%m --date="${1}")
    else
	y=$(date +%Y)
	m=$(date +%m)
    fi
    
    case "${m}" in
	"01"|"03"|"05"|"07"|"08"|"10"|"12") echo "31";;
	"02")
	    if (( y % 4 != 0 )); then echo "28"
	    elif (( y % 100 != 0 )); then echo "29"
	    elif (( y % 400 != 0 )); then echo "28"
	    else echo "29"
	    fi;;
	"04"|"06"|"09"|"11") echo "30";;
    esac
}
