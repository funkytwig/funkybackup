#!/bin/bash 
#
# fix_current
#
# delete latest backup and recreate current symlink
# This is used if something went wrong and latest backup broke
#

source vars.inc.bash
source function.inc.bash

backup_ls=/var/tmp/$$_backup_dir.txt
backup_ls_sorted=/tmp/$$_backup_dir_sorted.txt

rm -fv $latest_backup

ls -t $path_to_store_backups > $backup_ls

cat $backup_ls | sort > $backup_ls_sorted

new_backup=`tail -1  $backup_ls_sorted`

symlink_to=$path_to_store_backups/$new_backup

echo "Creatung symlink $latest_backup => $symlink_to"

ln -s $symlink_to $latest_backup

echo "du for $symlink_to"

du -h --max-depth=1 $symlink_to
