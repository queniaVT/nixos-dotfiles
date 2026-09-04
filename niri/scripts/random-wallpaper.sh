#!/usr/bin/env bash
set -euo pipefail
FOLDER="${HOME}/pictures/wallpapers/"
mapfile -d '' files < <(find "$FOLDER" -type f \( -iname "*.gif" \) -print0)
if [ "${#files[@]}" -eq 0 ]; then
  echo "put something in here stoopid: $FOLDER" >&2
  exit 1
fi
idx=$((RANDOM % ${#files[@]}))
gif="${files[$idx]}"
mpvpaper -o "--loop" ALL "$gif"
