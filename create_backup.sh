#!/bin/bash

# Prompt user to select a source directory
SOURCE=$(zenity --file-selection --directory --title="Select the source directory to back up")
if [ -z "$SOURCE" ]; then
    zenity --error --text="No source directory selected. Exiting."
    exit 1
fi

# Prompt user to select a destination folder
DEST=$(zenity --file-selection --directory --title="Select the destination folder")
if [ -z "$DEST" ]; then
    zenity --error --text="No destination folder selected. Exiting."
    exit 1
fi

# Create a timestamp for the backup filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$DEST/backup_$(basename "$SOURCE")_$TIMESTAMP.tar.gz"

# Create the tarball backup
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"
if [ $? -eq 0 ]; then
    zenity --info --text="Backup successful!\nSaved to: $BACKUP_FILE"
else
    zenity --error --text="Backup failed."
fi
