#!/bin/bash
LOW_BATTERY_THRESHOLD=15

BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT1/status)

if [ "$BATTERY_STATUS" != "Charging" ] && [ "$BATTERY_LEVEL" -le "$LOW_BATTERY_THRESHOLD" ]; then
  notify-send -u critical "Low Battery" "Battery at ${BATTERY_LEVEL}%. Please charge your device."
fi
