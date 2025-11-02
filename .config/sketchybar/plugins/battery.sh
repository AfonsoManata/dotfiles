#!/bin/bash

# Load colors
source "$CONFIG_DIR/colors.sh"

# Get battery percentage (integer)
PERCENTAGE=$(pmset -g batt | grep -Eo "[0-9]+%" | tr -d '%')

# Check if charging
CHARGING=$(pmset -g batt | grep "AC Power")

ICON="🔋"
[ -n "$CHARGING" ] && ICON="🔌"

if [ "$PERCENTAGE" -le 25 ]; then
	COLOR="$RED"
elif [ "$PERCENTAGE" -le 40 ]; then
	COLOR="$ORANGE"
else
	COLOR="$BLUE"
fi

# Update SketchyBar item
sketchybar --set "$NAME" \
	icon="$ICON" \
	icon.color="$COLOR" \
	label="${PERCENTAGE}%" \
	label.color="$COLOR" \
	padding_right=0
