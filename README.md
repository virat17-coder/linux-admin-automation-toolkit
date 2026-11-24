# Linux System Administration & Automation Toolkit

A menu-driven Bash toolkit for Linux system monitoring, compressed directory backup and restore, and log analysis. It brings the Lab 7 capstone functions together in one terminal dashboard.

## Features

- **System monitoring:** reports CPU load averages, logical CPU count, memory, disk usage, hostname, kernel, and collection time.
- **Backup and restore:** creates timestamped `.tar.gz` archives and restores an archive into a new timestamped directory.
- **Log analysis:** counts and displays lines containing common error markers across one or more log files; empty logs are handled safely.
- **Menu dashboard:** runs each module separately or displays a combined status report.
- **Input validation:** handles missing source paths, missing logs, invalid menu choices, and unreadable inputs with clear messages.

## Project structure

```text
Lab7_Capstone/
├── README.md
├── monitor.sh
├── backup.sh
├── log_analyzer.sh
├── dashboard.sh
├── sample_logs/
│   └── system.log
├── VIVA_PREP.md
└── Lab7_Capstone_Report_and_Viva.pdf
```

## Requirements

- Ubuntu or another Linux distribution (run on Ubuntu via WSL)
- Bash, `tar`, `grep`, `df`, `free`, and standard Linux utilities
- No external package installation required

## Run the toolkit

```bash
chmod +x ./*.sh
./dashboard.sh
```

Choose an option from the menu:

1. System Monitoring Report
2. Run Backup or Restore
3. Analyze Logs
4. Full Status Report
5. Exit

The dashboard analyzes `sample_logs/*.log` by default. Set `LOGDIR` to use another folder:

```bash
LOGDIR=/path/to/logs ./dashboard.sh
```

## Run modules directly

```bash
./monitor.sh
./backup.sh /path/to/source /path/to/existing-destination
./backup.sh restore /path/to/archive.tar.gz /path/to/existing-destination
./log_analyzer.sh sample_logs/system.log
./log_analyzer.sh /path/to/first.log /path/to/second.log
```

Backup and restore destinations must already exist and be writable. A backup destination cannot be inside its source directory. Restore extracts files into a new `restored_*` subdirectory.

## Validation results

Run evidence is included in the report PDF. These cases were observed in Ubuntu on WSL:

| Case | Result |
|---|---|
| Full status report | Monitoring sections displayed and the sample error line was detected. |
| Valid backup | Timestamped `.tar.gz` archive created successfully. |
| Restore | Archive extracted successfully into a new `restored_*` directory. |
| Empty log | Printed `No errors found.` without crashing. |
| Missing backup source | Printed an error and did not create the source directory. |
| Invalid dashboard choice | Not run. |

## Design notes

The dashboard is the front end and each module is independently executable. `monitor.sh` reads Linux load information from `/proc/loadavg` and uses `nproc`, `free`, and `df`. `backup.sh` uses `tar` for compressed archives. `log_analyzer.sh` uses `grep` to count and display matching lines. Inputs are quoted so paths containing spaces remain a single argument.

CPU load average represents runnable and uninterruptible task load over 1, 5, and 15 minutes; it is not a direct CPU-utilization percentage. Log analysis uses common error keywords and may need adjustment for application-specific log formats.

## Viva preparation and report

- Viva quick prep: `VIVA_PREP.md`
- Capstone report with terminal evidence: `Lab7_Capstone_Report_and_Viva.pdf`

## Course context

This project implements the Lab 7 Linux System Administration & Automation capstone. If the instructor requires exact reuse of Lab 5 or Lab 6 scripts or output formats, compare those earlier lab files with these modules and adapt them before submission.
