# Ubuntu Auto Dark Mode v2

Automatically switch between light and dark modes in Ubuntu based on sunrise and sunset times. This script uses your location to calculate sunrise and sunset times locally, requiring no internet connection for daily operation.

## Features

- Automatically switches between light and dark color schemes
- Optional night light feature (blue light filter)
- Calculates sunrise and sunset times offline using `hdate`
- Uses systemd timers for precise theme switching
- Simple installation process
- Configuration stored separately from script

## Installation

### 1. Install Required Dependencies

First, install the required system packages:

```bash
sudo apt-get update
sudo apt-get install git curl jq hdate
```

### 2. Download the Source Code

Choose one of these methods:

#### Option A: Clone with Git (Recommended)
```bash
git clone https://github.com/wunder-one/ubuntuAutoDarkMode_v2.git
cd ubuntuAutoDarkMode_v2
```

#### Option B: Download ZIP
1. Visit https://github.com/wunder-one/ubuntuAutoDarkMode_v2
2. Click the green "Code" button
3. Select "Download ZIP"
4. Extract the downloaded file:
```bash
unzip ubuntuAutoDarkMode_v2-main.zip
cd ubuntuAutoDarkMode_v2-main
```

### 3. Run the Installation Script

```bash
chmod +x install.sh
./install.sh
```

The installer will:
- Create necessary directories
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
mkdir -p ~/.local/share/autodarkmode
git clone https://github.com/wunder-one/ubuntuAutoDarkMode_v2.git ~/.local/share/autodarkmode/source
```

3. Copy and make scripts executable:
```bash
cp ~/.local/share/autodarkmode/source/*.sh ~/.local/share/autodarkmode/
chmod +x ~/.local/share/autodarkmode/*.sh
```

4. Run the configuration:
```bash
~/.local/share/autodarkmode/config.sh
```

5. Start the service:
```bash
~/.local/share/autodarkmode/auto-dark-mode.sh
```

## Configuration

The configuration file is stored at `~/.config/theme-switcher/config.json` and contains:
- Your latitude and longitude
- Night light preference

To reconfigure run the configuration script again:
```bash
~/.local/share/autodarkmode/config.sh
```
Or you can edit the config file directly.

## Dependencies

- `hdate`: For sunrise/sunset calculations
- `jq`: For JSON parsing
- `curl`: For installation
- `git`: For downloading the source code

## Ubuntu Version Support

- Primarily tested on Ubuntu 24.10
- May work on other Ubuntu versions and derivatives
- Focuses on color-scheme switching (GTK theme switching removed as it's deprecated in Ubuntu 24.04)

## Troubleshooting

1. **Theme not switching:**
   - Check if the service is running: `systemctl --user status autodarkmode.timer`
   - Check the logs: `journalctl --user -u autodarkmode`

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
systemctl --user disable auto-darkmode.timer
rm -rf ~/.local/share/autodarkmode
rm -rf ~/.config/theme-switcher
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Based on [auto-darkmode-switcher](https://github.com/littleant/auto-darkmode-switcher) by littleant and on [ubuntuAutoDarkMode](https://github.com/tintinando/ubuntuAutoDarkMode) by tintinando
- Hebrew Calendar tools (`hdate`)
- Ubuntu GNOME team for gsettings framework

## Privacy Note

Your location coordinates are stored locally in the configuration file and are only used for calculating sunrise and sunset times. No data is sent to any external services.