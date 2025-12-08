# tmux-spotify-status

A beautiful, minimal Spotify status indicator for tmux with dynamic icons and infinite scroll for long track names.

![Spotify Status](docs/preview.png)

## Features

- 🎵 **Dynamic Icons**: Shows different icons for playing (󰓇), paused (󰏥), or offline (󰝛) states
- 🔄 **Infinite Scroll**: Smoothly scrolls long track names with a LED-style animation
- 🎲 **Playback Status**: Displays shuffle (󰒟) and repeat (󰑖) indicators
- 🎨 **Catppuccin Integration**: Designed to work seamlessly with Catppuccin Mocha theme
- ⚡ **Performance**: Efficient caching system to minimize AppleScript calls
- 🔧 **Customizable**: Easy to configure colors, scroll speed, and visibility

## Requirements

- macOS (uses AppleScript to communicate with Spotify)
- [Spotify Desktop App](https://www.spotify.com/download/)
- [tmux](https://github.com/tmux/tmux) 2.1 or higher
- [Nerd Fonts](https://www.nerdfonts.com/) for icons

## Installation

### Using TPM (Tmux Plugin Manager)

1. Add plugin to your `~/.tmux.conf`:

```tmux
set -g @plugin 'juan52878911/tmux-spotify-status'
```

2. Press `prefix + I` to install the plugin

### Manual Installation

1. Clone this repository:

```bash
git clone https://github.com/juan52878911/tmux-spotify-status.git ~/.tmux/plugins/tmux-spotify-status
```

2. Add to your `~/.tmux.conf`:

```tmux
run '~/.tmux/plugins/tmux-spotify-status/spotify.tmux'
```

## Configuration

Add these options to your `~/.tmux.conf` before loading the plugin:

```tmux
# Customize colors (Spotify green by default)
set -g @spotify-status-icon-color "#1DB954"
set -g @spotify-status-text-bg "#313244"
set -g @spotify-status-text-fg "#cdd6f4"

# Scroll configuration
set -g @spotify-status-max-length 20      # Max characters before scrolling
set -g @spotify-status-scroll-speed 3     # Characters to scroll per second
set -g @spotify-status-separator " • "    # Separator for infinite scroll

# Update interval (seconds)
set -g status-interval 1
```

## Usage

### Basic Setup (Spotify only)

Add Spotify status to your status bar:

```tmux
set -g status-right "#(~/.tmux/plugins/tmux-spotify-status/scripts/spotify.sh)"
```

### Catppuccin Integration

For the full experience with Catppuccin theme:

```tmux
# Install Catppuccin theme
set -g @plugin 'catppuccin/tmux'
set -g @catppuccin_flavour 'mocha'

# After TPM init, add Spotify status
run '~/.tmux/plugins/tpm/tpm'

set -g status-right "#[fg=#1DB954,bg=default] #[fg=#11111b,bg=#1DB954]#(~/.tmux/plugins/tmux-spotify-status/scripts/spotify_icon.sh) #[fg=#313244,bg=#1DB954]#[fg=#cdd6f4,bg=#313244] #(~/.tmux/plugins/tmux-spotify-status/scripts/spotify.sh) #(~/.tmux/plugins/tmux-spotify-status/scripts/spotify_status.sh) #[fg=#313244,bg=default]"
```

## Scripts

The plugin includes three main scripts:

- **`spotify.sh`**: Displays the current track (Artist - Song) with infinite scroll
- **`spotify_icon.sh`**: Shows dynamic icon based on playback state
- **`spotify_status.sh`**: Displays shuffle/repeat indicators

## How It Works

1. **Efficient Caching**: Only queries Spotify when the track changes (using track ID)
2. **Smooth Scrolling**: Uses character-by-character offset for LED-style animation
3. **Dynamic Icons**: Real-time state detection (playing/paused/offline)
4. **Adaptive Display**: Short track names display fully, long names scroll infinitely

## Troubleshooting

### Spotify not detected

Make sure Spotify Desktop app is running and accessible via AppleScript:

```bash
osascript -e 'tell application "Spotify" to player state'
```

### Icons not showing

Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal to use it.

### Slow updates

Increase the status update interval in your tmux config:

```tmux
set -g status-interval 1
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details

## Credits

- Inspired by various tmux Spotify plugins
- Built with [Catppuccin](https://github.com/catppuccin/catppuccin) color palette
- Icons from [Nerd Fonts](https://www.nerdfonts.com/)

## Showcase

Share your setup! Tag `#tmux-spotify-status` on Twitter/X.

---

Made with ♥ by [JuanPBedoya](https://github.com/juan52878911)
