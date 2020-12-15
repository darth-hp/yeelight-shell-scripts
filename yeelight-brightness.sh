#!/usr/bin/env bash

IDMSG="ID must be a number"
BRIMSG="BRIGHTNESS must be a number between 0 and 100"

usage(){
	echo "Usage: $( basename $0 ) <ID> <BRIGHTNESS>"
	echo "  $IDMSG"
	echo "  $BRIMSG"
}

[[ "$#" -ne 2 ]] && usage && exit 1
[[ ! "$1" =~ ^[0-9]+$ ]] && echo "ERROR: $IDMSG" && exit 1
[[ ! "$2" =~ ^[0-9]+$ || "$2" -gt 100 ]] && echo "ERROR: $BRIMSG" && exit 1

ct='"method":"set_bright","params":['$2',"smooth",200]'

$( dirname $0 )/yeelight.sh "$1" "$ct"
