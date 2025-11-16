# Linux Shell Assignment

This repository contains shell scripts for Linux automation as part of the Computer Science course assignment.

## 📁 Project Structure
```
linux-shell-assignment/
├── scripts/
│   ├── backup_directory.sh
│   ├── cpu_memory_monitor.sh
│   └── auto_download.sh
├── screenshots/
└── README.md
```

## 🚀 Scripts Overview

### 1. backup_directory.sh
**Purpose:** Creates timestamped backups of directories

**Usage:**
```bash
./backup_directory.sh <source_directory> <backup_destination>
```

**Example:**
```bash
./backup_directory.sh ~/projects ~/backups
```

### 2. cpu_memory_monitor.sh
**Purpose:** Monitors CPU and memory usage at regular intervals

**Usage:**
```bash
./cpu_memory_monitor.sh [interval_seconds] [duration_minutes]
```

**Example:**
```bash
./cpu_memory_monitor.sh 5 10
```

### 3. auto_download.sh
**Purpose:** Automatically downloads files from the internet

**Usage:**
```bash
./auto_download.sh <file_url> [destination_directory]
```

**Example:**
```bash
./auto_download.sh https://example.com/file.zip ~/Downloads
```

## 📋 Installation & Setup

1. Clone this repository:
```bash
git clone https://github.com/YOUR_USERNAME/linux-shell-assignment.git
cd linux-shell-assignment/scripts
```

2. Make scripts executable:
```bash
chmod +x *.sh
```

3. Run any script:
```bash
./backup_directory.sh ~/test ~/backups
```

## 🛠️ Requirements

- Ubuntu Linux (or any Linux distribution)
- Bash shell
- wget or curl (for auto_download.sh)

## 👨‍💻 Author

**Your Name**  
BCA (AI & DS) - Semester 1  
K.R. Mangalam University

## 📝 Assignment Details

- **Course:** ETCCCS104 - Essentials of Computer Science and Career Skills
- **Assignment:** Linux Setup, Command Usage, and Automation
- **Date:** November 2025

## 📸 Screenshots

Screenshots demonstrating script execution are available in the `screenshots/` directory.

## 🎯 Learning Outcomes

- Linux command-line proficiency
- Shell scripting and automation
- Version control with Git and GitHub
- System monitoring and management
- File operations and backups
