#!/usr/bin/env bash
# Lab 7 Linux Administration & Automation Toolkit - system monitor
set -u

section() { printf '\n==== %s ====\n' "$1"; }

section 'CPU'
if [[ -r /proc/loadavg ]]; then
  read -r load1 load5 load15 _ < /proc/loadavg
  printf 'Load average (1/5/15 min): %s %s %s\n' "$load1" "$load5" "$load15"
else
  echo 'CPU load data unavailable (/proc/loadavg not readable).'
fi
if command -v nproc >/dev/null 2>&1; then printf 'Logical CPUs: %s\n' "$(nproc)"; fi

section 'MEMORY'
if command -v free >/dev/null 2>&1; then
  free -h
elif [[ -r /proc/meminfo ]]; then
  awk '/^(MemTotal|MemAvailable|SwapTotal|SwapFree):/ {print}' /proc/meminfo
else
  echo 'Memory data unavailable.'
fi

section 'DISK'
if command -v df >/dev/null 2>&1; then df -hP -x tmpfs -x devtmpfs; else echo 'df command unavailable.'; fi

section 'SYSTEM'
printf 'Hostname: %s\n' "$(hostname 2>/dev/null || echo unknown)"
printf 'Kernel: %s\n' "$(uname -sr 2>/dev/null || echo unknown)"
printf 'Collected: %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || echo unknown)"
