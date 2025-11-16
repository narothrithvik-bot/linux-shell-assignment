#!/bin/bash

################################################################################
# Script Name: backup_directory.sh
# Purpose: Backup a specified directory to a backup folder with timestamp
# Author: [Your Name]
# Date: November 12, 2025
# Usage: ./backup_directory.sh <source_directory> <backup_destination>
################################################################################

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <backup_destination>"
    echo "Example: $0 /home/user/documents /home/user/backups"
    exit 1
fi

# Assign command line arguments to meaningful variable names
SOURCE_DIR="$1"
BACKUP_BASE="$2"

# Verify source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist!"
    exit 1
fi

# Create backup base directory if it doesn't exist
if [ ! -d "$BACKUP_BASE" ]; then
    echo "Creating backup base directory: $BACKUP_BASE"
    mkdir -p "$BACKUP_BASE"
fi

# Generate timestamp in format: YYYY-MM-DD_HH-MM-SS
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Get the basename of source directory for backup folder name
DIR_NAME=$(basename "$SOURCE_DIR")

# Create full backup path with timestamp
BACKUP_DIR="${BACKUP_BASE}/${DIR_NAME}_backup_${TIMESTAMP}"

# Display backup information
echo "=========================================="
echo "Directory Backup Script"
echo "=========================================="
echo "Source Directory: $SOURCE_DIR"
echo "Backup Location: $BACKUP_DIR"
echo "Timestamp: $TIMESTAMP"
echo "=========================================="

# Perform the backup using cp command with recursive flag
echo "Starting backup process..."
cp -r "$SOURCE_DIR" "$BACKUP_DIR"

# Check if backup was successful
if [ $? -eq 0 ]; then
    # Calculate size of backed up directory
    BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
    
    echo "=========================================="
    echo "Backup completed successfully!"
    echo "Backup Size: $BACKUP_SIZE"
    echo "Backup saved to: $BACKUP_DIR"
    echo "=========================================="
    exit 0
else
    echo "Error: Backup failed!"
    exit 1
fi