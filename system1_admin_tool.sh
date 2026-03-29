#!/bin/bash

LOG_FILE="system_monitor_log.txt"
ARCHIVE_DIR="ArchiveLogs"

touch "$LOG_FILE"

# -------------------------------
# Logging Function
# -------------------------------
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# -------------------------------
# CPU & Memory Usage
# -------------------------------
cpu_memory_usage() {
    echo "===== CPU & MEMORY USAGE ====="
    top -bn1 | grep "Cpu"
    free -h
    log_action "Viewed CPU and memory usage"
}

# -------------------------------
# Top 10 Memory Processes
# -------------------------------
top_processes() {
    echo "===== TOP 10 MEMORY PROCESSES ====="
    ps -eo pid,user,%cpu,%mem,comm --sort=-%mem | head -n 11
    log_action "Viewed top memory processes"
}

# -------------------------------
# Kill Process Safely
# -------------------------------
kill_process() {
    read -p "Enter PID to terminate: " pid

    # Prevent killing critical processes
    critical=("1" "2")
    for c in "${critical[@]}"; do
        if [ "$pid" = "$c" ]; then
            echo "Cannot terminate critical system process (PID $pid)"
            return
        fi
    done

    # Check if process exists
    if ! ps -p "$pid" > /dev/null; then
        echo "Process does not exist."
        return
    fi

    read -p "Confirm kill $pid? (Y/N): " confirm
    if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ]; then
        kill "$pid"
        echo "Process $pid terminated."
        log_action "Killed process $pid"
    else
        echo "Cancelled"
    fi
}

# -------------------------------
# Disk Usage
# -------------------------------
disk_usage() {
    read -p "Enter directory: " dir

    if [ ! -d "$dir" ]; then
        echo "Invalid directory"
        return
    fi

    du -sh "$dir" 2>/dev/null
    log_action "Checked disk usage for $dir"
}

# -------------------------------
# Archive Logs (>50MB)
# -------------------------------
archive_logs() {
    read -p "Enter directory to scan: " dir

    if [ ! -d "$dir" ]; then
        echo "Invalid directory"
        return
    fi

    mkdir -p "$ARCHIVE_DIR"

    mapfile -t files < <(find "$dir" -type f -iname "*.log" -size +50M)

    if [ ${#files[@]} -eq 0 ]; then
        echo "No large log files found."
        return
    fi

    for file in "${files[@]}"; do
        base=$(basename "$file")
        timestamp=$(date '+%Y%m%d_%H%M%S')

        gzip -c "$file" > "$ARCHIVE_DIR/${base}_$timestamp.gz"

        echo "Archived $file"
        log_action "Archived $file"
    done

    size=$(du -sm "$ARCHIVE_DIR" | cut -f1)
    if [ "$size" -gt 1024 ]; then
        echo "WARNING: ArchiveLogs exceeds 1GB"
        log_action "ArchiveLogs exceeded 1GB"
    fi
}

# -------------------------------
# Exit System
# -------------------------------
exit_system() {
    read -p "Exit system? (Y/N): " confirm
    if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ]; then
        echo "Bye!"
        exit 0
    fi
}

# -------------------------------
# MENU
# -------------------------------
while true
do
    echo ""
    echo "====== SYSTEM ADMIN TOOL ======"
    echo "1. CPU & Memory Usage"
    echo "2. Top Processes"
    echo "3. Kill Process"
    echo "4. Disk Usage"
    echo "5. Archive Logs"
    echo "6. Bye"

    read -p "Choice: " choice

    case $choice in
        1) cpu_memory_usage ;;
        2) top_processes ;;
        3) kill_process ;;
        4) disk_usage ;;
        5) archive_logs ;;
        6) exit_system ;;
        *) echo "Invalid option" ;;
    esac
done