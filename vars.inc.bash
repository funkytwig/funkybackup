# vars - funkybackup configuration script
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

set -f

backup_name=bash
script_home=/home/pi/bash/
what_to_backup=/home/pi/bash/.
exclude="*.tmp"
path_to_store_backups=/home/pi/backups
to_email=ben@funkytwig.com
link_down_max_min=1 # if link missing for rore than this send email

# You should not need to change anything below this line

interactive=0
user=`id -u -n`
latest_backup=$path_to_store_backups/${backup_name}_9999999999_current
logstamp=`date +%D_%R`
logfile=/var/log/funkybackup.$user.log
basename=`basename $0 .bash`
waitfile=/tmp/${user}_${backup_name}_wait.tmp
lockfile=/tmp/${user}_${backup_name}_lock.tmp

set +f
