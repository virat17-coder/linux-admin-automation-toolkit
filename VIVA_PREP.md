# Lab 7 Viva Quick Prep

## 30-second project introduction

"My project is a menu-driven Linux administration and automation toolkit written in Bash. It integrates four functions: CPU, memory and disk monitoring; compressed directory backup and restore; error-log analysis; and a dashboard that invokes each module and provides a combined status report. I separated each module into its own script so it can be run independently, with input validation for common failure cases."

Only say you tested cases after you actually run them on Linux and capture the output.

## How the parts fit together

1. `dashboard.sh` finds its own directory using `BASH_SOURCE[0]`, displays a `while` menu, reads a choice, and dispatches with `case`.
2. `monitor.sh` reads Linux system information: `/proc/loadavg`, `nproc`, `free`, and `df`.
3. `backup.sh` checks argument count, validates a readable source and writable existing destination, then uses `tar -czf` to create a gzip-compressed archive. Restore mode extracts into a new subdirectory.
4. `log_analyzer.sh` accepts one or more files and uses `grep -Eic` to count matching lines and `grep -Ein` to show them. `|| true` prevents grep's normal no-match exit code from breaking the script.
5. The dashboard's full report runs monitoring and log analysis; `LOGDIR` can select the log folder.

## Likely questions and short answers

**Why Bash?** It is available on Linux and fits command orchestration and administration tasks without extra dependencies.

**What does `set -u` do?** It treats expansion of an unset variable as an error, catching some scripting mistakes early.

**Why quote `"$variable"`?** So spaces and wildcard characters inside a path are treated as part of one argument.

**What is `tar -czf`?** `c` creates an archive, `z` filters it through gzip, and `f` names the archive file.

**Why reject a destination inside the source?** Otherwise the archive being written may be picked up as part of the input tree, causing recursive growth or a corrupted backup.

**What is the difference between `grep -i` and `grep -E`?** `-i` ignores letter case; `-E` enables extended regular expressions, used here for multiple error markers.

**How does restore work?** It validates the archive and destination, creates a fresh `restored_*` directory, and extracts there with `tar -xzf`.

**Why handle grep's exit status?** `grep` returns 1 when there are no matches. That is a normal result for an empty/no-error log, not a program failure.

**What are the edge cases?** Missing source, missing/unwritable destination, empty log, no matching log lines, unreadable log, and invalid dashboard choice.

**What does the monitoring CPU section measure?** The load average is the average runnable/uninterruptible task load over 1, 5, and 15 minutes; it is not a direct percentage CPU measurement. `nproc` reports logical CPUs.

**Why not run everything with sudo?** Least privilege reduces risk. Only a specific operation that needs access should request elevated permissions.

**How would you improve this?** Add structured output/CSV, configurable thresholds, retention and rotation for backups, archive integrity checks, service/process checks, and automated tests.

## Before tomorrow

- On Ubuntu/WSL, open the project folder and run `chmod +x ./*.sh`.
- Run `./monitor.sh`, `./log_analyzer.sh sample_logs/system.log`, and the dashboard options.
- Create a temporary source folder and an existing destination folder; test backup and verify with `tar -tzf archive.tar.gz`.
- Test a missing source and an empty log.
- Take terminal screenshots and put them into the report; do not claim test results you did not observe.
- Be ready to explain one command, one validation, and one limitation in your own words.
