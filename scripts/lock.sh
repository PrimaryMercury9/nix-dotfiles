#!/usr/bin/env bash

# If idle for 15s, power down the output
swayidle -w \
		timeout 15 'swaymsg "output * dpms off"' \
		resume 'swaymsg "output * dpms on"' &

# Lock screen immediately
swaylock -e -F --config $HOME/.config/swaylock/config --image $HOME/dotfiles/wallpapers/sym5nxxh4el71.png

# Kill the last instance of swayidle so the timer doesn't keep running in background
pkill --newest swayidle
