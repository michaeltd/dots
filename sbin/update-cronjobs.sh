#!/usr/bin/env /bin/bash
# Update Crontab scripts tdm 171124

#set -aueo # We need on error resume next

src="/home/paperjam/bin/sbin"
crn="/etc/cron.daily"
fls=( "backup-rsync.sh" "update-system.sh" "update-hosts.sh" "update-cronjobs.sh" )

for fl in "${fls[@]}" ; do
  trgt="${src}/${fl}"
  dstn="${crn}/${fl}"
  rm $dstn
  cp $trgt $dstn
  chown root:root $dstn
  chmod +x $dstn
done
