#!/bin/bash

move=false

# If Spotify is already open, notify and exit
if [[ -n $(hyprctl -j clients | jq -r '.[] | select(.class == "Spotify")') ]]; then
  notify-send -u low "Already open" -i spotify "Spotify open at workspace: $(hyprctl -j clients | jq -r '.[] | select(.class == "Spotify") | .workspace.id')"
  exit 0
fi

# Get current workspace ID
current_ws=$(hyprctl activeworkspace | grep 'ID' | awk 'NR==1 {print $3}')
# Check if the current workspace is in use (has any client)
if [[ -n $(hyprctl clients | grep "workspace" | grep "$current_ws") ]]; then
  # Switch to an empty workspace
  kitty --title Cava --hold cava &
  sleep 1
  hyprctl dispatch movetoworkspace empty n+1 &
  move=true
fi

# Launch Spotify in the (now) current workspace
spotify --title Spotify &

# Wait until Spotify is loaded
sleep 1

# Move the cursor to a specific corner
hyprctl dispatch movecursortocorner 2

# Launch Cava in kitty in the same workspace
if ! $move; then
  kitty --title Cava --hold cava &
  # Wait until all is loaded
  sleep 1
else
  hyprctl dispatch swapnext
fi

# Adjust window positions
hyprctl dispatch togglesplit dwindle

# Resize windows
hyprctl dispatch resizeactive 0 300

# Wait a bit for everything to settle
sleep 1

if ! $move; then
  # Return focus to Spotify
  hyprctl dispatch movefocus u
fi
