#!/bin/bash

CONFIG_FILE="config.json"
RESULTS_JSON="scan_results.json"
RESULTS_CSV="scan_results.csv"
MODULES_DIR="modules"

source "$MODULES_DIR/common_functions.sh"  # Load common functions if needed

# Main menu
show_menu() {
  clear
  echo -e "\e[1;32mBashDirBlaster Activated!\e[0m"
  echo "Choose your mission:"
  echo "1) Base Scan (Recursive directory scan)"
  echo "2) Advanced Scan (With size and age filters)"
  echo "3) Content Analysis (Search keywords in files)"
  echo "4) Clean Up (Remove temporary files)"
  echo "5) Exit"
  read -p "Enter choice: " choice
  case $choice in
    1) source "$MODULES_DIR/base_scan.sh" ;;
    2) source "$MODULES_DIR/advanced_scan.sh" ;;
    3) source "$MODULES_DIR/content_analysis.sh" ;;
    4) source "$MODULES_DIR/clean_up.sh" ;;
    5) exit 0 ;;
    *) echo "Invalid choice. Try again." ; sleep 2 ; show_menu ;;
  esac
}

show_menu