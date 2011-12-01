#!/bin/bash
# Author : Rajat Khanduja
# This script converts values listed in different lines to a CSV string. 
#
# Usage :-
# 
# lines2csv [-f filename] [-s separator] [-c]
#
# Options :-
# -h            Help message
# -s            Use 'separator' for separation, instead of ','
# -f filename   Read from 'filename' rather than stdin       
#
#
# EXIT STATUS :-
# 0 -> Successful
# 1 -> Incorrect option
# 2 -> File doesn't exist
#

SUCCESS=0
INCORRECT_OPTION=1
FILE_NOT_EXIST=2

function usage()
{
  echo "Usage:"
  echo $0 "[-f filename] [-s separator]"

  echo "  Options :"
  echo "    -h            Show this message"
  echo "    -s separator  Use 'separator' for separation, instead of ','"
  echo "    -f file       Read from 'file' rather than stdin" 
}

function to_csv ()
{
  # Function that converts list to csv
  # Arguments :- 
  #
  # $1 :- Separator

  SEPARATOR=$1
  csv_list=""

  while read val
  do

	  if [ ${#val} -eq 0 ]; then
		  continue
	  fi
	
  	if [ ${#csv_list} -eq 0 ]
	  then
		  csv_list=$val
  	else
	  	csv_list=$csv_list$SEPARATOR$val
  	fi
  done

  echo $csv_list
}

while getopts 'hf:s:c' OPTION
do
  case $OPTION in
    h)
      usage
      exit
      ;;
      
    f)
      FILENAME=$OPTARG
      ;;
    s)
      SEPARATOR=$OPTARG
      ;;
    ?)
      usage
      exit $INCORRECT_OPTION
  esac
done

if [ -z $SEPARATOR ]
then
  SEPARATOR=','
fi

if [ -z $FILENAME ]
then
  # FILENAME variable is not set.
#  echo "Reading from stdin"
  to_csv $SEPARATOR
else 
  if [ -e $FILENAME ]
  then
#    echo "Reading from "$FILENAME
    cat $FILENAME | to_csv $SEPARATOR
  else
    echo "File does not exist"
    exit $FILE_NOT_EXIST
  fi
fi
