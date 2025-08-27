#!/bin/bash

CONFIG_FILE="config.json"
RESULTS_JSON="scan_results.json"
RESULTS_CSV="scan_results.csv"

# Load config
DIRECTORY=$(jq -r '.directory' "$CONFIG_FILE")
EXTENSIONS=$(jq -r '.extensions | join(" ")' "$CONFIG_FILE")
MAX_DEPTH=$(jq -r '.maxDepth' "$CONFIG_FILE")
RETRY_COUNT=$(jq -r '.retryCount' "$CONFIG_FILE")
RETRY_DELAY_MS=$(jq -r '.retryDelayMs' "$CONFIG_FILE")

# Convert ms to seconds for sleep
RETRY_DELAY=$(echo "scale=3; $RETRY_DELAY_MS / 1000" | bc)

# Initialize results array
results=()

# Function to scan directory
scan_directory() {
  local dir_path="$1"
  local depth="$2"
  local retry="$3"

  if [ "$depth" -gt "$MAX_DEPTH" ]; then
    return
  fi

  # Use find to list files and directories
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

    if [ "$item_type" = "file" ]; then
      item_ext=$(echo "$item_name" | grep -oE '\.[^.]+$' || true)
      item_size=$(stat -c %s "$item" 2>/dev/null || echo 0)
    fi

    # Filter by extension
    if [ "$item_type" = "file" ] && [ -n "$EXTENSIONS" ]; then
      skip=1
      for ext in $EXTENSIONS; do
        if [ "$item_ext" = "$ext" ]; then
          skip=0
          break
        fi
      done
      if [ "$skip" -eq 1 ]; then
        continue
      fi
    fi

    # Add to results
    results+=("$(jq -n \
      --arg name "$item_name" \
      --arg path "$item" \
      --arg type "$item_type" \
      --arg ext "$item_ext" \
      --arg size "$item_size" \
      --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      --arg error "$error" \
      '{name: $name, path: $path, type: $type, extension: $ext, size: ($size | tonumber), timestamp: $time, error: $error}')")

    # Recursively scan subdirectories
    if [ "$item_type" = "directory" ]; then
      scan_directory "$item" $((depth + 1)) "$retry"
    fi
  done < <(find "$dir_path" -maxdepth 1 2>/dev/null || {
    if [ "$retry" -gt 0 ]; then
      sleep "$RETRY_DELAY"
      scan_directory "$dir_path" "$depth" $((retry - 1))
    else
      results+=("$(jq -n \
        --arg name "$(basename "$dir_path")" \
        --arg path "$dir_path" \
        --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        '{name: $name, path: $path, type: "error", extension: "", size: 0, timestamp: $time, error: "Permission denied or directory not found"}')")
    fi
  })
}

# Save results to JSON and CSV
save_results() {
  # JSON output
  printf '%s\n' "${results[@]}" | jq -s . > "$RESULTS_JSON"

  # CSV output
  echo "Name,Path,Type,Extension,Size (Bytes),Timestamp,Error" > "$RESULTS_CSV"
  for result in "${results[@]}"; do
    name=$(echo "$result" | jq -r '.name')
    path=$(echo "$result" | jq -r '.path')
    type=$(echo "$result" | jq -r '.type')
    ext=$(echo "$result" | jq -r '.extension')
    size=$(echo "$result" | jq -r '.size')
    time=$(echo "$result" | jq -r '.timestamp')
    error=$(echo "$result" | jq -r '.error')
    echo "\"$name\",\"$path\",\"$type\",\"$ext\",\"$size\",\"$time\",\"$error\"" >> "$RESULTS_CSV"
  done
}

# Main function
main() {
  # Check if jq is installed
  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required. Install it with 'sudo apt install jq' or equivalent."
    exit 1
  fi

  # Start scanning
  scan_directory "$DIRECTORY" 0 "$RETRY_COUNT"
  echo "Scanned ${#results[@]} items."

  # Save results
  save_results
}

# Run main
main