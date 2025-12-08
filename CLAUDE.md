# CLAUDE.md - Project Context

## Project Overview

**tmux-spotify-status** is a tmux plugin that displays the current Spotify track in the status bar with dynamic icons, infinite scroll for long track names, and playback status indicators.

## Purpose

This plugin was created to provide a beautiful, minimal, and functional Spotify integration for tmux users who want to see what they're listening to without leaving their terminal workflow.

## Key Features

1. **Dynamic Icons Based on State**:
   - 󰓇 Playing
   - 󰏥 Paused
   - 󰝛 Offline/Not running

2. **Infinite LED-style Scroll**: Long track names scroll smoothly in a circular pattern

3. **Playback Indicators**:
   - 󰒟 Shuffle active
   - 󰑖 Repeat active

4. **Performance Optimized**: Uses track ID caching to minimize AppleScript calls

## Technical Architecture

### File Structure

```
tmux-spotify-status/
├── scripts/
│   ├── spotify.sh           # Main track display with scroll logic
│   ├── spotify_icon.sh      # Dynamic icon based on playback state
│   └── spotify_status.sh    # Shuffle/repeat indicators
├── spotify.tmux             # Main plugin loader
├── README.md               # User documentation
├── CLAUDE.md              # This file - AI context
├── LICENSE                # MIT License
└── .gitignore            # Git ignore rules
```

### Script Details

#### `spotify.sh`
- **Purpose**: Display current track with infinite scroll
- **Logic**:
  1. Check if Spotify is running
  2. Get track ID (fast check)
  3. If track changed, fetch artist + track name
  4. Cache in `/tmp/tmux_spotify/song`
  5. For long names (>20 chars), implement circular scroll
  6. Update scroll offset in `/tmp/tmux_spotify/scroll`

#### `spotify_icon.sh`
- **Purpose**: Show correct icon for playback state
- **Logic**:
  1. Check if Spotify is running → 󰝛 if not
  2. Query player state (0=stopped, 1=playing, 2=paused)
  3. Return appropriate icon

#### `spotify_status.sh`
- **Purpose**: Display shuffle/repeat status
- **Logic**:
  1. Query shuffling and repeating as integers (0/1)
  2. Priority: shuffle > repeat > nothing
  3. Return icon or empty space to maintain layout

### Scroll Algorithm

The infinite scroll works by:
1. Creating infinite text: `"Artist - Song • "`
2. Maintaining an offset position (0 to text_length-1)
3. Each update, advance offset by `scroll_speed` characters
4. Use modulo to wrap around: `(offset + scroll_speed) % text_length`
5. Extract 20-character window using substring with wrap-around

### Performance Optimizations

1. **Track ID Caching**: Only fetch metadata when track changes
2. **Single osascript Call**: Combine multiple queries when possible
3. **File-based State**: Avoid re-querying playback state unnecessarily

## Color Scheme (Catppuccin Mocha)

- **Spotify Green**: `#1DB954` (icon background)
- **Black**: `#11111b` (icon foreground)
- **Surface**: `#313244` (content background)
- **Text**: `#cdd6f4` (content foreground)

## Configuration Variables

Users can customize:
- `@spotify-status-max-length`: Max characters before scrolling (default: 20)
- `@spotify-status-scroll-speed`: Scroll speed in chars/second (default: 3)
- `@spotify-status-separator`: Text separator for infinite loop (default: " • ")
- `@spotify-status-icon-color`: Icon background color (default: #1DB954)
- `@spotify-status-text-bg`: Text background (default: #313244)
- `@spotify-status-text-fg`: Text foreground (default: #cdd6f4)

## Development Guidelines

### Testing Changes

1. Modify scripts in `scripts/` directory
2. Make executable: `chmod +x scripts/*.sh`
3. Test manually: `./scripts/spotify.sh`
4. Reload tmux: `tmux source ~/.tmux.conf`

### Adding Features

When adding new features:
1. Keep scripts POSIX-compliant where possible
2. Cache aggressively to minimize osascript calls
3. Provide configuration options via tmux variables
4. Update README.md with new options
5. Test with both Spotify running and stopped

### Code Style

- Use bash for scripts (requires process substitution)
- Comment complex logic
- Use meaningful variable names
- Keep functions small and focused
- Avoid external dependencies beyond osascript

## Known Limitations

1. **macOS Only**: Uses AppleScript, not portable to Linux/Windows
2. **Desktop App Required**: Doesn't work with Spotify web player
3. **Nerd Fonts Required**: Icons won't display without proper font

## Future Enhancements

Potential features to add:
- [ ] Album art in tmux popup
- [ ] Playback controls via key bindings
- [ ] Progress bar for current track
- [ ] Volume indicator
- [ ] Linux support via dbus/playerctl
- [ ] Configuration via plugin options
- [ ] Multiple theme presets (not just Catppuccin)

## Testing Checklist

Before releasing:
- [ ] Works with Spotify playing
- [ ] Works with Spotify paused
- [ ] Works with Spotify closed
- [ ] Scroll animation is smooth
- [ ] Icons display correctly
- [ ] Shuffle/repeat indicators work
- [ ] No zombie processes
- [ ] Reasonable CPU usage
- [ ] Works on fresh tmux install
- [ ] TPM installation works

## Related Projects

- [tmux-spotify](https://github.com/xamut/tmux-spotify) - Original inspiration
- [catppuccin/tmux](https://github.com/catppuccin/tmux) - Theme integration
- [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm) - Plugin manager

## How to Modify

### Change Scroll Speed

Edit `scripts/spotify.sh`, line ~7:
```bash
scroll_speed=3  # Increase for faster scroll
```

### Change Icons

Edit `scripts/spotify_icon.sh` and `scripts/spotify_status.sh`:
```bash
echo "󰓇"  # Replace with your preferred icon
```

### Add New Status Indicators

1. Query Spotify for new property in `scripts/spotify_status.sh`
2. Add conditional logic to display icon
3. Ensure spacing is preserved when not active

## Debugging

Enable verbose logging:
```bash
# Add to scripts for debugging
set -x  # Print commands as they execute
```

Check cache files:
```bash
cat /tmp/tmux_spotify/song
cat /tmp/tmux_spotify/scroll
```

Test osascript directly:
```bash
osascript -e 'tell application "Spotify" to player state'
```

## Contact

For questions or issues, please open an issue on GitHub.

---

**Last Updated**: 2025-12-08
**Maintained By**: Juan Bedoya
**AI Assistant**: Claude (Anthropic)
