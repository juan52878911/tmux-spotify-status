# tmux-spotify-status
![img.png](resources/banner-simple.png)
A minimal Spotify status indicator for tmux with scrolling text and dynamic icons.

## Features

- Dynamic icons for playing, paused, and offline states
- Smooth scrolling for long track names
- Playback status indicators (shuffle, repeat)
- Catppuccin Mocha styling (customizable)
- Efficient caching to minimize system calls
- Automatic status bar integration

## Requirements

### macOS

- Spotify Desktop App
- [shpotify](https://github.com/hnarayanan/shpotify) for Spotify control
- tmux 2.1+
- Nerd Fonts for icon display

### Linux / WSL

- Spotify Desktop App
- [shpotify](https://github.com/hnarayanan/shpotify) for Spotify control
- tmux 2.1+
- Nerd Fonts for icon display

## Installation

### TPM (recommended)

Add to `~/.tmux.conf`:

```tmux
set -g @plugin 'juan52878911/tmux-spotify-status'
```

Press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/juan52878911/tmux-spotify-status.git ~/.tmux/plugins/tmux-spotify-status
```

Add to `~/.tmux.conf`:

```tmux
run '~/.tmux/plugins/tmux-spotify-status/spotify.tmux'
```

### Installing shpotify (Linux/WSL only)

```bash
# Using Homebrew
brew install shpotify

# Or manually
curl -L https://raw.githubusercontent.com/hnarayanan/shpotify/master/spotify > /usr/local/bin/spotify
chmod +x /usr/local/bin/spotify
```

## Usage Example

Important: Configure your status bar or theme modules **before** loading the Spotify plugin. The plugin prepends its module to the left of your existing `status-right` content.

```tmux
# Catppuccin theme
set -g @plugin 'catppuccin/tmux'
set -g @catppuccin_flavour 'mocha'

# Define status bar content first
set -g status-right " #[fg=#cdd6f4]%H:%M  "

# Load Spotify plugin (will appear before the time)
set -g @plugin 'juan52878911/tmux-spotify-status'
set -g @spotify_left_separator ""
set -g @spotify_right_separator ""

# Update interval for smooth scrolling
set -g status-interval 1

# TPM initialization (must be at the end)
run '~/.tmux/plugins/tpm/tpm'
```

Result: `[Spotify Module] %H:%M`

## Configuration

### Available Options

```tmux
# Colors (Catppuccin Mocha defaults)
set -g @spotify_icon_color "#1DB954"
set -g @spotify_icon_fg "#11111b"
set -g @spotify_text_bg "#313244"
set -g @spotify_text_fg "#cdd6f4"

# Separators
set -g @spotify_left_separator ""
set -g @spotify_right_separator ""

# Update interval (recommended for smooth scrolling)
set -g status-interval 1
```

## Troubleshooting

**Spotify not detected (macOS)**: Verify Spotify is running with `osascript -e 'tell application "Spotify" to player state'`

**Spotify not detected (Linux/WSL)**: Ensure shpotify is installed and in your PATH with `which spotify`

**Missing icons**: Install a Nerd Font and configure your terminal to use it

**Duplicate modules**: Restart tmux with `tmux kill-server && tmux`

## Uninstalling

Remove the plugin line from `~/.tmux.conf` and press `prefix + alt + u`, or delete manually:

```bash
rm -rf ~/.tmux/plugins/tmux-spotify-status
```

## License

MIT

---

Made by [JuanPBedoya](https://github.com/juan52878911)
