#!/bin/env /bin/bash

MAIL=paperjam@localhost

dtstmp=$(date +%y%m%d.%H%M%S)
#eixscm=$(which eix-sync)
emrgcm=$(which emerge)
#eixlog="/var/log/eix-sync.${dtstmp}.log"
snclog="/var/log/prt-sync.${dtstmp}.log"
emrlog="/var/log/emerge.update.${dtstmp}.log"

#if [[ -x "${eixscm}" &&  -x "${emrgcm}" ]]; then
#  "${eixscm}" >> "${eixlog}" 2>&1
#  "${emrgcm}" --nospinner --verbose --update --deep --newuse --with-bdeps=y @world >> "${emrlog}" 2>&1
#elif [[ -x "${emrgcm}" ]]; then
"${emrgcm}" --sync >> "${snclog}" 2>&1
"${emrgcm}" --nospinner --verbose --update --deep --newuse --with-bdeps=y @world >> "${emrlog}" 2>&1
#else
#  printf "Something is missing. %s \n" "${dtstmp}" >> "${emrlog}" 2>&1
#fi
