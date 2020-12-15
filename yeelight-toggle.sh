#!/usr/bin/env bash

IDMSG="ID must be a number"

usage(){
	echo "Usage: $( basename $0 ) <ID>"
	echo "  $IDMSG"
}

[[ "$#" -ne 1 ]] && usage && exit 1
[[ ! "$1" =~ ^[0-9]+$ ]] && echo "ERROR: $IDMSG" && exit 1

ct='"method":"toggle","params":[,,]'

$( dirname $0 )/yeelight.sh "$1" "$ct"
