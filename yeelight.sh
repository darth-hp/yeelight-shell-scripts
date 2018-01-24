#!/bin/bash
# Put all your Yeelights separated by spaces here
declare -a ID=(192.168.112.178 192.168.112.179)

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $( basename $0 ) <ID> <JSON>"
  echo "    With ID set to 0, it will iterate over all IDs"
  exit 1
fi
[[ ! "$1" =~ ^[0-9]+$ ]] && echo "ID value must be a number" && exit 1
[[ $1 -gt ${#ID[@]} ]] && echo "ID value must be between 0 and ${#ID[@]}" && exit 1

fn_send() {
  echo "Executing on ID $1 [${ID[(($1-1))]}] ..."
  printf "{\"id\":1,$2}\r\n" >/dev/tcp/${ID[(($1-1))]}/55443
}

# Not 0? Then just use this and end
[[ $1 -gt 0 ]] && fn_send $1 $2 && exit

# Iterate over all
for ((i=1; i<=${#ID[@]}; i++)); do
  fn_send $i $2
done