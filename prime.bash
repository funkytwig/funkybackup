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

if [[ "$path_to_store_backups" != "${path_to_store_backups/ /}" ]]; then
  echo "ERROR path_to_store_backups can not contain spaces" 
 exit 1
fi

# create main backup directory if it does not exist

if [ ! -d "$path_to_store_backups" ]; then
  mkdir "$path_to_store_backups"
else
  echo  "$path_to_store_backups already exists"
fi 

# Create empty backup directory directory

mkdir "$new_backup"

# create current directory link

if [ -d $latest_backup ]; then
  rm -r $latest_backup # incase it already esists
fi

ln -s $new_backup $latest_backup

echo "Created initial directory and link, it should be shown below:"

ls -l "$path_to_store_backups"

echo "Creating logfile, you may need to type password for sudo"

sudo touch "$logfile"
sudo chown $user.$user "$logfile"
