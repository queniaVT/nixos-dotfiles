#!/bin/sh

niri msg action quit #--skip-confirmation

while pgrep -x niri >/dev/null; do
    sleep 0.1
done

systemctl reboot
