#!/bin/bash

# Script to get SHA1 hashes of files in Pi snapshot SavedClips
# Creates one hash file per event folder, skips already processed events
# Output format: SHA1 filename (sorted by filename)

SNAPSHOT_PATH="/tmp/snapshots/snap-003297/TeslaCam/SavedClips"
OUTPUT_DIR="pi_hashes"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Process specific event folders or all if no argument provided
if [ "$1" = "" ]; then
    EVENT_FILTER=""
    FILTER_DESC="ALL events"
    echo "Processing all event folders..."
    
    # Get list of all event directories
    EVENT_DIRS=$(ssh teslausb "ls -1 $SNAPSHOT_PATH" | sort)
    
    for event_dir in $EVENT_DIRS; do
        OUTPUT_FILE="$OUTPUT_DIR/${event_dir}_hashes.txt"
        
        # Skip if already processed
        if [ -f "$OUTPUT_FILE" ]; then
            echo "Skipping $event_dir (already processed)"
            continue
        fi
        
        echo "Processing event: $event_dir"
        
        # Create header
        echo "# SHA1 hashes from Pi snapshot SavedClips" > "$OUTPUT_FILE"
        echo "# Generated on $(date)" >> "$OUTPUT_FILE"
        echo "# Event: $event_dir" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        
        # Process files for this event
        ssh teslausb "find $SNAPSHOT_PATH/$event_dir -type f \( -name '*.mp4' -o -name '*.json' \) | sort | xargs -P 4 -I {} sh -c 'sha1sum \"{}\"'" | while read hash filepath; do
            # Extract just the filename from the full path
            filename=$(basename "$filepath")
            echo "$hash $filename"
        done | sort -k2 >> "$OUTPUT_FILE"
        
        file_count=$(grep -v '^#' "$OUTPUT_FILE" | grep -v '^$' | wc -l)
        echo "  -> $file_count files processed, saved to: $OUTPUT_FILE"
    done
    
    echo "All events processed. Hash files saved in: $OUTPUT_DIR/"
    
else
    # Process specific event
    EVENT_DIR="$1"
    OUTPUT_FILE="$OUTPUT_DIR/${EVENT_DIR}_hashes.txt"
    
    # Skip if already processed
    if [ -f "$OUTPUT_FILE" ]; then
        echo "Event $EVENT_DIR already processed: $OUTPUT_FILE"
        exit 0
    fi
    
    echo "Processing event: $EVENT_DIR"
    
    # Create header
    echo "# SHA1 hashes from Pi snapshot SavedClips" > "$OUTPUT_FILE"
    echo "# Generated on $(date)" >> "$OUTPUT_FILE"
    echo "# Event: $EVENT_DIR" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Process files for this event
    ssh teslausb "find $SNAPSHOT_PATH/$EVENT_DIR -type f \( -name '*.mp4' -o -name '*.json' \) | sort | xargs -P 4 -I {} sh -c 'sha1sum \"{}\"'" | while read hash filepath; do
        # Extract just the filename from the full path
        filename=$(basename "$filepath")
        echo "$hash $filename"
    done | sort -k2 >> "$OUTPUT_FILE"
    
    file_count=$(grep -v '^#' "$OUTPUT_FILE" | grep -v '^$' | wc -l)
    echo "SHA1 hashes saved to: $OUTPUT_FILE"
    echo "Total files processed: $file_count"
fi