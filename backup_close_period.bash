#!/bin/bash 
#
# backup_close_period.bash - funkybackup script run at end of periods
#
# For more details about the script and to me goto 
# http://www.funkytwig.com/blog/funkybackup
#
# (c) 2015 Ben Edwards (funkytwig.com) 
# You are alowed to use the script if you keep this head0er 
# and do not redistibute it, just send people to the URL
#
# Ver   Coments
# 0.5   Initial version
# 
# This script has the word close in its title as it is used at the end 
# of a period (hour, Day, Month, Year) or as sometimes is called the 
# 'Close of Play'. It does two things. The script is passed an argument 
# when it is called to say what ype of backup it s creating (H, D, M, Y).) 
#
# It renames a directory to turn
# the frequent backups into Hourly, Daily, Mnothly or Yearly backups 
# and it deletes expired backups. I will describe how the hourly 
# backups work as the rest simply use the same princaply.  
#
# For hourly backups the script is run at the end of the hour.  It
# first finds the lateest Frequent backup (searching for the latest
# directory with *_F_* in its name on the current date/hour (using 
# directory names rather than linux date/time). It then renames the 
# directory replacing the _F_ with a _H_.  Thus creating and hourly 
# backup. 
#
# To delete expired frequent backups it finds and directories older
# then 60 minutes with _F_ in there name.
#
# For daily backups the latest one with _H_ in its name had the 
# H changed to D and the hourly backups (_H_) older then a day 
# (1440 niutes) are deleted. The same princably aplies to Monthly 
# and Yearly except Yearly backups are not deleted automaticaly.
#
# Varables
# datetime_mask	Used to find backups in current period
# prev_back_type	The period code for previous backup types
# to_period	The period code for curent backup type
# cmin		The number of mins to keep prev_back_type
#               backups for
# 
   
source vars.inc.bash
source function.inc.bash
source start.bash

this_back_type=$1

if [ -z "$this_back_type" ]; then
  error "Backup type argument missing"
else

  case "$this_back_type" in
          "H") datetime_mask=`date +%d%b%Y_%H` # close hour
               prev_back_type="F"
               cmin=60;;
          "D") datetime_mask=`date +%d%b%Y` # close day
               prev_back_type="H"
               cmin=1440;; 
          "M") datetime_mask=`date +%b%Y` # close month
               prev_back_type="D"
	       cmin=44640;;
          "Y") datetime_mask=`date +%Y` # close year
               prev_back_type="M"
	       cmin=525949;;
  esac

  log="backup type=$this_back_type, datetime_mask=$datetime_mask, " 
  log+="previous backup type=$prev_back_type, cmin=$cmin"

  log "$log"

  cd $path_to_store_backups

  # Get name of the directory to make into curent backup type 

  mask="$backup_name*_${prev_back_type}_*$datetime_mask*"

  log "geting latest directory matching $mask"

  last_dir=`ls -d1 $mask | grep -v current | sort | tail -1`

  if [ -z "$last_dir" ]; then
    error "No last directory found"
  else

    rename_to=`echo $last_dir | sed "s/_${prev_back_type}_/_${this_back_type}_/g"`

    run_cmd "rm -f $latest_backup"
    run_cmd "mv $last_dir $rename_to"
    run_cmd "ln -s $rename_to $latest_backup"

    log "deleting $prev_back_type backups older than $cmin minutes"

    tmp_log=/tmp/$$_find.log

    find -maxdepth 1 -type d -name "$backup_name*_${prev_back_type}_*"  \
         -cmin +$cmin -print -exec rm -r {} \; > $tmp_log 2>&1

    if [ -f $tmp_log ]; then
      log_file $tmp_log
    fi
  fi
fi

cd $script_home

source end.bash
