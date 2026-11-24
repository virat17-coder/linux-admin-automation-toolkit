#!/usr/bin/env bash
# Create or restore a gzip-compressed tar archive.
set -u
usage() { echo "Usage: $0 SOURCE_DIR DESTINATION_DIR | $0 restore ARCHIVE DESTINATION_DIR" >&2; }
if [[ $# -eq 3 && "$1" == restore ]]; then
  archive=$2; dest=$3
  if [[ ! -f "$archive" || ! -r "$archive" ]]; then echo "Error: archive does not exist or is unreadable: $archive" >&2; exit 1; fi
  if [[ ! -d "$dest" || ! -w "$dest" ]]; then echo "Error: destination must be an existing writable directory: $dest" >&2; exit 1; fi
  dest_abs=$(cd -- "$dest" && pwd -P) || exit 1
  restore_dir="$dest_abs/restored_$(date '+%Y%m%d_%H%M%S')"
  if ! mkdir -- "$restore_dir"; then echo "Error: restore directory already exists: $restore_dir" >&2; exit 1; fi
  if tar -xzf "$archive" -C "$restore_dir" --no-same-owner; then
    printf 'Restore successful in: %s\n' "$restore_dir"
  else
    echo 'Error: restore failed; inspect the partial restore directory.' >&2
    exit 1
  fi
else
  if [[ $# -ne 2 ]]; then usage; exit 2; fi
  src=$1; dest=$2
  if [[ ! -d "$src" ]]; then echo "Error: source directory does not exist: $src" >&2; exit 1; fi
  if [[ ! -r "$src" ]]; then echo "Error: source directory is not readable: $src" >&2; exit 1; fi
  if [[ ! -d "$dest" ]]; then echo "Error: destination directory does not exist: $dest" >&2; exit 1; fi
  if [[ ! -w "$dest" ]]; then echo "Error: destination directory is not writable: $dest" >&2; exit 1; fi
  src_abs=$(cd -- "$src" && pwd -P) || exit 1
  dest_abs=$(cd -- "$dest" && pwd -P) || exit 1
  if [[ "$src_abs" == "$dest_abs" || "$dest_abs" == "$src_abs"/* ]]; then
    echo 'Error: destination must not be the source directory or inside it.' >&2; exit 1
  fi
  base=$(basename -- "$src_abs")
  stamp=$(date '+%Y%m%d_%H%M%S_%N')
  archive="$dest_abs/${base}_$stamp.tar.gz"
  if tar -czf "$archive" -C "$(dirname -- "$src_abs")" -- "$base"; then
    printf 'Backup successful: %s\n' "$archive"
  else
    rm -f -- "$archive"
    echo 'Error: backup failed; incomplete archive removed.' >&2
    exit 1
  fi
fi
