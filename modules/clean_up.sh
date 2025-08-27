#!/bin/bash

source "$MODULES_DIR/common_functions.sh"

CLEAN_EXTENSIONS=$(jq -r '.cleanExtensions | join(" ")' "$CONFIG_FILE")

results=()

clean_directory() {
  local dir_path="$1"
  local depth="$2"
  local retry="$3"

  if [ "$depth" -gt "$MAX_DEPTH" ]; then
    return
  fi

  while IFS= read -r item; do
    if [ -z "$item" ]; then continue; fi
    item_type="file"
    if [ -d "$item" ]; then
      item_type="directory"
    fi
    item_name=$(basename "$item")
    item_ext=""
    item_size=0
    error=""
    cleaned="no"

    if [ "$item_type" = "file" ]; then
      item_ext=$(echo "$item_name" | grep -oE '\.[^.]+$' || true)
      item_size=$(stat -c %s "$item" 2>/dev/null || echo 0)
      for ext in $CLEAN_EXTENSIONS; do
        if [ "$item_ext" = "$ext" ]; then
          rm "$item" 2>/dev/null && cleaned="yes" || error="Failed to delete"
          break
        fi
      done
    fi

    results+=("$(jq -n \
      --arg name "$item_name" \
      --arg path "$item" \
      --arg type "$item_type" \
      --arg ext "$item_ext" \
      --arg size "$item_size" \
      --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      --arg error "$error" \
      --arg cleaned "$cleaned" \
      '{name: $name, path: $path, type: $type, extension: $ext, size: ($size | tonumber), timestamp: $time, error: $error, cleaned: $cleaned}')")

    if [ "$item_type" = "directory" ]; then
      clean_directory "$item" $((depth + 1)) "$retry"
    fi
  done < <(find "$dir_path" -maxdepth 1 2>/dev/null || {
    if [ "$retry" -gt 0 ]; then
      sleep "$RETRY_DELAY"
      clean_directory "$dir_path" "$depth" $((retry - 1))
    else
      results+=("$(jq -n \
        --arg name "$(basename "$dir_path")" \
        --arg path "$dir_path" \
        --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        '{name: $name, path: $path, type: "error", extension: "", size: 0, timestamp: $time, error: "Permission denied or directory not found"}')")
    fi
  })
}

clean_directory "$DIRECTORY" 0 "$RETRY_COUNT"
echo "Clean Up complete. Scanned ${#results[@]} items."
save_results