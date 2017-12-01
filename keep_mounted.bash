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
# This is run as root every minute 9or less often) to try to remount drives if lost

source vars.inc.bash
source function.inc.bash

if [ ! -d $path_to_store_backups ]; then
  log "Atemting to remount(`pwd`)"
  mount -a
fi
