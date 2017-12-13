#!/bin/bash

source vars.inc.bash
source function.inc.bash

temp_file=/tmp/$0_$$.log.txt

log "file=$temp_file"

today=`date +%D`

grep "$today" $logfile > $temp_file

send_email "$HOSTNAME funkybackup ($today)" "Here is todays funkybackup logfile" "$temp_file"
