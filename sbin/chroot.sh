#!/bin/bash

function chrt() {
    chroot /mnt/gentoo /bin/bash
    source /etc/profile
    export PS1="(chroot) ${PS1}"
}

function mntchrt() {
    mount --types proc /proc /mnt/gentoo/proc
    mount --rbind /sys /mnt/gentoo/sys
    mount --make-rslave /mnt/gentoo/sys
    mount --rbind /dev /mnt/gentoo/dev
    mount --make-rslave /mnt/gentoo/dev

    test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
    mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm

    #Also ensure that mode 1777 is set:
    chmod 1777 /dev/shm

    chrt
}


if [[ ! -z "${1}" ]]; then
    "${1}"
fi
