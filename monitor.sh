#!/bin/bash
# This script monitors a specified directory for new files or directories.

specifiedDir="$1"
if [ -z "$specifiedDir" ]; then
    echo "Usage: $0 <directory_to_monitor>"
    exit 1
fi

# Initial snapshot of the directory
initialSnapshot=$(find "$specifiedDir" -type f -o -type d)

trap "echo 'Exiting.'; exit 0" SIGINT SIGTERM

while true; do
    currentSnapshot=$(find "$specifiedDir" -type f -o -type d)
    
    # Compare and show new files or directories
    newItems=$(comm -13 <(echo "$initialSnapshot") <(echo "$currentSnapshot"))
    
    if [ -n "$newItems" ]; then
        echo "New items detected:"
        echo "$newItems"
        initialSnapshot="$currentSnapshot"
    fi
    
    sleep 10
done
