#!/bin/bash

QUEUE_FILE="job_queue.txt"
COMPLETED_FILE="completed_jobs.txt"
LOG_FILE="scheduler_log.txt"

# Ensure files exist
touch "$QUEUE_FILE" "$COMPLETED_FILE" "$LOG_FILE"

# -------------------------------
# Logging Function
# -------------------------------
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# -------------------------------
# Submit Job
# -------------------------------
submit_job() {
    read -p "Enter Student ID: " sid
    read -p "Enter Job Name: " job
    read -p "Enter Execution Time (seconds): " time
    read -p "Enter Priority (1-10): " priority

    if [ "$priority" -lt 1 ] || [ "$priority" -gt 10 ]; then
        echo "Priority must be between 1 and 10"
        return
    fi

    echo "$sid,$job,$time,$priority" >> "$QUEUE_FILE"
    echo "Job submitted."

    log_action "SUBMIT: $sid,$job (Time=$time, Priority=$priority)"
}

# -------------------------------
# View Pending Jobs
# -------------------------------
view_jobs() {
    echo "===== PENDING JOBS ====="
    if [ ! -s "$QUEUE_FILE" ]; then
        echo "No pending jobs."
    else
        cat "$QUEUE_FILE"
    fi
}

# -------------------------------
# View Completed Jobs
# -------------------------------
view_completed() {
    echo "===== COMPLETED JOBS ====="
    if [ ! -s "$COMPLETED_FILE" ]; then
        echo "No completed jobs."
    else
        cat "$COMPLETED_FILE"
    fi
}
# -------------------------------
# Clear Jobs
# -------------------------------
clear_jobs(){
 > "$QUEUE_FILE"
   echo "All pending jobs cleared."
  log_action "CLEARED ALL JOBS"
}

# -------------------------------
# Round Robin Scheduling
# -------------------------------
round_robin() {
    quantum=5
    temp_file="temp_queue.txt"
    > "$temp_file"

    while IFS=',' read -r sid job time priority; do

        if [ "$time" -gt "$quantum" ]; then
            echo "Processing $job for $quantum seconds"
            sleep 1

            remaining=$((time - quantum))
            echo "$sid,$job,$remaining,$priority" >> "$temp_file"

            log_action "RR: $sid,$job processed 5s (remaining $remaining)"

        else
            echo "Completing $job"
            sleep 1

            echo "$sid,$job,$time,$priority" >> "$COMPLETED_FILE"
            log_action "RR COMPLETE: $sid,$job"
        fi

    done < "$QUEUE_FILE"

    mv "$temp_file" "$QUEUE_FILE"
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
    echo "====== JOB SCHEDULER ======"
    echo "1. View Pending Jobs"
    echo "2. Submit Job"
    echo "3. Clear all jobs"
    echo "4. Round Robin Scheduling"
    echo "5. View Completed Jobs"
    echo "6. Exit"

    read -p "Choice: " choice

    case $choice in
        1) view_jobs ;;
        2) submit_job ;;
        3) clear_jobs ;;
        4) round_robin ;;
        5) view_completed ;;
        6) exit_system ;;
        *) echo "Invalid option" ;;
    esac
done