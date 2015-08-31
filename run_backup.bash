#!/bin/bash 

source vars.inc.bash

bash ./backup.bash >> $logfile 2>&1
