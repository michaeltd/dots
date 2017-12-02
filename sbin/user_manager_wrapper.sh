#!/bin/bash

#### Parse parameters (getopt?)
# getopt or ?
#

#### Utilities to check out
# useradd userdel usermod users
# groupadd groupdel groupmod groups
# gpasswd passwd

#groupadd $1
useradd \
  --user-group \
  --create-home \
  --shell /bin/bash \
  --groups usb,cdrw,cdrom,floppy,disk,audio,video,console,uucp,users,wheel \
  $1
