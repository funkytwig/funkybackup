#!/bin/bash 

source vars.inc.bash
source function.inc.bash
source start.bash

prev_back_type=H
cmin=60

find_cmd="find -maxdepth 1 -type d -name "
find_cmd+='"'
find_cmd+="$backup_name*_${prev_back_type}_*"
find_cmd+='"'
find_cmd+=" -cmin +$cmin -print -exec rm -r {} \;"

echo $find_cmd

$find_cmd

source end.bash
