```
        _____
       /     \
      /_______\
      |  ***  |  BashDirBlaster
      |  ***  |  Unleash the File System Explorer
      |_______|






   ```
## Mission Brief
Welcome, Pathfinder! *BashDirBlaster* is your trusty Linux tool for navigating the wild jungles of file systems. Built for speed and stealth, this Bash script scans directories recursively, hunts for files by extension, and logs your findings in JSON and CSV. Whether you're auditing codebases, tracking down configs, or mapping project structures, this tool is your map to buried treasure.

> **Warning**: Only explore territories you have clearance for. Unauthorized scans are a no-go.
## Features
- Recursive directory scanning with depth control.
- File filtering by extension.
- Advanced filters for size and age.
- Content search in files.
- Cleanup of temporary files.
- Interactive CLI menu for module selection.
- JSON and CSV output with error handling.

## Gear Up
- **Recursive Probes**: Dive deep into directories with configurable depth limits.
- **File Filters**: Target specific file types (e.g., `.sh`, `.txt`) like a laser.
- **Mission Logs**: Export results to JSON and CSV for easy analysis.
- **Control Panel**: Tweak settings in `config.json` for precision scans.
- **Resilience**: Auto-retries on errors to keep your mission on track.
- **Linux-Optimized**: Harnesses `find` and `jq` for blazing-fast performance.

## Launch Protocol
1. **Secure the Base**:
   ```bash
   git clone https://github.com/PicoBaz/BashDirBlaster.git
   cd BashDirBlaster
2. **Equip Dependencies**:
   Install `jq` for JSON processing:
   ```bash
   sudo apt install jq  # Ubuntu/Debian
   sudo dnf install jq  # Fedora
   ```
3. **Calibrate Scanner**:
   Edit `config.json` to set your target directory, extensions, and scan parameters.

4. **Initiate Scan**:
   ```bash
   bash dir_scanner.sh
   ```
    - **Output**: Check `scan_results.json` and `scan_results.csv` for your loot.
    - **Sample Config**:
      ```json
      {
        "directory": "./src",
        "extensions": [".sh"],
        "maxDepth": 5,
        "retryCount": 3,
        "retryDelayMs": 1000
      }
      ```

## Control Panel Settings
Tune your scanner in `config.json`:
- `directory`: Starting point (e.g., `./` for current folder).
- `extensions`: File types to hunt (e.g., `[".sh", ".txt"]`). Empty = all files.
- `maxDepth`: How deep to venture (e.g., `5`).
- `retryCount`: Retry attempts for blocked paths.
- `retryDelayMs`: Pause between retries (in milliseconds).

## Mission Log Example
```csv
Name,Path,Type,Extension,Size (Bytes),Timestamp,Error
"script.sh","./src/script.sh","file",".sh",1024,2025-08-27T11:56:00Z,
"utils","./src/utils","directory","",0,2025-08-27T11:56:00Z,
```

## Upgrade Your Gear
- **Custom Filters**: Add size or date-based filters in `dir_scanner.sh`.
- **Integrations**: Pair with `grep` or `awk` for advanced analysis.
- **Parallel Scans**: Use `parallel` for massive directories (fork and enhance!).

## Code of Conduct
This tool is for authorized missions only. Scan only what you own or have permission for. Misuse is not our style.

## License
MIT License. Check [LICENSE](LICENSE) for the fine print.

## Join the Expedition
Found a bug? Got a wild idea? Open an issue or PR at https://github.com/PicoBaz/BashDirBlaster.  
Drop a ⭐ if *BashDirBlaster* lights up your file system!

---
*Crafted by PicoBaz, 2025*
```