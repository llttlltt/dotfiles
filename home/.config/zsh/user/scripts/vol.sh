#!/bin/bash
# Source https://excessivelyadequate.com/posts/vol.html

USAGE="usage: vol [-h | --help | NUMBER_FROM_0_TO_100 | -DECREMENT | +INCREMENT]"

# Display usage if no arguments or -h/--help is provided
if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
	echo "$USAGE"
	exit 1
fi

# Check if the argument is a valid number (with optional +/- prefix)
if ! [[ "$1" =~ ^[+-]?[0-9]+$ ]]; then
	echo "$USAGE"
	exit 1
fi

# Get current volume
OLD_VOLUME=$(osascript -e 'output volume of (get volume settings)')

# Determine new volume
NEW_VOLUME="$1"

# Adjust volume if increment/decrement is specified
if [[ "$1" =~ ^[+-] ]]; then
	NEW_VOLUME=$((OLD_VOLUME + $1))
fi

# Clamp volume between 0 and 100
NEW_VOLUME=$((NEW_VOLUME < 0 ? 0 : NEW_VOLUME > 100 ? 100 : NEW_VOLUME))

# Feedback
MUTED=""
if [ "$NEW_VOLUME" -eq 0 ]; then
	MUTED="(muted)"
fi

echo "$OLD_VOLUME% -> $NEW_VOLUME% $MUTED"

# Set volume
osascript -e "set volume output volume $NEW_VOLUME"
