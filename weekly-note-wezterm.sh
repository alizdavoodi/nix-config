#!/usr/bin/env bash

# 1. Define Note Details
main_note_dir=/Users/alirezadavoodi/mnt/gdrive/vaults
current_year=$(date +"%Y")
current_month_num=$(date +"%m")
current_month_abbr=$(date +"%b")
current_week=$(date +"%V")
week_start=$(date -v-monday +"%Y-%m-%d")
week_end=$(date -v+sunday +"%Y-%m-%d")

note_dir="${main_note_dir}/${current_year}/${current_month_num}-${current_month_abbr}"
note_name="${current_year}-W${current_week}"
full_path="${note_dir}/${note_name}.md"
workspace_name="weekly" # Your desired workspace name

# Create directory and note file (same as before)
if [ ! -d "$note_dir" ]; then
  echo "Creating directory: $note_dir"
  mkdir -p "$note_dir"
fi
if [ ! -f "$full_path" ]; then
  echo "Creating note: $full_path"
  cat <<EOF >"$full_path"
---
id: ${note_name}
aliases:
  - Week ${current_week} (${week_start} to ${week_end})
tags: []
---
# Week ${current_week}

EOF
fi

echo "Looking for Wezterm workspace: $workspace_name"

# Check if we have a window in the target workspace
list_output=$(wezterm cli list --format json)
target_window_id=""

if [ -n "$list_output" ] && [ "$list_output" != "[]" ] && [ "$list_output" != "null" ]; then
  # Ensure it's valid JSON
  if echo "$list_output" | jq empty >/dev/null 2>&1; then
    # Extract window ID for any window in the weekly workspace
    # This is a simpler jq query to avoid syntax issues
    target_window_id=$(echo "$list_output" | jq -r '.[] | select(.workspace == "weekly") | .window_id' | head -n 1)
  fi
fi

new_pane_id=""

if [ -n "$target_window_id" ] && [ "$target_window_id" != "null" ]; then
    echo "Found existing window ID $target_window_id in workspace $workspace_name."
    # Extract the first pane ID in the window
    existing_pane_id=$(echo "$list_output" | jq -r ".[] | select(.window_id == \"$target_window_id\") | .panes[0].pane_id" 2>/dev/null)

    if [ -n "$existing_pane_id" ] && [ "$existing_pane_id" != "null" ]; then
      echo "Found existing pane ID $existing_pane_id in the window."
    fi
else
  echo "Workspace $workspace_name not found or has no windows. Spawning new window in $workspace_name..."
  new_pane_id=$(wezterm cli spawn --new-window --workspace "$workspace_name" --cwd "$note_dir" nvim +norm\ G "$full_path")
fi

echo "Please switch to your WezTerm window to complete the process..."
