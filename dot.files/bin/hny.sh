#!/usr/bin/env bash
#
#~/bin/hny.sh

if [[ ! -x $(which lolcat) || ! -x $(which fortune) ||  ! -x $(which cowsay) || "${BASH_VERSINFO[0]}" -lt "4" ]]; then 
  printf "For this to work you'll need lolcat, fortune, cowsay and bash major version greater than 4!"
  exit 1
fi

clear

countdown=( '!!!zero!!!' '!!!one!!!' '!!!two!!!' '!!!three!!!' '!!!four!!!' '!!!five!!!' '!!!six!!!' '!!!seven!!!' '!!!eight!!!' '!!!nine!!!' \
'!!!ten!!!' '!!!eleven!!!' '!!!twelve!!!' '!!!thirteen!!!' '!!!fourteen!!!' '!!!fifteen!!!' '!!!sixteen!!!' '!!!seventeen!!!' '!!!eightteen!!!' '!!!ninteen!!!' \
'!!!twenty!!!' '!!!twentyone!!!' '!!!twentytwo!!!' '!!!twentythree!!!' '!!!twentyfour!!!' '!!!twentyfive!!!' '!!!twentysix!!!' '!!!twentyseven!!!' '!!!twentyeight!!!' '!!!twentynine!!!' \
'!!!thirty!!!' '!!!thirtyone!!!' '!!!thirtytwo!!!' '!!!thirtythree!!!' '!!!thirtyfour!!!' '!!!thirtyfive!!!' '!!!thirtysix!!!' '!!!thirtyseven!!!' '!!!thirtyeight!!!' '!!!thirtynine!!!' \
'!!!fourty!!!' '!!!fourtyone!!!' '!!!fourtytwo!!!' '!!!fourtythree!!!' '!!!fourtyfour!!!' '!!!fourtyfive!!!' '!!!fourtysix!!!' '!!!fourtyseven!!!' '!!!fourtyeight!!!' '!!!fourtynine!!!' \
'!!!fifty!!!' '!!!fiftyone!!!' '!!!fiftytwo!!!' '!!!fiftythree!!!' '!!!fiftyfour!!!' '!!!fiftyfive!!!' '!!!fiftysix!!!' '!!!fiftyseven!!!' '!!!fiftyeight!!!' '!!!fiftynine!!!' \
'!!!sixty!!!' )
cowfiles=( $( cowsay -l ) )
currYear=$( date +%Y )
nextYear=$( expr ${currYear} + 1 )

while cd=$(( $( date +%s -d"${nextYear}-01-01" ) - $( date +%s ) )); do
  cowfile=${cowfiles[$( shuf -n 1 -i 4-${#cowfiles[@]})]}
  if [[ "${cd}" -eq "0" ]]; then
    printf 'TUX SAYS:\n\r!!!HELLO %s!!!\n\rHAPPY NEW YEAR!!!\n\r' ${nextYear}|cowsay -f tux |lolcat
    break
  elif [[ "${cd}" -le "60" && "${cd}" -gt "0" ]]; then
    printf "%s SAYS:\n\r%s\n" ${cowfile^^} ${countdown[${cd}]^^} |cowsay -f ${cowfile} |lolcat
    sleep 1
    clear
  elif [[ "${cd}" -gt "60" ]]; then
    # Uncomment next two lines and comment out the third one to get a rough idea of how the 60 seconds countdown will look like.
    # mod=$( expr ${cd} % ${#cowfiles[@]} )
    # printf "%s SAYS:\n\r%s\n" ${cowfile^^} ${countdown[${mod}]^^} |cowsay -f ${cowfile} |lolcat
    fortune |cowsay -f ${cowfile} |lolcat
    sleep 5
    clear
  fi
done
