#!/bin/bash 

delim=" | "

function battery() {
    bat=$(< /sys/class/power_supply/BAT1/capacity)
    
    if (($bat < 25));
    then
        echo "$bat%" # $(~/suckless-builds/d-icons/battery-0.svg)"
    elif (($bat < 50));
    then
        echo "$bat%" # $(~/suckless-builds/d-icons/battery-1.svg)"
    elif (($bat < 75));
    then
        echo "$bat%" # $(~/suckless-builds/d-icons/battery-2.svg)"
    else
        echo "$bat%" # $(~/suckless-builds/d-icons/battery-3.svg)"
    fi
}

function volume() {
    vol=$(amixer -M get Master | awk -F'[][]' 'END{ print $2 }')

    if (($vol == 0));
    then
        echo "mute"
    elif (($vol < 25));
    then
        echo "$vol"
    elif (($vol < 50));
    then
        echo "$vol"
    elif (($vol < 75));
    then
        echo "$vol"
    else
        echo "$vol"
    fi
}

function status() {
    echo $delim
    
    echo $(battery)

    echo $delim

    vol=$(amixer -M get Master | awk -F'[][]' 'END{ print $2 }')
    echo $vol

    echo $delim

    date "+%d/%m/%Y %I:%M"
}


while :; do
    xsetroot -name "$(status | tr '\n' ' ')"

    # Sleep for 1 minute before updating the status bar
    sleep 1m
done
