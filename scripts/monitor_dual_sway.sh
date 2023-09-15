#!/usr/bin/env bash

#rm $HOME/.config/hypr/monitors.conf
ln -sf $HOME/.config/sway/monitor_dual $HOME/.config/sway/monitor
swaymsg reload
