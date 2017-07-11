#!/bin/env /bin/bash

MAIL=paperjam@localhost

eixlog="/var/log/eix-sync.$(date +%y%m%d.%H%M%S).log"
emrlog="/var/log/emerge.update.$(date +%y%m%d.%H%M%S).log"

/usr/bin/eix-sync >> "${eixlog}"

/usr/bin/emerge --nospinner --verbose --update --deep --newuse --with-bdeps=y @world >> "${emrlog}"
