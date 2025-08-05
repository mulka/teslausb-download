# TeslaUSB Download Project

## Project Overview
This project works with TeslaUSB dashcam footage stored on a Raspberry Pi device accessible via SSH.

## TeslaUSB Directory Structure
```
/mutable/TeslaCam/
├── RecentClips/        # Recent dashcam recordings
├── SavedClips/         # Manually saved clips
└── SentryClips/        # Security event recordings
```

## Tesla Dashcam File Format
Files follow this naming pattern: `YYYY-MM-DD_HH-MM-SS-{camera}.mp4`

Camera positions:
- `front` - Front-facing camera
- `back` - Rear-facing camera  
- `left_pillar` - Left pillar camera
- `right_pillar` - Right pillar camera
- `left_repeater` - Left side repeater camera
- `right_repeater` - Right side repeater camera

Each minute of recording creates 6 files (one per camera) with identical timestamps.

## SSH Access
- Host: `teslausb`
- Base path: `/mutable/TeslaCam/`

## Common Commands
```bash
# List recent recording dates
ssh teslausb ls /mutable/TeslaCam/RecentClips

# List files for a specific date
ssh teslausb ls /mutable/TeslaCam/RecentClips/YYYY-MM-DD

# List first 10 files from a date
ssh teslausb ls /mutable/TeslaCam/RecentClips/YYYY-MM-DD | head -10

# Check other clip types
ssh teslausb ls /mutable/TeslaCam/SavedClips
ssh teslausb ls /mutable/TeslaCam/SentryClips
```

## File Organization Notes
- RecentClips are organized by date folders (YYYY-MM-DD)
- Each timestamp represents a 1-minute recording session
- All 6 camera angles are recorded simultaneously

## TeslaUSB System Architecture
- **Live data**: Current recordings in `/mutable/TeslaCam/`
- **Backing files**: Raw data in `/backingfiles/cam_disk.bin` (100GB virtual drive)
- **Config files**: System configs in `/mutable/configs/` (including rclone.conf)

## Snapshot Management
- Snapshots are auto-mounted via autofs: `/tmp/snapshots/`
- Use `ls /tmp/snapshots/` to see available snapshots
- Latest snapshot typically has highest number (e.g., snap-003325)
- Snapshots contain complete TeslaCam directory structure

## File Download Patterns
- **Event files**: `event.mp4` (summary), `event.json` (metadata), `thumb.png`
- **Raw footage**: `YYYY-MM-DD_HH-MM-SS-{camera}.mp4` (6 cameras per minute)

## Advanced Commands
```bash
# Check available snapshots
ssh teslausb "ls /tmp/snapshots/"

# Find specific date events in snapshot
ssh teslausb "ls /tmp/snapshots/snap-XXXXXX/TeslaCam/SavedClips/ | grep YYYY-MM-DD"

# Download specific camera footage from snapshot
scp teslausb:/tmp/snapshots/snap-XXXXXX/TeslaCam/SavedClips/EVENT_DIR/FILE.mp4 ~/Movies/TeslaCam/DATE/
```

## Troubleshooting
- **SSH timeouts**: Pi may go offline - verify network connectivity
- **Permission errors**: Use `sudo` for rclone operations with system config
- **Missing event.mp4**: Some events only have raw footage, no summary file
