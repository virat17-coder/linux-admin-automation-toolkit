#!/usr/bin/env bash
# Menu-driven front end for the Lab 7 toolkit.
set -u
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
LOGDIR=${LOGDIR:-"$ROOT/sample_logs"}
show_menu() {
  echo '===== Linux Administration & Automation Toolkit ====='
  echo '1. System Monitoring Report'
  echo '2. Run Backup'
  echo '3. Analyze Logs'
  echo '4. Full Status Report'
  echo '5. Exit'
}
while true; do
  show_menu
  read -r -p 'Choice: ' choice || { echo; break; }
  case "$choice" in
    1) "$ROOT/monitor.sh" ;;
    2)
      read -r -p 'Backup or restore? (b/r): ' backup_action
      if [[ "$backup_action" == r || "$backup_action" == R ]]; then
        read -r -p 'Archive file: ' archive_file
        read -r -p 'Existing restore destination: ' restore_destination
        "$ROOT/backup.sh" restore "$archive_file" "$restore_destination"
        continue
      fi
      read -r -p 'Source dir: ' source_dir
      read -r -p 'Destination dir: ' destination_dir
      "$ROOT/backup.sh" "$source_dir" "$destination_dir"
      ;;
    3)
      read -r -p 'Log file (blank = analyze sample_logs/*.log): ' log_file
      if [[ -n "$log_file" ]]; then "$ROOT/log_analyzer.sh" "$log_file"; else
        shopt -s nullglob; logs=("$LOGDIR"/*.log); shopt -u nullglob
        if ((${#logs[@]})); then "$ROOT/log_analyzer.sh" "${logs[@]}"; else echo "No .log files found in $LOGDIR"; fi
      fi
      ;;
    4)
      "$ROOT/monitor.sh"
      shopt -s nullglob; logs=("$LOGDIR"/*.log); shopt -u nullglob
      if ((${#logs[@]})); then "$ROOT/log_analyzer.sh" "${logs[@]}"; else echo "No .log files found in $LOGDIR"; fi
      ;;
    5) echo 'Exiting toolkit.'; break ;;
    *) echo 'Invalid choice. Enter a number from 1 to 5.' ;;
  esac
  echo
done
