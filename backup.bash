#!/bin/bash
#
# back.bash - Main funkybackup script
#
# For more details about the script and to me goto 
# http://www.funkytwig.com/blog/funkybackup
#
# (c) 2015 Ben Edwards (funkytwig.com) 
# You are alowed to use the script if you keep this head0er 
# and do not redistibute it, just send people to the URL
#
# Ver	Coments
# 0.5	Initial version

source vars.inc.bash
source function.inc.bash
source start.bash

date=`date "+%a_%d%b%Y_%H%M"`
seq=`date +%s` # julian seconds

new_backup=$path_to_store_backups/${backup_name}_${seq}_F_${date}

log "Creating backup $new_backup from $what_to_backup"

# run rsync

if [ ! -z "$exclude" ]; then
  rsync_exclude="--delete-excluded --exclude "
  rsync_exclude+='"'
  rsync_exclude+="$exclude"
  rsync_exclude+='"'
else
  rsync_exclude=""
fi

rsync_cmd="rsync -r -t -i $rsync_exclude --delete --link-dest=$latest_backup $what_to_backup $new_backup"

run_cmd "$rsync_cmd"

# Point current symbolic link to new backup

run_cmd "rm -f $latest_backup"
run_cmd "ln -s $new_backup $latest_backup"

source end.bash

