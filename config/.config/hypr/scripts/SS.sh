#!/bin/bash

hyprshot -s -z -m region -o /tmp -f ss.png
wl-copy < /tmp/ss.png
notify-send -u low -i /tmp/ss.png "ScreenShot saved on clipboard"
