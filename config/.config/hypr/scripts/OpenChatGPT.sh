#!/bin/bash

# Get the IDs of workspaces where Brave browser windows are present
braveonWorspaces=$(hyprctl -j clients | jq -r '.[] | select(.class == "Brave-browser") | .workspace.id')

# Open ChatGPT in a new tab if Brave is running on the current workspace
for workspaceID in $braveonWorspaces; do
  currentWorkspace=$(hyprctl activeworkspace | grep 'ID' | awk 'NR==1 {print $3}')
  if [[ "$workspaceID" == "$currentWorkspace" ]]; then
    brave https://chatgpt.com
    exit 0
  fi
done

# If Brave is not on the current workspace, open a new window with ChatGPT
brave --new-window https://chatgpt.com
