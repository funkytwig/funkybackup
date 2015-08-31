#!/bin/bash 

source vars.inc.bash

bash ./backup_close_period.bash $1 >> $logfile 2>&1
