#!/bin/env /bin/bash

#conky -DDDD -b -c ~/.conky.conf/timer >> ~/.conky.err/`date +%y%m%d`.log 2>&1
#conky -DDDD -b -c ~/.conky.conf/qlocktwo >> ~/.conky.err/`date +%y%m%d`.clock.log 2>&1
#conky -DDDD -b -c ~/.conky.conf/conky >> ~/.conky.err/`date +%y%m%d`.conky.log 2>&1

ck=$(which conky)

ckrc="${HOME}/.conky.conf/conky"

ckErDir="${HOME}/.conky.err"

ckErFl="${ckErDir}/$(date +%y%m%d).conky.log"

if [[ -x "${ck}" && -r "${ckrc}" && -d "${ckErDir}" ]]; then
  "${ck}" -DDDD -b -c "${ckrc}" >> "${ckErFl}" 2>&1
fi
