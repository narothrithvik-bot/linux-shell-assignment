#!/bin/bash

################################################################################
# Script Name: auto_download.sh
# Purpose: Automatically download files from the internet using wget/curl
# Author: Kanishk Grover
# Date: November 14, 2025
# Usage: ./auto_download.sh <file_url> [destination_directory]
# Example: ./auto_download.sh https://example.com/file.zip /home/user/downloads
################################################################################

# Check if URL is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <file_url> [destination_directory]"
    echo "Example: $0 https://example.com/file.zip /home/user/downloads"
    exit 1
fi

# Assign command line arguments
FILE_URL="$1"
DOWNLOAD_DIR="${2:-$HOME/Downloads}"  # Use second argument or default to ~/Downloads

# Create download directory if it doesn't exist
if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "Creating download directory: $DOWNLOAD_DIR"
    mkdir -p "$DOWNLOAD_DIR"
fi

# Extract filename from URL
FILE_NAME=$(basename "$FILE_URL")

# Full path for downloaded file
FULL_PATH="$DOWNLOAD_DIR/$FILE_NAME"

# Create log file for download history
LOG_FILE="$DOWNLOAD_DIR/download_log.txt"

# Display download information
echo "=========================================="
echo "Automated Download Script"
echo "=========================================="
echo "URL: $FILE_URL"
echo "Destination: $DOWNLOAD_DIR"
echo "Filename: $FILE_NAME"
echo "=========================================="

# Check if wget is available, otherwise use curl
if command -v wget &> /dev/null; then
    DOWNLOAD_TOOL="wget"
    echo "Using wget for download..."
    echo ""
    
    # Download file with wget (showing progress, continuing partial downloads)
    wget -c -P "$DOWNLOAD_DIR" "$FILE_URL"
    DOWNLOAD_STATUS=$?
    
elif command -v curl &> /dev/null; then
    DOWNLOAD_TOOL="curl"
    echo "Using curl for download..."
    echo ""
    
    # Download file with curl (showing progress, following redirects)
    curl -L -o "$FULL_PATH" "$FILE_URL"
    DOWNLOAD_STATUS=$?
    
else
    echo "Error: Neither wget nor curl is installed!"
    echo "Please install wget or curl to use this script."
    exit 1
fi

# Check download status
if [ $DOWNLOAD_STATUS -eq 0 ]; then
    # Get file size
    FILE_SIZE=$(du -h "$FULL_PATH" | cut -f1)
    
    # Get timestamp
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Log successful download
    echo "$TIMESTAMP | SUCCESS | $FILE_NAME | $FILE_SIZE | $FILE_URL" >> "$LOG_FILE"
    
    # Display success message
    echo ""
    echo "=========================================="
    echo "Download completed successfully!"
    echo "=========================================="
    echo "File: $FILE_NAME"
    echo "Size: $FILE_SIZE"
    echo "Location: $FULL_PATH"
    echo "Tool used: $DOWNLOAD_TOOL"
    echo "=========================================="
    
    # Verify file integrity (if it's a common archive format)
    case "$FILE_NAME" in
        *.zip)
            if command -v unzip &> /dev/null; then
                echo "Verifying ZIP file integrity..."
                unzip -t "$FULL_PATH" > /dev/null 2>&1
                if [ $? -eq 0 ]; then
                    echo "✓ ZIP file is valid"
                else
                    echo "⚠ Warning: ZIP file may be corrupted"
                fi
            fi
            ;;
        *.tar.gz|*.tgz)
            echo "Verifying TAR.GZ file integrity..."
            tar -tzf "$FULL_PATH" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "✓ TAR.GZ file is valid"
            else
                echo "⚠ Warning: TAR.GZ file may be corrupted"
            fi
            ;;
    esac
    
    exit 0
else
    # Log failed download
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP | FAILED | $FILE_NAME | N/A | $FILE_URL" >> "$LOG_FILE"
    
    # Display error message
    echo ""
    echo "=========================================="
    echo "Download failed!"
    echo "=========================================="
    echo "Please check:"
    echo "  - URL is correct and accessible"
    echo "  - Internet connection is working"
    echo "  - Sufficient disk space available"
    echo "=========================================="
    exit 1
fi