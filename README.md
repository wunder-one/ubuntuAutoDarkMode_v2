# Ubuntu Auto Dark Mode v2

Automatically switch between light and dark modes in Ubuntu based on sunrise and sunset times. This script uses your location to calculate sunrise and sunset times locally, requiring no internet connection for daily operation.

## Features

- Automatically switches between light and dark color schemes
- Optional night light feature (blue light filter)
- Calculates sunrise and sunset times offline using `hdate`
- Uses systemd timers for precise theme switching
- Simple one-command installation
- Configuration stored separately from script

## Quick Install

Install Auto Dark Mode v2 with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/wunder-one/ubuntuAutoDarkMode_v2/main/install.sh | bash
```

The installer will:
- Install required dependencies
- Set up the configuration
- Start the auto-switching service

## Manual Installation

If you prefer to install manually:

1. Install dependencies:
```bash
sudo apt-get update
sudo apt-get install git curl jq hdate
```

2. Clone the repository:
```bash
mkdir -p ~/.local/share/auto-darkmode
git clone https://github.com/wunder-one/ubuntuAutoDarkMode_v2.git ~/.local/share/auto-darkmode/source
```

3. Copy and make scripts executable:
```bash
cp ~/.local/share/auto-darkmode/source/*.sh ~/.local/share/auto-darkmode/
chmod +x ~/.local/share/auto-darkmode/*.sh
```

4. Run the configuration:
```bash
~/.local/share/auto-darkmode/config.sh
```

5. Start the service:
```bash
~/.local/share/auto-darkmode/auto-dark-mode.sh
```

## Configuration

The configuration file is stored at `~/.config/theme-switcher/config.json` and contains:
- Your latitude and longitude
- Night light preference

To reconfigure:
1. Delete the configuration file:
```bash
rm ~/.config/theme-switcher/config.json
```
2. Run the configuration script again:
```bash
~/.local/share/auto-darkmode/config.sh
```

## Dependencies

- `hdate`: For sunrise/sunset calculations
- `jq`: For JSON parsing
- `curl`: For installation
- `git`: For downloading the source code

## Ubuntu Version Support

- Primarily tested on Ubuntu 24.04
- May work on other Ubuntu versions and derivatives
- Focuses on color-scheme switching (GTK theme switching removed as it's deprecated in Ubuntu 24.04)

## Troubleshooting

1. **Theme not switching:**
   - Check if the service is running: `systemctl --user status auto-darkmode.timer`
   - Check the logs: `journalctl --user -u auto-darkmode`

2. **Wrong times:**
   - Verify your coordinates in the config file
   - Check your system timezone is correct

3. **Installation failed:**
   - Make sure all dependencies are installed
   - Check your Ubuntu version
   - Try the manual installation steps

## Uninstallation

To remove Auto Dark Mode v2:

```bash
systemctl --user stop auto-darkmode.timer
rm -rf ~/.local/share/auto-darkmode
rm -rf ~/.config/theme-switcher
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original Auto Dark Mode script
- Hebrew Calendar tools (`hdate`)
- Ubuntu GNOME team for gsettings framework

## Privacy Note

Your location coordinates are stored locally in the configuration file and are only used for calculating sunrise and sunset times. No data is sent to any external services.