#!/bin/env /bin/bash

MAIL=paperjam@localhost

qclog="/var/log/qcheck.${HOSTNAME}.${USER}.$(date +%y%m%d.%H%M%S).log"

nice -n 15 qcheck >> "${qclog}" 2>&1
