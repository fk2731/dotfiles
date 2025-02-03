#!/bin/bash

hyprshot -s -z -m region -o /tmp -f ss.png
notify-send -u low -i /tmp/ss.png "ScreenShot saved on clipboard"
sleep 1
wl-copy < /tmp/ss.png
