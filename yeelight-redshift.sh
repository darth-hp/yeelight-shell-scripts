#!/bin/bash

redshift -p &> redshift_out
string=$(cat redshift_out | grep Color)
temp=$(echo $string | tr -d -c 0-9)
bright=$(python -c "print(round($temp*0.02-30))")
temp=$(python -c "print(round($temp*1.75-4875))")  #adjust constants for your preference
$( dirname $0 )/yeelight-colortemp.sh 0 $temp
$( dirname $0 )/yeelight-brightness.sh 0 $bright
