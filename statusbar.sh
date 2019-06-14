#!/bin/bash 

delim=" | "

function status() {
    echo $delim
    
   
    echo "$(cat /sys/class/power_supply/BAT1/capacity)%"
    
    echo $delim

    amixer get Master | awk -F'[][]' 'END{ print $2 }'

    echo $delim

    date "+%d/%m/%Y %I:%M"
}

while :; do
    xsetroot -name "$(status | tr '\n' ' ')"

    # Sleep for 1 minute before updating the status bar
    sleep 1m
done
