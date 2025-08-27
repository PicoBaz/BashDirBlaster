#!/bin/bash

CONFIG_FILE="config.json"
RESULTS_JSON="scan_results.json"
RESULTS_CSV="scan_results.csv"
MODULES_DIR="modules"

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
  echo -e "\033[31m[ERROR] jq required! Install with 'sudo apt install jq'.\033[0m"
  exit 1
fi

# Function for subtle typing effect
type_effect() {
  local text="$1"
  local delay=0.03
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep $delay
  done
  echo
}

# Main menu with cleaner cyber theme
show_menu() {
  clear
  echo -e "\033[32m=== BashDirBlaster: Recon Mode ==="
  type_effect "> System Online. Ready for Recon, Pathfinder."
  echo -e "\033[32m============================\033[0m"
  echo -e "\033[36mSelect Mission:\033[0m"
  echo -e "  \033[33m1.\033[0m Base Scan (Recursive Directory Scan)"
  echo -e "  \033[33m2.\033[0m Advanced Scan (Size & Age Filters)"
  echo -e "  \033[33m3.\033[0m Content Analysis (Keyword Search)"
  echo -e "  \033[33m4.\033[0m Clean Up (Remove Temp Files)"
  echo -e "  \033[33m5.\033[0m Exit (End Mission)"
  echo -e "\033[32m============================\033[0m"
  echo -en "\033[32m> Enter choice [1-5]: \033[0m"
  read choice
  echo -e "\033[32m============================\033[0m"

  case $choice in
    1)
      echo -e "\033[34m[INFO] Engaging Base Scan...\033[0m"
      sleep 0.5
      source "$MODULES_DIR/base_scan.sh"
      ;;
    2)
      echo -e "\033[34m[INFO] Engaging Advanced Scan...\033[0m"
      sleep 0.5
      source "$MODULES_DIR/advanced_scan.sh"
      ;;
    3)
      echo -e "\033[34m[INFO] Engaging Content Analysis...\033[0m"
      sleep 0.5
      source "$MODULES_DIR/content_analysis.sh"
      ;;
    4)
      echo -e "\033[34m[INFO] Engaging Clean Up...\033[0m"
      sleep 0.5
      source "$MODULES_DIR/clean_up.sh"
      ;;
    5)
      echo -e "\033[31m[EXIT] BashDirBlaster Shutting Down. Safe Travels!\033[0m"
      sleep 0.5
      exit 0
      ;;
    *)
      echo -e "\033[31m[ERROR] Invalid Input. Retry.\033[0m"
      sleep 1
      show_menu
      ;;
  esac
}

# Initialize with clean startup
clear
echo -e "\033[32mStarting BashDirBlaster...\033[0m"
sleep 0.3
type_effect "> Recon System Online."
sleep 0.3
show_menu