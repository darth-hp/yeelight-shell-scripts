#!/bin/bash
# Put all your Yeelights separated with spaces here
declare -a ID=(192.168.112.110)

[[ "$#" -ne 2 ]] && echo "Usage: $( basename $0 ) <ID> <JSON>" && exit 1
[[ ! "$1" =~ ^[0-9]+$ ]] && echo "ID value must be a number" && exit 1
[[ $1 -gt $(( ${#ID[@]} -1 )) ]] && echo "ID must be between 0 and $(( ${#ID[@]} -1 ))" && exit 1
echo "Executing on ID $1 [${ID[$1]}] ..."
printf "{\"id\":1,$2}\r\n" >/dev/tcp/${ID[$1]}/55443
