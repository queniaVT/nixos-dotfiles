#!/bin/sh

current_workspace=$(niri msg -j focused-window | jq -r '.workspace_id')

target=$(niri msg -j workspaces |
    jq -r --argjson id "$current_workspace" \
    '.[] | select(.id == $id) | .output')

if niri msg -j workspaces |
    jq -e '.[] | select(.name == "special" and .is_focused)' >/dev/null
then
    niri msg action focus-workspace-previous
    exit
fi

niri msg action move-workspace-to-monitor "$target" --reference special

last_index=$(niri msg -j workspaces |
    jq --arg output "$target" '
        [.[] | select(.output == $output)]
        | map(.idx)
        | max
    ')

niri msg action move-workspace-to-index "$last_index" --reference special
niri msg action focus-workspace special

