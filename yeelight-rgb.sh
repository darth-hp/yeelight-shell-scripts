#!/usr/bin/env bash

set -E
trap '[ "$?" -ne 99 ] || exit 99' ERR

IDMSG="ID must be a number"
RGBMSG="RGB Absolut number between 0 and 16777215"
RGBnMSG="R,G,B RGB number (0-255) separated by comma"
RGBxMSG="xR,G,B RGB number (00-FF) separated by comma, "
RGBxMSG+="leading zero optional, A-F upper or lower case"

usage(){
	echo "Usage: $( basename $0 ) <ID> <RGB|R,G,B|xR,G,B>"
	echo "  $IDMSG"
	echo "  $RGBMSG"
	echo "  $RGBnMSG"
	echo "  $RGBxMSG"
}

testRgbVal(){
	if [[ "$1" -gt 255 ]]; then
		echo "ERROR: Part of the given R,G,B is to big - is $1"
		exit 99
	fi
}

[[ "$#" -ne 2 ]] && usage && exit 1
[[ ! "$1" =~ ^[0-9]+$ ]] && echo "ID must be a number" && exit 1

# Only a number
match="^[0-9]+$"
if [[ "$2" =~ $match ]]; then
	if [[ "$2" -gt 16777215 ]]; then
		echo "ERROR: $RGBMSG - is $2"
		exit 1
	fi
	color=$2
fi

# RGB numbers as decimal
match="^[0-9]+,[0-9]+,[0-9]+$"
if [[ "$2" =~ $match ]]; then
	IFS=',' read -r -a RGB <<< "$2"
	declare -a MULT=(65536 256 1)
	color=0
	for ((i=0; i<${#RGB[*]}; i++)); do
		testRgbVal "${RGB[i]}"
		color=$(( ${RGB[i]} * ${MULT[i]} + $color ))
	done
fi

# RGB numbers as hex
match="^x[0-9a-fA-F]{1,2},[0-9a-fA-F]{1,2},[0-9a-fA-F]{1,2}$"
if [[ "$2" =~ $match ]]; then
	val="${2#x}"
	IFS=',' read -r -a RGB <<< "$val"
	declare -a MULT=(65536 256 1)
	color=0
	for ((i=0; i<${#RGB[*]}; i++)); do
		color=$(( $((16#${RGB[i]})) * ${MULT[i]} + $color ))
	done
fi

if [[ -z "$color" ]]; then
	usage
	exit 1
fi
color='"method":"set_rgb","params":['$color',"smooth",200]'

$( dirname $0 )/yeelight.sh "$1" "$color"
