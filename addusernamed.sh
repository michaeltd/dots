#!/bin/bash
#groupadd $1
useradd \
  --user-group \
  --create-home \
  --shell /bin/bash \
  --groups usb,cdrw,cdrom,floppy,disk,audio,video,console,uucp,users,wheel \
  $1
