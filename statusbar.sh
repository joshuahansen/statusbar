#!/bin/bash 

delim=" | "

function status() {
    echo $delim
    date "+%d/%m/%Y %I:%M"
}

while :; do
    xsetroot -name "$(status | tr '\n' ' ')"

    # Sleep for 1 minute before updating the status bar
    sleep 10s
done
