#!/bin/bash

echo "Ubuntu Auto Dark Mode Installer"
echo "=============================="

# Check if running on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    echo "This script is designed for Ubuntu 24. Other systems may not work correctly."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for required commands
REQUIRED_COMMANDS="git curl jq hdate"
MISSING_COMMANDS=""

for cmd in $REQUIRED_COMMANDS; do
    if ! command -v $cmd >/dev/null 2>&1; then
        MISSING_COMMANDS="$MISSING_COMMANDS $cmd"
    fi
done

if [ ! -z "$MISSING_COMMANDS" ]; then
    echo "Installing required packages:$MISSING_COMMANDS"
    sudo apt-get update
    sudo apt-get install -y $MISSING_COMMANDS
fi

# Create installation directory
INSTALL_DIR="$HOME/.local/share/autodarkmode"
rm -rf "$INSTALL_DIR/source"
mkdir -p "$INSTALL_DIR"

# Clone the repository
echo "Downloading Auto Dark Mode..."
git clone https://github.com/wunder-one/ubuntuAutoDarkMode_v2.git "$INSTALL_DIR/source"

# Copy scripts to installation directory
cp "$INSTALL_DIR/source/"*.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/"*.sh

# Run configuration
"$INSTALL_DIR/config.sh"

# Set up initial timer
"$INSTALL_DIR/auto-dark-mode.sh"


echo "Installation complete! Auto Dark Mode has been installed and configured."
echo "The theme will automatically switch at the next sunrise/sunset."
echo "Configuration file is located at: $HOME/.config/theme-switcher/config.json"