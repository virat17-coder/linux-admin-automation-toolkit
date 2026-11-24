# Lab 7 Capstone: Linux System Administration & Automation Toolkit

A menu-driven Bash toolkit that combines system monitoring, directory backup, and log analysis. It follows the Lab 7 brief shown in the supplied manual screenshots. Adapt module internals to match your own Lab 5 and Lab 6 scripts/output before final submission if your instructor expects exact reuse.

## Requirements

- Linux (Ubuntu recommended), Bash, `tar`, `grep`, `df`, `free`, and standard core utilities.
- No external package installation is required.

## Files

- `monitor.sh`: CPU load, logical CPU count, memory, disk, host, kernel, and collection time.
- `backup.sh`: creates a timestamped `.tar.gz` from an existing source directory, or restores an archive into a new subdirectory under an existing destination.
- `log_analyzer.sh`: counts and prints lines containing error/failure/critical/fatal markers across one or more files. Empty/no-match logs are handled safely.
- `dashboard.sh`: menu to run monitoring, backup, log analysis, or a combined status report.
- `sample_logs/system.log`: safe sample input for analysis.

## Run

```bash
chmod +x ./*.sh
./dashboard.sh
```

Menu option 3 accepts one log path; press Enter to analyze `sample_logs/*.log`. Option 4 prints monitoring and analyzes the sample logs. To use another log folder for the dashboard, set `LOGDIR=/path/to/logs` before starting it.

Run modules directly:

```bash
./monitor.sh
./backup.sh /path/to/source /path/to/existing-destination
./backup.sh restore /path/to/archive.tar.gz /path/to/existing-destination
./log_analyzer.sh sample_logs/system.log
./log_analyzer.sh /var/log/syslog /var/log/auth.log
```

The backup and restore destinations must already exist and be writable. The script rejects a backup destination inside the source to prevent the archive from being included in itself. Restore extracts into a new timestamped `restored_*` subdirectory. For protected system logs, use only files your account is permitted to read; do not run the whole dashboard as root by default.

## Validation checklist

1. Monitoring prints CPU, MEMORY, DISK, and SYSTEM sections.
2. A valid backup creates a non-empty timestamped `.tar.gz` in the destination; a valid restore extracts into a new subdirectory.
3. An empty log prints `No errors found.` and exits without a crash.
4. A nonexistent backup source prints an error and does not create the source directory.
5. A nonexistent log prints an error; invalid menu input is handled and the menu continues.

Capture your own terminal screenshots after running these checks and add them to the report before submitting. The included report is a draft and does not claim those commands were executed in your Linux environment.

## Design notes

The dashboard is the presentation/controller layer; each module is independently executable. This keeps monitoring, backup, and log parsing testable and reusable. Inputs are quoted to preserve paths containing spaces. Backup validates source/destination before invoking `tar`; log analysis tolerates no-match results from `grep`.
