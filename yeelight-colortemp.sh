#!/usr/bin/env bash

IDMSG="ID must be a number"
CTMSG="CT must be Kelvin between 1700 and 6500"

usage(){
	echo "Usage: $( basename $0 ) <ID> <CT>"
	echo "  $IDMSG"
	echo "  $CTMSG"
}

[[ "$#" -ne 2 ]] && usage && exit 1
[[ ! "$1" =~ ^[0-9]+$ ]] && echo "ERROR: $IDMSG" && exit 1
[[ ! "$2" =~ ^[0-9]+$ || "$2" -lt 1700 || "$2" -gt 6500 ]] && echo "ERROR: $CTMSG" && exit 1

ct='"method":"set_ct_abx","params":['$2',"smooth",200]'

$( dirname $0 )/yeelight.sh "$1" "$ct"
