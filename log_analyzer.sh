#!/usr/bin/env bash
# Count common error markers in one or more log files.
set -u
if [[ $# -lt 1 ]]; then echo "Usage: $0 LOG_FILE [LOG_FILE ...]" >&2; exit 2; fi
found_file=0
for file in "$@"; do
  if [[ ! -e "$file" ]]; then echo "Error: log file not found: $file" >&2; continue; fi
  if [[ ! -f "$file" || ! -r "$file" ]]; then echo "Error: not a readable regular file: $file" >&2; continue; fi
  found_file=1
  printf '\n==== Log: %s ====\n' "$file"
  count=$(grep -Eic 'error|fail(ed|ure)?|critical|fatal' -- "$file" || true)
  if [[ "$count" -eq 0 ]]; then
    echo 'No errors found.'
  else
    printf 'Matching error lines: %s\n' "$count"
    grep -Ein 'error|fail(ed|ure)?|critical|fatal' -- "$file" || true
  fi
done
if [[ "$found_file" -eq 0 ]]; then exit 1; fi
