#!/usr/bin/env bash

# tmux-spotify-status - Spotify status indicator for tmux
# https://github.com/juan52878911/tmux-spotify-status

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration
default_icon_color="#1DB954"
default_text_bg="#313244"
default_text_fg="#cdd6f4"
default_icon_fg="#11111b"
default_left_separator=""
default_right_separator=""
default_icon_separator=""

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
icon_color=$(get_tmux_option "@spotify_icon_color" "$default_icon_color")
text_bg=$(get_tmux_option "@spotify_text_bg" "$default_text_bg")
text_fg=$(get_tmux_option "@spotify_text_fg" "$default_text_fg")
icon_fg=$(get_tmux_option "@spotify_icon_fg" "$default_icon_fg")
left_separator=$(get_tmux_option "@spotify_left_separator" "$default_left_separator")
right_separator=$(get_tmux_option "@spotify_right_separator" "$default_right_separator")
icon_separator=$(get_tmux_option "@spotify_icon_separator" "$default_icon_separator")

# Make scripts executable
chmod +x "$CURRENT_DIR/scripts/spotify.sh"
chmod +x "$CURRENT_DIR/scripts/spotify_icon.sh"
chmod +x "$CURRENT_DIR/scripts/spotify_status.sh"

# Build Spotify module with Catppuccin-like styling
spotify_module="#[fg=${icon_color},bg=default]${left_separator}"
spotify_module+="#[fg=${icon_fg},bg=${icon_color}]#($CURRENT_DIR/scripts/spotify_icon.sh)${icon_separator}"
spotify_module+="#[fg=${text_bg},bg=${icon_color}]"
spotify_module+="#[fg=${text_fg},bg=${text_bg}] "
spotify_module+="#($CURRENT_DIR/scripts/spotify.sh)"
spotify_module+="#($CURRENT_DIR/scripts/spotify_status.sh) "
spotify_module+="#[fg=${text_bg},bg=default]${right_separator}"

# Get current status-right
current_status_right=$(tmux show-option -gqv status-right)

# Remove ALL old Spotify modules if present (handles multiple duplicates)
while [[ "$current_status_right" =~ "spotify_icon.sh" ]]; do
  # Remove Spotify module pattern more aggressively
  current_status_right=$(echo "$current_status_right" | perl -pe 's/#\[fg=[^\]]*\][^#]*#\[fg=[^\]]*,bg=[^\]]*\]#\([^)]*spotify_icon\.sh\)[^#]*#\[fg=[^\]]*,bg=[^\]]*\][^#]*#\[fg=[^\]]*,bg=[^\]]*\]\s*#\([^)]*spotify\.sh\)\s*#\([^)]*spotify_status\.sh\)\s*#\[fg=[^\]]*,bg=[^\]]*\][^#]*//')
done

# Prepend Spotify module to status-right
tmux set-option -g status-right "${spotify_module}${current_status_right}"

# Ensure status updates frequently enough for smooth scroll
current_interval=$(tmux show-option -gqv status-interval)
if [ -z "$current_interval" ] || [ "$current_interval" -gt 1 ]; then
  tmux set-option -g status-interval 1
fi
