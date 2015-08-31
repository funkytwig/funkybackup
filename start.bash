# start.bash
#

function check_dir_exists {
	directory=$1
	total_down_min=0;
	loop_pass_since_error=0 # a link pass is actualy a minute as the wait it 60 (seconds)

	while [ ! -d "$directory" ]
	do
		touch waiting.tmp
		lock_pass_since_error=$((lock_pass+1))
		sleep 60
		if [ ! -d $directory ]; then
			total_down_min=$((total_down_min+1))
	       		log "$directory down for 60 seconds"

       			if [ $lock_pass_since_error -gt $link_down_max_min ]; then
	        		error "$directory not accessable for more then $total_down_min minutes"
			fi
 			loop_pass_since_error=0
		else
			# finished waiting
			rm waiting.tmp
		fi
        done

}

# if another script is waiting for a directory to become available (check_dir_exists) exit script otherwise
# cron will spawn lots of scripts that will all run at once.

if [ -f waiting.tmp ]; then
  log "Another script is waiting for directory to become available to exit"
  exit 1
fi

# make sure all varables set in vars.inc.bash

if [ -z "$path_to_store_backups" ]; then
  error "Backup target directory not set"
  exit 1
fi

if [ -z "$what_to_backup" ]; then
  error "Backup source directory not set"
  exit 1
fi

if [ -z "$backup_name" ]; then
  error "backup name not set"
  exit 1
fi

# make sure onle one script is running at once

lock_pass=0

while [ -f backup.lock.tmp ] 
do
        lock_pass=$((lock_pass+1))
	log "Waiting 15 seconds for lock (pass $lock_pass)"
        sleep 15
        if [ $lock_pass -gt 60 ]; then
                error "Waiting for lock for more than 15 minutes" 
                exit 1
        fi
done

touch backup.lock.tmp


# ensure backup directory is present, if it is not this may be it is a USB drive and use total_down_min to warn if backup
# has not been done for a while. This will also warn if link has got broked, if this hapens the backup will become a full
# rather than incramental and lots of disk space will be used.  Need to add check to see if the link is broke rather than
# just missing but for now both are treated the same.  A auto repair can be added to recreate link if it is missing (i.e.
# does not point to a calid directory).

check_dir_exists $what_to_backup
check_dir_exists $path_to_store_backups

# set script start here as it is to show how long the actual work took (i.e. dont include backup directory down or lock wait

script_start=`date +%s` # julian seconds
