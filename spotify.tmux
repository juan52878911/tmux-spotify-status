#!/usr/bin/env bash

# tmux-spotify-status - Spotify status indicator for tmux
# https://github.com/yourusername/tmux-spotify-status

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration
default_icon_color="#1DB954"           # Spotify green
default_text_bg="#313244"              # Catppuccin surface
default_text_fg="#cdd6f4"              # Catppuccin text
default_max_length="20"                # Characters before scroll
default_scroll_speed="3"               # Scroll speed
default_separator=" • "                # Infinite scroll separator

# Get tmux options with defaults
get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

# Configuration
icon_color=$(get_tmux_option "@spotify-status-icon-color" "$default_icon_color")
text_bg=$(get_tmux_option "@spotify-status-text-bg" "$default_text_bg")
text_fg=$(get_tmux_option "@spotify-status-text-fg" "$default_text_fg")
max_length=$(get_tmux_option "@spotify-status-max-length" "$default_max_length")
scroll_speed=$(get_tmux_option "@spotify-status-scroll-speed" "$default_scroll_speed")
separator=$(get_tmux_option "@spotify-status-separator" "$default_separator")

# Export configuration to scripts via environment
export SPOTIFY_MAX_LENGTH="$max_length"
export SPOTIFY_SCROLL_SPEED="$scroll_speed"
export SPOTIFY_SEPARATOR="$separator"

# Make scripts executable
chmod +x "$CURRENT_DIR/scripts/spotify.sh"
chmod +x "$CURRENT_DIR/scripts/spotify_icon.sh"
chmod +x "$CURRENT_DIR/scripts/spotify_status.sh"

# Optional: Auto-configure status-right if requested
auto_configure=$(get_tmux_option "@spotify-status-auto-configure" "off")

if [ "$auto_configure" = "on" ]; then
    # Build status-right with Spotify integration
    spotify_module="#[fg=${icon_color},bg=default] "
    spotify_module+="#[fg=#11111b,bg=${icon_color}]#($CURRENT_DIR/scripts/spotify_icon.sh) "
    spotify_module+="#[fg=${text_bg},bg=${icon_color}]"
    spotify_module+="#[fg=${text_fg},bg=${text_bg}] "
    spotify_module+="#($CURRENT_DIR/scripts/spotify.sh) "
    spotify_module+="#($CURRENT_DIR/scripts/spotify_status.sh) "
    spotify_module+="#[fg=${text_bg},bg=default]"

    # Append to existing status-right
    current_status_right=$(tmux show-option -gqv status-right)
    tmux set-option -g status-right "${spotify_module}${current_status_right}"
fi

# Ensure status updates frequently enough for smooth scroll
current_interval=$(tmux show-option -gqv status-interval)
if [ -z "$current_interval" ] || [ "$current_interval" -gt 1 ]; then
    tmux set-option -g status-interval 1
fi
