#!/bin/bash  
#
# prime.bash
#
# Run this to prime a backup befopre runing backup.bash for the first time
#

source vars.inc.bash
source function.inc.bash

date=`date "+%a_%d%b%Y_%H%M"`
seq=`date +%s` # julian seconds
new_backup="$path_to_store_backups/${backup_name}_${seq}_F_${date}"

echo  "Empty backup dir=$new_backup, symlink=$latest_backup"

mkdir "$new_backup"

ln -s "$new_backup $latest_backup"

ls -l "$path_to_store_backups"

echo "Creating logfile, you may need to type password for sudo"

sudo touch "$logfile"
sudo chown "$user.$user $logfile"
