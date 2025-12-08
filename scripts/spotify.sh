#!/bin/bash

pgrep -x "Spotify" >/dev/null || exit 0

# Configuración
max_visible=20
scroll_speed=3
separator=" • "
cache_dir="/tmp/tmux_spotify"
scroll_file="$cache_dir/scroll"
song_file="$cache_dir/song"

mkdir -p "$cache_dir"

# Obtener ID de track (más rápido que nombre completo)
track_id=$(osascript -e 'tell application "Spotify" to id of current track' 2>/dev/null)
[[ -z "$track_id" ]] && exit 0

# Si la canción cambió, actualizar info
if [[ ! -f "$song_file" ]] || [[ "$track_id" != "$(head -1 "$song_file" 2>/dev/null)" ]]; then
  IFS='|' read -r artist track <<<"$(osascript -e 'tell application "Spotify"
        return (artist of current track) & "|" & (name of current track)
    end tell' 2>/dev/null)"

  echo "$track_id" >"$song_file"
  echo "$artist - $track" >>"$song_file"
  echo "0" >"$scroll_file"
fi

# Leer info cacheada
song_info=$(sed -n '2p' "$song_file")
song_len=${#song_info}

# Texto corto
((song_len <= max_visible)) && {
  echo "$song_info"
  exit 0
}

# Scroll
infinite_text="${song_info}${separator}"
text_length=${#infinite_text}

read -r offset 2>/dev/null <"$scroll_file" || offset=0
next_offset=$(((offset + scroll_speed) % text_length))
echo "$next_offset" >"$scroll_file"

remaining=$((offset + max_visible - text_length))
if ((remaining <= 0)); then
  echo "${infinite_text:offset:max_visible}"
else
  echo "${infinite_text:offset}${infinite_text:0:remaining}"
fi
