#!/usr/bin/env bash

exec swayidle -w \
    timeout 5 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"'
