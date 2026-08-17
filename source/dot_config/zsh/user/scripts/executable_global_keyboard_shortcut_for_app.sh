#!/bin/bash

# Function to check if an application is running
is_app_running() {
    app_name="$1"
    pgrep -x "$app_name" >/dev/null
    return $?
}

# Function to send a keystroke to System Events
send_keystroke() {
    key="$1"
    modifiers="$2" # e.g., "command down, control down"
    
    osascript -e "
    tell application \"System Events\"
      keystroke \"$key\" using {$modifiers}
    end tell
    "
}

# Get application name, key, and modifiers from command line arguments
APP_NAME="$1"
KEY="$2"
MODIFIERS="$3" # Comma-separated list of modifiers, e.g., "command,control"

# Validate inputs
if [ -z "$APP_NAME" ] || [ -z "$KEY" ] || [ -z "$MODIFIERS" ]; then
    echo "Usage: $0 <app_name> <key> <modifier1,modifier2,...>"
    echo "Example: $0 Todoist t command,control"
    exit 1
fi

# Convert comma-separated modifiers to AppleScript format
convert_modifiers() {
    local input="$1"
    local output=""
    local IFS=','
    for modifier in $input; do
        case "$modifier" in
            command) output+="command down, " ;;
            control) output+="control down, " ;;
            option) output+="option down, " ;;
            shift) output+="shift down, " ;;
            *)
                echo "Invalid modifier: $modifier"
                exit 1
            ;;
        esac
    done
    # Remove trailing comma and space
    echo "${output%, }"
}

APPLESCRIPT_MODIFIERS=$(convert_modifiers "$MODIFIERS")

# Check if the application is running
if is_app_running "$APP_NAME"; then
    # Application is running, send the keystroke
    send_keystroke "$KEY" "$APPLESCRIPT_MODIFIERS"
else
    # Application is not running, launch it and wait until it's running
    open -a "$APP_NAME"
    
    # Wait until the application is running (with a timeout)
    timeout=30 # Timeout in seconds
    start_time=$(date +%s)
    
    while ! is_app_running "$APP_NAME"; do
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))
        
        if ((elapsed_time > timeout)); then
            echo "Timeout waiting for $APP_NAME to launch."
            exit 1
        fi
        
        sleep 1 # Check every 1 second
    done
    
    # Application is now running, send the keystroke
    sleep 2 # Give it a moment to fully launch before sending the keystroke
    
    send_keystroke "$KEY" "$APPLESCRIPT_MODIFIERS"
fi

exit 0
