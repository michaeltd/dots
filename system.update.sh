#!/bin/env /bin/bash

emrg=/usr/bin/emerge

$emrg --quiet --sync

$emrg --nospinner --pretend --update --deep --newuse --autounmask-keep-masks --with-bdeps=y @world

time $emrg --nospinner --update --deep --newuse --autounmask-keep-masks --with-bdeps=y @world

#time $emrg --nospinner --depclean
