#!/bin/bash

# auto-dark-mode.sh - Main script for Auto Dark Mode

CONFIG_FILE="$HOME/.config/theme-switcher/config.json"

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration not found. Running setup..."
    $(dirname "$0")/config.sh
fi

# Check for hdate
if ! command -v hdate &> /dev/null; then
    echo "hdate is required but not installed. Installing now..."
    sudo apt-get update && sudo apt-get install -y hdate
fi

# Read config
LATITUDE=$(jq -r '.latitude' "$CONFIG_FILE")
LONGITUDE=$(jq -r '.longitude' "$CONFIG_FILE")
NIGHT_LIGHT=$(jq -r '.night_light' "$CONFIG_FILE")

# Get timezone offset
TIMEZONE_OFFSET=$(date +'%z' | sed -r 's/(.{3})/\1:/' | sed -r 's/([+-])(0)?(.*)/\1\3/')

# Get today's sun times
HDATE_TODAY=$(hdate -s --not-sunset-aware -l "$LATITUDE" -L "$LONGITUDE" -z"$TIMEZONE_OFFSET")
SUNRISE_TODAY=$(echo "$HDATE_TODAY" | grep "sunrise: " | grep -o '[0-2][0-9]:[0-6][0-9]')
SUNSET_TODAY=$(echo "$HDATE_TODAY" | grep "sunset: " | grep -oE '[0-2][0-9]:[0-6][0-9]')

echo "Today's sunrise: $SUNRISE_TODAY"
echo "Today's sunset:  $SUNSET_TODAY"

NOW=$(date +"%Y-%m-%d %H:%M:%S")
echo "Current time: $NOW"

# Convert times to comparable format
COMPARABLE_NOW=$(date --date="$NOW" +%Y%m%d%H%M)
COMPARABLE_SUNRISE_TODAY=$(date --date="$SUNRISE_TODAY" +%Y%m%d%H%M)
COMPARABLE_SUNSET_TODAY=$(date --date="$SUNSET_TODAY" +%Y%m%d%H%M)

if [ $COMPARABLE_NOW -gt $COMPARABLE_SUNRISE_TODAY ] && [ $COMPARABLE_NOW -lt $COMPARABLE_SUNSET_TODAY ]; then
    echo "Setting light theme..."
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    
    if [ "$NIGHT_LIGHT" = "true" ]; then
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
    fi
    
    NEXT_EXECUTION_AT=$(date --date="$SUNSET_TODAY 1 minute" +"%Y-%m-%d %H:%M")
else
    echo "Setting dark theme..."
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    
    if [ "$NIGHT_LIGHT" = "true" ]; then
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    fi
    
    if [ $COMPARABLE_NOW -gt $COMPARABLE_SUNSET_TODAY ]; then
        # Schedule for tomorrow's sunrise
        TOMORROW=$(date -d 'now +1 day' +'%Y-%m-%d %H:%M:%S')
        TOMORROW_YEAR=$(date -d "$TOMORROW" +'%Y')
        TOMORROW_MONTH=$(date -d "$TOMORROW" +'%m')
        TOMORROW_DAY=$(date -d "$TOMORROW" +'%d')

        HDATE_TOMORROW=$(hdate -s --not-sunset-aware -l "$LATITUDE" -L "$LONGITUDE" -z"$TIMEZONE_OFFSET" $TOMORROW_DAY $TOMORROW_MONTH $TOMORROW_YEAR)
        SUNRISE_TOMORROW=$(echo "$HDATE_TOMORROW" | grep "sunrise: " | grep -o '[0-2][0-9]:[0-6][0-9]')
        
        echo "Tomorrow's sunrise: $SUNRISE_TOMORROW"
        NEXT_EXECUTION_AT=$(date --date="$SUNRISE_TOMORROW 1 day 1 minute" +"%Y-%m-%d %H:%M")
    else
        NEXT_EXECUTION_AT=$(date --date="$SUNRISE_TODAY 1 minute" +"%Y-%m-%d %H:%M")
    fi
fi

echo "Next execution scheduled for: $NEXT_EXECUTION_AT"

# Schedule next run using systemd
systemctl --user stop auto-darkmode.timer 2> /dev/null
systemd-run --user --no-ask-password --on-calendar "$NEXT_EXECUTION_AT" --unit="auto-darkmode" --collect