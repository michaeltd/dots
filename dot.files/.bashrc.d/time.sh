# ~/.bashrc.d/time.sh
#
# date, time related functions

function daydiff {
  source /home/paperjam/.bashrc.d/math.sh
  echo $(( ($(date +%s --date="${1}") - $(date +%s --date="${2}")) / (60 * 60 * 24) ))
}

function unixepoch {
  if [[ -n "${1}" ]];then
    date +%s --date="${1}"
  else
    date +%s
  fi
}

function epochtodate {
  date +%Y/%m/%d --date="@${1-$(unixepoch)}"
}

function epochtotime {
  date +%H:%M:%S --date="@${1-$(unixepoch)}"
}

function epochtodatetime {
  date +%Y/%m/%d-%H:%M:%S --date="@${1-$(unixepoch)}"
}

function lastdateofmonth {
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

  if [[ -n "${1}" ]]; then
    [[ ! $(date --date="${1}") ]] && return
    local y=$(date +%Y --date="${1}") m=$(date +%m --date="${1}")
  else
    local y=$(date +%Y) m=$(date +%m)
  fi

  case "${m}" in
    "01"|"03"|"05"|"07"|"08"|"10"|"12") echo 31 ;;
    "02")
      if (( y % 4 != 0 )); then echo 28
      elif (( y % 100 != 0 )); then echo 29
      elif (( y % 400 != 0 )); then echo 28
      else echo 29
      fi ;;
    "04"|"06"|"09"|"11") echo 30 ;;
  esac
}
