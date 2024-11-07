  GNU nano 6.2                                                                                                                                              monitor.sh
#!/bin/bash
# This script will monitor a specified directory for new files or directories created in it.

SPECIFIED_DIR="$1"

if [ -z "$SPECIFIED_DIR" ]; then
    echo "Usage: $0 <directory_to_monitor>"
    exit 1
fi

temp_file="/tmp/monitor_snapshot_$$.txt"
touch "$temp_file"
cumulative_snapshot=$(find "$SPECIFIED_DIR" -type f -o -type d)
echo "$cumulative_snapshot" > "$temp_file"

check_new_files() {
    echo "Monitoring for new files or directories in $SPECIFIED_DIR..."
    current_snapshot=$(find "$SPECIFIED_DIR" -type f -o -type d)

    previous_snapshot=$(cat "$temp_file")

    for item in $current_snapshot; do
        if ! echo "$previous_snapshot" | grep -qx "$item"; then
            echo "New item detected: $item"
            cumulative_snapshot="$cumulative_snapshot"$'\n'"$item"
        fi
    done

    # Update the temporary file with the current snapshot
    echo "$cumulative_snapshot" > "$temp_file"
}

cleanup() {
    echo "Cleaning up temporary files..."
    rm -f "$temp_file"
    echo "All Cleaned up, exiting program"
    exit 0
}
trap cleanup SIGINT SIGTERM


while true; do
    check_new_files
    echo "Sleeping for 60 seconds..."
    sleep 60
done
