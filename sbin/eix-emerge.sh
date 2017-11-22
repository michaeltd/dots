#!/usr/bin/env /bin/bash

MAIL=paperjam@localhost

dtstmp=$(date +%y%m%d.%H%M%S)
eixscm=$(which eix-sync)
emrgcm=$(which emerge)
eixlog="/var/log/eix-sync.${dtstmp}.log"
snclog="/var/log/prt-sync.${dtstmp}.log"
emrlog="/var/log/emerge.update.${dtstmp}.log"

"${eixscm}" >> "${eixlog}" 2>&1
ec="${?}"
if [[ "${ec}" -ne "0" ]]; then
  "${emrgcm}" --sync >> "${snclog}" 2>&1
fi

"${emrgcm}" --nospinner --verbose --update --deep --newuse --with-bdeps=y @world >> "${emrlog}" 2>&1
