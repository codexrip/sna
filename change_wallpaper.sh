#!/bin/bash

# Force export user environment variables in case they are missing during automation
export HOME="${HOME:-/home/muhammad}"
export DISPLAY="${DISPLAY:-:0}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# Configuration
IMAGE_URL="https://wallpaperaccess.com/full/9379877.jpg"
SAVE_PATH="$HOME/Pictures/daily_wallpaper.jpg"

# Create Pictures directory if it doesn't exist
mkdir -p "$(dirname "$SAVE_PATH")"

# Download the image
echo "Downloading new wallpaper..."
curl -s -L "$IMAGE_URL" -o "$SAVE_PATH"

# Check if download succeeded
if [ ! -f "$SAVE_PATH" ]; then
    echo "Error: Failed to download wallpaper."
    exit 1
fi

# Apply wallpaper for GNOME / Ubuntu desktops
# (Using DBUS session address to ensure it applies to the active graphical session)
if [ -n "$XDG_RUNTIME_DIR" ] && [ -S "$XDG_RUNTIME_DIR/bus" ]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
fi

gsettings set org.gnome.desktop.background picture-uri "file://$SAVE_PATH"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$SAVE_PATH"

echo "Wallpaper updated successfully!"
