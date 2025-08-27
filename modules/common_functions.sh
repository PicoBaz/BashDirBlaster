#!/bin/bash

# Load config
DIRECTORY=$(jq -r '.directory' "$CONFIG_FILE")
EXTENSIONS=$(jq -r '.extensions | join(" ")' "$CONFIG_FILE")
MAX_DEPTH=$(jq -r '.maxDepth' "$CONFIG_FILE")
RETRY_COUNT=$(jq -r '.retryCount' "$CONFIG_FILE")
RETRY_DELAY_MS=$(jq -r '.retryDelayMs' "$CONFIG_FILE")
RETRY_DELAY=$(echo "scale=3; $RETRY_DELAY_MS / 1000" | bc)

# Save results function
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