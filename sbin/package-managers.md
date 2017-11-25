#### [package-managers.md](https://en.wikipedia.org/wiki/Package_manager)

Action|zypper|pacman|apt|dnf (yum)|portage
---|---|---|---|---|---
install package |zypper in PKG |pacman -S PACKAGE |apt install PACKAGE |yum install PACKAGE |emerge PACKAGE
remove package |zypper rm -RU PKG |pacman -R PACKAGE |apt remove PACKAGE |dnf remove --nodeps PACKAGE |emerge -C PACKAGE or emerge --unmerge PACKAGE
remove package - orphans |zypper rm -u --force-resolution PKG |pacman -Rs PACKAGE |apt autoremove PACKAGE |dnf remove PACKAGE |emerge -c PACKAGE or emerge --depclean PACKAGE
update software database |zypper ref |pacman -Sy |apt update |yum check-update |emerge --sync
show updatable packages |zypper lu |pacman -Qu |apt list --upgradable |yum check-update |emerge -avtuDN --with-bdeps=y @world or emerge --update --pretend @world
delete orphans - config |zypper rm -u |pacman -Rsn $(pacman -Qdtq)|apt autoremove|dnf erase PKG |emerge --depclean
show orphans |zypper pa --orphaned --unneeded |pacman -Qdt | |package-cleanup --quiet --leaves --exclude-bin |emerge -caD or emerge --depclean --pretend
update all |zypper up |pacman -Syu |apt upgrade |yum update |emerge --update --deep --with-bdeps=y @world
