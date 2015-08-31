# function.inc.bash - funkybackup global functions
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

function log {
	log_text="$logstamp $basename $1"

	if [ $interactive -eq 1 ]; then
		echo  $log_text
	else
		echo "$logstamp $basename $1" >> $logfile
	fi
}

function log_file {
	while read line 
	do
		log "$line" 
	done < "$1"
}

function run_cmd {
	tmp_log=/tmp/$$_cmd.log

	log "$1"

	$1 > $tmp_log 2>&1

	ret=$?

	if [ -f $tmp_log ]; then
  		log_file $tmp_log
	fi

#	if [ $ret -ne 0 ]; then
#	  error "$ret : $1"
#	fi
}

function send_email {
	subject="$1"
	message="$2"
	file="$3"

	temp_file=/tmp/$0_$$.send_email.txt

	log "Sendind subject=$subject, message=$message, file=$file"

	echo $message >> $temp_file

	if [ ! -z $file ]; then # $file set
  		echo		>> $temp_file
  		cat $file	>> $temp_file
	fi

	mail -s "$subject" $to_email < $temp_file

	file="" # in case this is called twice
}

function error {
	log "ERROR $1"
	send_email "Error from $0" "$1"
}
