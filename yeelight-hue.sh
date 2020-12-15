#!/usr/bin/env bash

IDMSG="ID must be a number"
HUEMSG="HUE must be a number between 0 and 359"
BRIMSG="BRIGHTNESS must be a number between 0 and 100"

usage(){
	echo "Usage: $( basename $0 ) <ID> <HUE> <BRIGHTNESS>"
	echo "  $IDMSG"
	echo "  $HUEMSG"
	echo "  $BRIMSG"
}

[[ "$#" -ne 3 ]] && usage && exit 1
[[ ! "$1" =~ ^[0-9]+$ ]] && echo "ERROR: $IDMSG" && exit 1
[[ ! "$2" =~ ^[0-9]+$ || "$2" -gt 359 ]] && echo "ERROR: $HUEMSG" && exit 1
[[ ! "$3" =~ ^[0-9]+$ || "$3" -gt 100 ]] && echo "ERROR: $BRIMSG" && exit 1

ct='"method":"set_hsv","params":['$2','$3',"smooth",200]'

$( dirname $0 )/yeelight.sh "$1" "$ct"
