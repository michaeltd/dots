#!/bin/env /bin/bash

#conky -DDDD -b -c ~/.conky.conf/timer >> ~/.conky.err/`date +%y%m%d`.log 2>&1
#conky -DDDD -b -c ~/.conky.conf/qlocktwo >> ~/.conky.err/`date +%y%m%d`.clock.log 2>&1
conky -DDDD -b -c ~/.conky.conf/conky >> ~/.conky.err/`date +%y%m%d`.conky.log 2>&1
