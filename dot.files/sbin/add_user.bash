#!/bin/bash

if [[ -z "${1}" || "${EUID}" -ne "0" ]]; then
    echo -ne "Usage: sudo $(basename "${0}") 'new username'\n" >&2
    exit 1
fi

useradd -m -U -s /bin/bash -G wheel,floppy,uucp,audio,cdrom,video,cdrw,usb,users,wireshark,games "${1}"
