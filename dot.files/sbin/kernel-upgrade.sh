#!/usr/bin/env bash

cp /usr/src/linux/.config ~/kernel-config-`uname -r`

#eselect kernel list
#eselect kernel set 2
#mount /boot

cd /usr/src/linux

zcat /proc/config.gz > /usr/src/linux/.config

make syncconfig

make -j4 && make modules_install # (adjust the -j according to CPU cores)

make install

grub-mkconfig -o /boot/grub/grub.cfg

emerge @module-rebuild

#umount /boot
#reboot

# Upon reboot, assuming all went well, clean out /lib/modules of the previous kernel directories, clean out /usr/src of the previous kernels (never linux nor your current kernel), and mount /boot, cd boot, and clear out the old garbage.

# cd /usr/src/new_kernel && cp ../linux-old_kernel/.config ./
# eselect kernel list
# eselect kernel set new_kernel_nr
# make olddefconfig (mainly because I can't be bothered to google all the new options therefore set them as default)
# genkernel --oldconfig all
# emerge @module-rebuild
# grub-mkconfig -o /boot/grub/grub.cfg
