#!/bin/bash

# config.sh - Handles configuration for Auto Dark Mode
CONFIG_DIR="$HOME/.config/theme-switcher"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

echo "hello"

setup_config() {
    echo "Auto Dark Mode Configuration Setup"
    echo "================================="
    
    # Get location coordinates
    echo "Please enter your coordinates"
    echo "You can find them in the url of google maps" 
    echo "or you can use https://www.geolocation.com/"
    read -p "Enter latitude (e.g., 51.5074): " lat
    read -p "Enter longitude (e.g., -0.1278): " lng
    
    # Night light preference
    read -p "Would you like to automatically enable night light feature? (y/N): " night_light
    case $night_light in
        [Yy]* ) night_light="true" ;;
        * ) night_light="false" ;;
    esac
    
    # Create JSON config
    json=$(jq -n \
        --arg lat "$lat" \
        --arg lng "$lng" \
        --arg nl "$night_light" \
        '{latitude: $lat, longitude: $lng, night_light: $nl}')
    
    echo "$json" > "$CONFIG_FILE"
    echo "Configuration saved to $CONFIG_FILE"
}

# Run setup if config doesn't exist or user wants to reconfigure
if [ ! -f "$CONFIG_FILE" ]; then
    setup_config
else
    read -p "Configuration file already exists. Would you like to reconfigure? (y/N): " reconfigure
    case $reconfigure in
        [Yy]* ) setup_config ;;
        * ) echo "Keeping existing configuration." ;;
    esac
fi