#!/bin/bash

spotify --title Spotify &

# Open Cava in kitty
kitty --title Cava --hold cava &

# Wait till all is loaded
sleep 1

# Adjust windows position
hyprctl dispatch togglesplit dwindle

# Focus Cava
hyprctl dispatch focuswindow title:Cava

# resize fly_is_kitty to a small window
hyprctl dispatch resizeactive 0 300

# Return to focus Spotify
hyprctl dispatch focuswindow title:Spotify

