# Advanced-OS
Bash Script Source Code for Operating System Automation and Management

This project provides a set of Bash scripts designed to automate key Linux operating system administration tasks. It focuses on process management, job scheduling, and secure file handling using simple, interactive command-line tools.

Project Overview

The project consists of three main scripts:

system1_admin_tool.sh (Task 1)

A menu-driven tool for managing Linux OS processes and system resources.
jobs_scheduler.sh (Task 2)
A script for automating and managing scheduled jobs.
secure_submission.sh (Task 3)
A tool for secure file submission with controlled access and permissions.

Features
Process monitoring and management
Memory and disk usage tracking
Job scheduling and automation
Secure file submission and permission control
Log management and archiving
Interactive, user-friendly interface

Getting Started
1. Clone the Repository
git clone https://github.com/Aymilli/Advanced-OS.git
cd your-repo-name
2. Make Scripts Executable
chmod +x system1_admin_tool.sh
chmod +x jobs_scheduler.sh
chmod +x secure_submission.sh
3. Run the Scripts

Task 1: OS Management Tool
./system1_admin_tool.sh

Run the script and select options from the menu to manage Linux OS processes.

Task 2: Job Scheduler
./jobs_scheduler.sh

Use this script to schedule and automate system tasks.

Task 3: Secure Submission Tool
./secure_submission.sh

This script ensures secure handling of files, including permission control and restricted access.

Usage
Execute any script using ./script_name.sh
Follow the on-screen instructions
Select options using the menu interface (where applicable)

Project Structure
.
├── system1_admin_tool.sh   # Task 1: OS management tool
├── jobs_scheduler.sh       # Task 2: Job scheduler
├── secure_submission.sh    # Task 3: Secure submission tool
└── README.md               # Project documentation

Requirements
Linux-based operating system
Bash shell (version 4 or higher recommended)
Standard POSIX-compliant tools such as:
grep
ps
df
stat
find

Task Breakdown

Task 1 – OS Management
Monitor running processes
Identify high memory usage
Check disk space
Manage and archive logs

Task 2 – Job Scheduling
Schedule automated tasks
Run periodic system maintenance
Manage background jobs

Task 3 – Secure Submission
Enforce file permissions
Secure file submissions
Prevent unauthorized access

Contributing
Contributions are welcome!
1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request

License

This project is licensed under the MIT License.

