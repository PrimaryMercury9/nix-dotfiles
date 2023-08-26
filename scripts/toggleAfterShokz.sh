#!/usr/bin/env bash

device="20:74:CF:CB:8A:20"
if bluetoothctl info "$device" | grep 'Connected: yes' -q; then
    bluetoothctl disconnect "$device"
else
    bluetoothctl connect "$device"
fi
#Connect HD450
#bluetoothctl connect 00:1B:66:05:4C:BE
