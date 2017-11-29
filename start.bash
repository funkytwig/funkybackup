# start.bash
#

function check_dir_exists {
  directory=$1

  if [ ! -d "$directory" ]; then
        error "$directory not does not exits, exiting"
  	exit 1;
  fi
}

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

if [ -f $lockfile ]; then
  error "Another script is running ($lockfile exists), exiting"
  exit 1;
fi 

# ensure backup directory is present, if it is not this may be it is a USB drive and use total_down_min to warn if backup
# has not been done for a while. This will also warn if link has got broked, if this hapens the backup will become a full
# rather than incramental and lots of disk space will be used.  Need to add check to see if the link is broke rather than
# just missing but for now both are treated the same.  A auto repair can be added to recreate link if it is missing (i.e.
# does not point to a calid directory).

#check_dir_exists $what_to_backup
check_dir_exists $path_to_store_backups

touch $lockfile

# set script start here as it is to show how long the actual work took (i.e. dont include backup directory down or lock wait

script_start=`date +%s` # julian seconds
