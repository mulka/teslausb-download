#!/bin/bash

# Script to get SHA1 hashes of files in Pi snapshot SavedClips
# Output format: SHA1 filename (sorted by filename)

SNAPSHOT_PATH="/tmp/snapshots/snap-003297/TeslaCam/SavedClips"
OUTPUT_FILE="pi_savedclips_hashes.txt"

# Process specific event folders or all if no argument provided
if [ "$1" = "" ]; then
    EVENT_FILTER=""
    FILTER_DESC="ALL events"
else
    EVENT_FILTER="$1"
    FILTER_DESC="$EVENT_FILTER"
fi

echo "Generating SHA1 hashes for Pi SavedClips files..."
echo "Processing event(s): $FILTER_DESC"
echo "# SHA1 hashes from Pi snapshot SavedClips" > "$OUTPUT_FILE"
echo "# Generated on $(date)" >> "$OUTPUT_FILE"
echo "# Event filter: $FILTER_DESC" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Process files in parallel for speed
if [ "$EVENT_FILTER" = "" ]; then
    # Process all files
    ssh teslausb "find $SNAPSHOT_PATH -type f \( -name '*.mp4' -o -name '*.json' \) | sort | xargs -P 4 -I {} sh -c 'echo \"Processing: {}\" >&2; sha1sum \"{}\"'"
else
    # Process specific event filter
    ssh teslausb "find $SNAPSHOT_PATH -path '*$EVENT_FILTER*' -type f \( -name '*.mp4' -o -name '*.json' \) | sort | xargs -P 4 -I {} sh -c 'echo \"Processing: {}\" >&2; sha1sum \"{}\"'"
fi | while read hash filepath; do
    # Extract just the filename from the full path
    filename=$(basename "$filepath")
    # Extract the event directory name
    eventdir=$(basename $(dirname "$filepath"))
    echo "$hash $eventdir/$filename"
done | sort -k2 >> "$OUTPUT_FILE"

echo "SHA1 hashes saved to: $OUTPUT_FILE"
echo "Total files processed: $(grep -v '^#' "$OUTPUT_FILE" | grep -v '^$' | wc -l)"