#!/bin/bash

# Red colour
RED="^c#FF0000^"
# Green colour
GREEN="^00FF00^"
# No Colour
NC="^d^"
# Delimiter
DELIM=" | "

LOW_BAT=false

function battery() {
    bat=$(< /sys/class/power_supply/BAT1/capacity)
    
    if (($bat < 25)); then
        if (( $bat <= 10 )) && [ "$LOW_BAT" = false ]; then
            LOW_BAT=true
            notify-send -u critical "Low Battery" "Battery is $bat% plug into charger"
        fi
        LOW_BAT=false
        echo "$bat%" # $(~/suckless-builds/d-icons/battery-0.svg)"
    elif (($bat < 50)); then
        LOW_BAT=false
        echo "$bat%" # $(~/suckless-builds/d-icons/battery-1.svg)"
    elif (($bat < 75)); then
        LOW_BAT=false
        echo "$bat%" # $(~/suckless-builds/d-icons/battery-2.svg)"
    else
        LOW_BAT=false
        echo "$bat%" # $(~/suckless-builds/d-icons/battery-3.svg)"
    fi
}

function volume() {
    vol=$(amixer -M get Master | awk -F'[][]' 'END{ print $2 }')
    if ((${vol::-1} == 0)); then
        echo "mute"
    elif ((${vol::-1} < 25)); then
        echo "$vol"
    elif ((${vol::-1} < 50)); then
        echo "$vol"
    elif ((${vol::-1} < 75)); then
        echo "$vol"
    else
        echo "$vol"
    fi
}

function wifi() {
    ethernetstatus=$(cat /sys/class/net/enp2s0/operstate)
    if [[ "$ethernetstatus" == "up" ]]; then
        echo "$ethernetstatus pluged in $ip"
    else
        wifistatus=$(cat /sys/class/net/wlp4s0/operstate)
        if [[ "$wifistatus" == "up" ]]; then
            echo "wifi on"
        fi
    fi
    ip=$(wget http://ipecho.net/plain -O - -q)
    echo  "$RED$ip$NC"
}

function weather() {
    d=$(head -n 1 wttr.txt)
    if [ "$d" != $(date "+%d/%m/%Y") ]; then
        date "+%d/%m/%Y" > wttr.txt
        curl wttr.in/Melbourne?format=%t%w >> wttr.txt
    fi
    echo "$(head -n 2 wttr.txt | grep C | sed -e 's/C/C /g')"
}

function status() {

    echo $DELIM

    weather

    echo $DELIM

    wifi

    echo $DELIM
    
    battery

    echo $DELIM

    volume

    echo $DELIM

    date "+%d/%m/%Y %I:%M"
}

while :; do
    xsetroot -name "$(status | tr '\n' ' ')"

    # Sleep for 1 minute before updating the status bar
    sleep 1m
done
