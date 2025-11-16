#!/bin/bash

################################################################################
# Script Name: cpu_memory_monitor.sh
# Purpose: Monitor and log CPU and memory usage at regular intervals
# Author: Kanishk Grover
# Date: November 14, 2025
# Usage: ./cpu_memory_monitor.sh [interval_seconds] [duration_minutes]
# Example: ./cpu_memory_monitor.sh 5 10
#          (Monitors every 5 seconds for 10 minutes)
################################################################################

# Default values for monitoring
DEFAULT_INTERVAL=10  # seconds between checks
DEFAULT_DURATION=5   # total minutes to monitor

# Use command line arguments or default values
INTERVAL=${1:-$DEFAULT_INTERVAL}
DURATION=${2:-$DEFAULT_DURATION}

# Create logs directory if it doesn't exist
LOG_DIR="$HOME/system_logs"
mkdir -p "$LOG_DIR"

# Generate log filename with timestamp
LOG_FILE="$LOG_DIR/system_monitor_$(date +"%Y%m%d_%H%M%S").log"

# Calculate total number of iterations
TOTAL_CHECKS=$((DURATION * 60 / INTERVAL))

# Display monitoring information
echo "=========================================="
echo "CPU & Memory Monitoring Script"
echo "=========================================="
echo "Interval: $INTERVAL seconds"
echo "Duration: $DURATION minutes"
echo "Total Checks: $TOTAL_CHECKS"
echo "Log File: $LOG_FILE"
echo "=========================================="
echo "Starting monitoring... Press Ctrl+C to stop"
echo ""

# Write header to log file
{
    echo "======================================"
    echo "System Monitor Log"
    echo "Start Time: $(date)"
    echo "Interval: $INTERVAL seconds"
    echo "======================================"
    echo ""
} > "$LOG_FILE"

# Counter for iterations
COUNT=0

# Monitoring loop
while [ $COUNT -lt $TOTAL_CHECKS ]; do
    # Increment counter
    COUNT=$((COUNT + 1))
    
    # Get current timestamp
    CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Get CPU usage (1 second average)
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    
    # Get memory information
    MEMORY_INFO=$(free -h | grep Mem)
    TOTAL_MEM=$(echo $MEMORY_INFO | awk '{print $2}')
    USED_MEM=$(echo $MEMORY_INFO | awk '{print $3}')
    FREE_MEM=$(echo $MEMORY_INFO | awk '{print $4}')
    MEM_PERCENT=$(free | grep Mem | awk '{printf("%.2f%%", $3/$2 * 100.0)}')
    
    # Get disk usage for root partition
    DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}')
    
    # Display on console
    echo "[$COUNT/$TOTAL_CHECKS] $CURRENT_TIME"
    echo "  CPU Usage: $CPU_USAGE"
    echo "  Memory: $USED_MEM / $TOTAL_MEM ($MEM_PERCENT used)"
    echo "  Disk Usage: $DISK_USAGE"
    echo ""
    
    # Write to log file
    {
        echo "--- Check #$COUNT at $CURRENT_TIME ---"
        echo "CPU Usage: $CPU_USAGE"
        echo "Memory Total: $TOTAL_MEM"
        echo "Memory Used: $USED_MEM ($MEM_PERCENT)"
        echo "Memory Free: $FREE_MEM"
        echo "Disk Usage (root): $DISK_USAGE"
        echo ""
    } >> "$LOG_FILE"
    
    # Wait for specified interval (unless last iteration)
    if [ $COUNT -lt $TOTAL_CHECKS ]; then
        sleep $INTERVAL
    fi
done

# Write completion message to log
{
    echo "======================================"
    echo "Monitoring Complete"
    echo "End Time: $(date)"
    echo "Total Checks Performed: $COUNT"
    echo "======================================"
} >> "$LOG_FILE"

# Display completion message
echo "=========================================="
echo "Monitoring completed!"
echo "Log saved to: $LOG_FILE"
echo "=========================================="