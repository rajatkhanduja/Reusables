#!/bin/bash
# Author : Rajat Khanduja
# Script to check the temperature and warn if it is critical (requires espeak)
#
# NOTE : The warning is logged into the file $HOME/tmp_log.
#
# Options :-
# -r range    : Temperature range is provided using Regular expression, such as 9[5-9] symbolizes temperature from 95-99
# -l val      : Set value for logging (0 or 1). Defaults to 1, i.e. logging is ON
# -f logfile  : Log file is set to 'logfile'. Defaults to '$HOME/tmp_log'.
# -d delay    : Time delay. defaults to 3s
# -m message  : The warning 'message' defaults to "Critical Temperature Warning"
# -h          : Prints the help message
#
#
# Usage :-
#
# tempAlarm [-n] [-d delay] range 
#

WARNING_MESSAGE="Critical Temperature Warning"
LOG_FILE="$HOME/tmp_log"
LOGGING=1
DELAY='3s'

function usage()
{
  echo "Usage:"
  echo $0 "-r range [-l val] [-d delay] [-m message]"
  echo "  Options:"
  echo "    -h          Show this message"
  echo "    -r range    Set critical temperature range (using RegEx)"
  echo "    -l val      Set logging 0 (off) or 1 (on)."
  echo "    -f logfile  Set log file to 'logfile'."
  echo "    -m message  Set message to be read on reaching critical temperature"
}

while getopts 'r:h:l:d:m:f:' OPTION
do
  case $OPTION in
    h)
      usage
      exit
      ;;
    l)
      LOGGING=$OPTARG
      ;;
    d)
      DELAY=$OPTARG
      ;;
    m)
      WARNING_MESSAGE=$OPTARG
      ;;
    r)
      TEMP_RANGE=$OPTARG
      ;;
    f)
      LOG_FILE=$OPTARG
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

if [ $LOGGING -eq 1 ]
then
  # Ensure that the log-file exists
  if [ ! -e $LOG_FILE ]
  then
    # create the file
    echo "Log file not found, creating ... "
    touch $LOG_FILE
  fi
fi

while [ 1 ]
do
	t=$(sensors|egrep $TEMP_RANGE)
	if [ ${#t} -ne 0 ]
	then
		espeak "$WARNING_MESSAGE"

    # Log the current temperature
    if [ $LOGGING -eq 1 ]
    then
      echo $(date) : $t >> $LOG_FILE
    fi

	fi

	sleep $DELAY
done

