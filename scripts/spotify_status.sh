#!/bin/bash

pgrep -x "Spotify" >/dev/null || exit 0

# Obtener shuffle y repeat en una líne
IFS='|' read -r shuffle repeat <<<"$(osascript -e 'tell application "Spotify" to (shuffling as integer) & "|" & (repeating as integer)' 2>/dev/null)"

case "$shuffle$repeat" in
1*) echo " 󰒟" ;; # shuffle activo
01) echo " 󰑖" ;; # solo repeat
*) echo "" ;;    # ninguno
esac
