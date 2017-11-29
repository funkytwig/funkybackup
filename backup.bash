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

# Cheching disk space

df_info=`df -h $path_to_store_backups| tail -1`

disk_total=`echo $df_info | awk '{print $2}'`
disk_used=`echo $df_info | awk '{print $3}'`
disk_free=`echo $df_info | awk '{print $4}'`
disk_percent=`echo $df_info | awk '{print $5}' `
disk_percent=${disk_percent::-1}

disk_info="$path_to_store_backups, total=$disk_total, used=$disk_used, free=$disk_free, used=${disk_percent}%"

if [ $disk_percent -lt $disk_low_warning_percent ]; then
  log "$disk_info (threshold=$disk_low_warning_percent%)"
else
  body="$disk_info"
  temp_file="/tmp/$$_disk_space_email.tml"
  echo "Low threshhold set to $disk_low_warning_percent%"	>> $temp_file
  echo "" 							>> $temp_file
  echo "Consider deleting old backups"  			>> $temp_file
  send_email "Disk space geting low (${disk_percent}%) on `hostname`:$path_to_store_backups($backup_name)" "$body" "$temp_file"
fi

# run rsync

if [ ! -z "$exclude" ]; then
  rsync_exclude="--delete-excluded --exclude "
  rsync_exclude+='"'
  rsync_exclude+="$exclude"
  rsync_exclude+='"'
else
  rsync_exclude=""
fi


# if rsync failers try running 4 times as link may be down, this may be during a big rsync is happening.
# The rsync comand will pickup where it has left off.  Note this will mean the log file will only show the output 
# from tha last rsync.  Note alough return codes are negative bash turns them to posative integers.

try=0
ret_code=-1 # to insure the loop runs at least once

while [ "$ret_code" -ne "0" ]
do
  ((try++))

  rsync_cmd="rsync $rsync_options $rsync_exclude --delete --link-dest=$latest_backup $what_to_backup $new_backup"

  run_cmd "$rsync_cmd"

  ret_code=$?

  log "return code $ret_code"

  if [ "$ret_code" -ne "0" ]; then 
    log "rsync FAILED with code $ret_code, waiting 60 seconds and trying again (try $try)"
    sleep 60;
  fi

  if [ "$try" -gt "3" ]; then
    error "rsync failes 4 times, exiting"
    run_cmd "rm  $lockfile"
    exit 1;
  fi
done

# Point current symbolic link to new backup

if [  "$ret_code" -ne "0" ]; then
  run_cmd "rm -rf $new_backup" # rsync failed so delete its target directory, should never get here
else
  run_cmd "rm -f $latest_backup"
  run_cmd "ln -s $new_backup $latest_backup"
fi

source end.bash

