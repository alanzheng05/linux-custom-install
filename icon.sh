#!/bin/bash

# Prompt user to select the script to run
SCRIPT=$(zenity --file-selection --title="Select a script to run" --file-filter="*.sh")
if [ -z "$SCRIPT" ]; then
    zenity --error --text="No script selected. Exiting."
    exit 1
fi

# Prompt user to select an image for the icon
ICON=$(zenity --file-selection --title="Select an icon image" --file-filter="*.png *.jpg *.svg")
if [ -z "$ICON" ]; then
    zenity --error --text="No icon selected. Exiting."
    exit 1
fi

# Prompt user to enter a name for the desktop entry
NAME=$(zenity --entry --title="Enter desktop shortcut name" --text="Enter a name for your shortcut:")
if [ -z "$NAME" ]; then
    NAME="MyShortcut"
fi

# Define path for the .desktop file
DESKTOP_FILE="$HOME/Desktop/$NAME.desktop"

# Create the .desktop file
echo "[Desktop Entry]" > "$DESKTOP_FILE"
echo "Type=Application" >> "$DESKTOP_FILE"
echo "Name=$NAME" >> "$DESKTOP_FILE"
echo "Exec=bash \"$SCRIPT\"" >> "$DESKTOP_FILE"
echo "Icon=$ICON" >> "$DESKTOP_FILE"
echo "Terminal=true" >> "$DESKTOP_FILE"

# Make the .desktop file executable
chmod +x "$DESKTOP_FILE"

# Notify the user
zenity --info --text="Desktop icon '$NAME' has been created on your Desktop."
