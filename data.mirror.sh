#!/bin/env /bin/bash

rsync --progress --verbose --recursive --times --delete --exclude='*XNXX*' /mnt/ELEMENTS/* /mnt/DATA/
