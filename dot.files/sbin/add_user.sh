#!/bin/bash

if [[ -z "${1}" ]] || (( EUID != 0 )); then
  printf "Usage: sudo %s username\n" "$(basename ${0})"
  exit 1
fi

useradd -m -U -s /bin/bash -G wheel,floppy,uucp,audio,cdrom,video,cdrw,usb,users,wireshark,games "${1}"
