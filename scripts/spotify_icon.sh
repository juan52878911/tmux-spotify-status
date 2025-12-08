#!/bin/bash

# Verificar si Spotify está corriendo
if ! pgrep -x "Spotify" >/dev/null; then
  echo "󰝛" # Icono de desconexión/offline
  exit 0
fi

# Si está corriendo, obtener estado
state=$(osascript -e 'tell app "Spotify" to player state as integer' 2>/dev/null)

# Mostrar icono según estado: paused (2) o playing/stopped (default)
[[ $state == 2 ]] && echo "󰏥" || echo "󰓇"
