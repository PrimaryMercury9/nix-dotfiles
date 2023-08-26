#!/usr/bin/env bash

CONFIG="$HOME/.config/waybar/config"
STYLE="$HOME/.config/waybar/style.css"

if pgrep -f waybar &> /dev/null 2>&1; then
pkill waybar
waybar -c $CONFIG -s $STYLE > /dev/null 2>&1 &
else
if [[ $(pgrep -x "waybar") = "" ]]; then
waybar -c $CONFIG -s $STYLE > /dev/null 2>&1 &
fi
fi
