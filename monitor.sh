#!/bin/bash
# This script will monitor a specified directory for new files or directories created in it.
specifiedDir="$1"
if [ -z "$specifiedDir" ]; then
    echo "Usage: $0 <directory_to_monitor>"
    exit 1
fi

tempFile="/tmp/monitorTemp$$.txt"
touch "$tempFile"

cleanup() {
    rm -f "$tempFile" "$newFiles"
    echo "Temporary files cleaned up. Exiting."
    exit 0
}

trap cleanup SIGINT SIGTERM

checkNewFiles() {
    local newFiles="/tmp/monitorNewFiles$$.txt"
    find "$specifiedDir" -type f -o -type d > "$newFiles"

    comm -13 "$tempFile" "$newFiles" > /tmp/newlyCreated$$.txt

    cat /tmp/newlyCreated$$.txt >> "$tempFile"

    cat /tmp/newlyCreated$$.txt

    rm -f /tmp/newlyCreated$$.txt
    rm -f "$newFiles"
}

while true; do
    echo "Checking for changes in $specifiedDir..."
    checkNewFiles
    echo "Sleeping for 10 seconds..."
    sleep 10
done
