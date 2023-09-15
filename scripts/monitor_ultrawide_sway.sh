#!/usr/bin/env bash

#rm $HOME/.config/hypr/monitor.conf
ln -sf $HOME/.config/sway/monitor_ultra $HOME/.config/sway/monitor
swaymsg reload
