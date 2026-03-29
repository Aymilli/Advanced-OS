#!/bin/bash

SUBMISSION_DIR="submissions"
LOG_FILE="submission_log.txt"
LOGIN_LOG="login_log.txt"
LOCK_FILE="locked_accounts.txt"

mkdir -p "$SUBMISSION_DIR"
touch "$LOG_FILE" "$LOGIN_LOG" "$LOCK_FILE"

# -------------------------------
# Logging Functions
# -------------------------------
log_submission() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log_login() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGIN_LOG"
}

# -------------------------------
# Submit Assignment
# -------------------------------
submit_assignment() {
    read -p "Enter Student ID: " sid
    read -p "Enter file path: " filepath

    if [ ! -f "$filepath" ]; then
        echo "File does not exist."
        return
    fi

    filename=$(basename "$filepath")

    # File validation
    case "$filename" in
        *.pdf|*.docx) ;;
        *)
            echo "Only .pdf and .docx allowed."
            return
            ;;
    esac

    # File size check (5MB max)
    size=$(stat -c%s "$filepath")
    if [ "$size" -gt 5242880 ]; then
        echo "File exceeds 5MB."
        return
    fi

    # Duplicate detection
    for existing in "$SUBMISSION_DIR"/*; do
        [ -e "$existing" ] || continue
        if [ "$(basename "$existing")" = "$filename" ] && cmp -s "$existing" "$filepath"; then
            echo "Duplicate submission detected."
            return
        fi
    done

    cp "$filepath" "$SUBMISSION_DIR/"
    echo "Submission successful."
    log_submission "SUBMIT: $sid - $filename"
}

# -------------------------------
# Check Duplicate
# -------------------------------
check_duplicate() {
    read -p "Enter file path to check: " filepath

    if [ ! -f "$filepath" ]; then
        echo "File not found."
        return
    fi

    filename=$(basename "$filepath")

    for existing in "$SUBMISSION_DIR"/*; do
        [ -e "$existing" ] || continue
        if [ "$(basename "$existing")" = "$filename" ] && cmp -s "$existing" "$filepath"; then
            echo "Duplicate exists."
            return
        fi
    done

    echo "No duplicate found."
}

# -------------------------------
# List Submissions
# -------------------------------
list_submissions() {
    echo "===== SUBMITTED FILES ====="
    ls "$SUBMISSION_DIR"
}

# -------------------------------
# Login Simulation (UPDATED)
# -------------------------------
login_attempt() {
    read -p "Enter Username: " user

    # Check if locked
    if grep -q "^$user$" "$LOCK_FILE"; then
        echo "Account locked."
        log_login "BLOCKED: $user attempted login"
        return
    fi

    read -s -p "Enter Password: " pass
    echo ""

    correct="password123"
    now=$(date +%s)

    attempts_file="attempts_$user.txt"
    touch "$attempts_file"

    echo "$now" >> "$attempts_file"

    # Count attempts within 60 seconds
    recent=$(awk -v now="$now" '$1 > now-60' "$attempts_file" | wc -l)

    if [ "$pass" = "$correct" ]; then
        echo "Login successful."
        log_login "SUCCESS: $user logged in"
        > "$attempts_file"
        return
    else
        echo "Login failed."
        log_login "FAILED: $user"

        if [ "$recent" -ge 3 ]; then
            echo "Account locked due to multiple attempts."
            echo "$user" >> "$LOCK_FILE"
            log_login "LOCKED: $user"
        fi
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
    echo "====== SECURE SUBMISSION SYSTEM ======"
    echo "1. Submit Assignment"
    echo "2. Check Duplicate"
    echo "3. List Submissions"
    echo "4. Simulate Login"
    echo "5. Exit"

    read -p "Choice: " choice

    case $choice in
        1) submit_assignment ;;
        2) check_duplicate ;;
        3) list_submissions ;;
        4) login_attempt ;;
        5) exit_system ;;
        *) echo "Invalid option" ;;
    esac
done