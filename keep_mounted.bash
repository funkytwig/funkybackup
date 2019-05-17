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
# This is run as root (from its directory) to try to remount all drives if backup volume becomes unmounted
# It is designed to only create output if this happens

source vars.inc.bash
source function.inc.bash

if [ ! -d $path_to_store_backups ]; then
  printf "Atemting to remount all volumes\n"
  mount -va
fi
