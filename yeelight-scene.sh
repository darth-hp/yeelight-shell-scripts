#!/usr/bin/env bash

# Setup your scenes and adjust the scenes below
SCENES="On|Off|Sunrise|Sunset|Sleep|Rainbow|Disco|2700|4300|6500|Off1Min|Stop|Dim|Warm"

set -E
trap '[ "$?" -ne 99 ] || exit 99' ERR

DISCOSPEED=${DISCOSPEED:-600}

IDMSG="ID must be a number"
SCENEMSG="SCENE value must be one of '$SCENES'"

usage(){
	echo "Usage: $( basename $0 ) <ID> <SCENE>"
	echo "  $IDMSG"
	echo "  $SCENEMSG"
	echo "    Disco accepts a duration (default 600) in milli seconds between 50 and 99999"
	echo "    Example: 'DISCOSPEED=120 $0 <ID> Disco'"
}

# Calculate rainbow
rainbow() {
	# Color cycle - 10 is maximum, so 8000FF is left out
	declare -a RB=(0000FF 0080FF 00FF80 00FF00 80FF00 FFFF00 FF8000 FF0000 FF0080 FF00FF)
	[[ ${#RB[*]} -gt 10 ]] && echo "ERROR: Maximum number of color-flows is 10 - here ${#RB[*]}" >&2 && exit 99
	[[ ! "$1" =~ ^[0-9]+$ || "$1" -lt 50 || "$1" -gt 99999 ]] && echo "ERROR: Duration must be between 50 and 99999 - is $1" >&2 && exit 99
	duration=$1
	# color mode
	mode=1
	# light intensity in %
	brightness=100
	for ((i=0; i<${#RB[*]}; i++)); do
		echo -n "$([[ $i -ne 0 ]] && echo -n ",")$duration,$mode,$((16#${RB[i]})),$brightness"
	done
}

[[ "$#" -ne 2 ]] && usage && exit 1
[[ ! "$1" =~ ^[0-9]+$ ]] && echo "ERROR: $IDMSG" && exit 1
[[ ! "$2" =~ ^($SCENES)$ ]] && echo "ERROR: $SCENEMSG" && exit 1

# cf - Color Flow: count (0=infinite), action (0=recover,1=stay,2=off), flow_expression
# A flow expression is a series of tuples - [duration (ms, min 50), mode, value, brightness]
# For mode: 1=color, 2=color temperature (ct), 7 sleep
# For value: color or ct depending on mode, ignored with mode 7
# For brightness: 1 - 100, ignored with mode 7

[[ "$2" = "On" ]] && SC='"method":"set_power","params":["on"]'
[[ "$2" = "Off" ]] && SC='"method":"set_power","params":["off"]'
[[ "$2" = "Sunrise" ]] && SC='"method":"set_scene","params":["cf",2,1,"50,2,4000,1,900000,2,4000,100"]'
[[ "$2" = "Sunrise2" ]] && SC='"method":"set_scene","params":["cf",2,1,"50,1,16731392,1,360000,2,1700,10,540000,2,2700,100"]'
[[ "$2" = "Sunset" ]] && SC='"method":"set_scene","params":["cf",2,2,"50,2,4000,100,900000,2,4000,1"]'
[[ "$2" = "Sleep" ]] && SC='"method":"set_scene","params":["cf",24,2,"4000,2,4000,30,7000,2,4000,10,8000,2,4000,1"]'
[[ "$2" = "Rainbow" ]] && SC='"method":"set_scene","params":["cf",0,1,"'$(rainbow 3000)'"]'
[[ "$2" = "Disco" ]] && SC='"method":"set_scene","params":["cf",0,1,"'$(rainbow $DISCOSPEED)'"]'
[[ "$2" = "2700" ]] && SC='"method":"set_scene","params":["ct",2700,100]'
[[ "$2" = "4300" ]] && SC='"method":"set_scene","params":["ct",4300,100]'
[[ "$2" = "6500" ]] && SC='"method":"set_scene","params":["ct",6500,100]'
[[ "$2" = "Off1Min" ]] && SC='"method":"set_scene","params":["cf",2,2,"50,1,16777215,100,36000,1,16777215,1"]'
[[ "$2" = "Stop" ]] && SC='"method":"stop_cf","params":[]' 
[[ "$2" = "Dim" ]] && SC='"method":"set_scene","params":["ct",1000,10]'
[[ "$2" = "Warm" ]] && SC='"method":"set_scene","params":["ct",3200,100]'

$( dirname $0 )/yeelight.sh "$1" "$SC"
