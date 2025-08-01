# TeslaUSB Download

A utility for downloading and managing Tesla dashcam footage from a TeslaUSB device.

## Overview

This project is designed to be used with Claude Code to help with downloading specific video files from a TeslaUSB device remotely via scp. Claude Code can help you navigate the directory structure, identify specific clips, and download the files you need.

## Prerequisites

- SSH access to your TeslaUSB device
- TeslaUSB device configured and accessible on your network
- SCP for file transfers

## Directory Structure & File Format

See [CLAUDE.md](CLAUDE.md) for detailed information about:
- TeslaUSB directory structure
- Tesla dashcam file naming conventions
- Camera positions and angles
- Common SSH commands for navigation

## Usage with Claude Code

You can ask Claude Code to help with various tasks:

- "Show me what dates have recordings available"
- "List the clips from yesterday morning"
- "Download all the front camera footage from 2025-07-31 between 8:50 and 9:00"
- "Find and download the sentry clips from last week"
- "Download just the back camera view of the incident at 2:30 PM on July 31st"
- "Show me the file sizes for today's recordings"
- "Download all 6 camera angles for the clip at 8:51 AM yesterday"

Claude Code will handle the SSH navigation, file identification, and SCP download commands automatically based on your requests.