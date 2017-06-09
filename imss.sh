#!/bin/bash

PI=${1-"2"}

FN=~/Pictures/imagemagic-`date +%y%m%d%H%M%S`.png

import -pause $PI -window root $FN

viewnior $FN

