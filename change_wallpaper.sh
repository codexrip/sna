#!/bin/bash

# Configuration
SAVE_DIR="$HOME/Pictures/Brutalist_Wallpapers"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SAVE_PATH="$SAVE_DIR/brutalist_$TIMESTAMP.jpg"

# Option A: Curated list of high-res brutalist architecture image URLs
# (You can add as many direct image links here as you want)
URLS=(
    "https://wallpaperaccess.com/full/8926423.jpg" # Example concrete/brutalist style
    "https://wallpaperaccess.com/full/8926401.jpg"
    "https://wallpaperaccess.com/full/8926425.jpg"
    "https://wallpaperaccess.com/full/8926441.jpg"
    "https://wallpaperaccess.com/full/9379877.jpg"
    "https://wallpaperaccess.com/full/8926450.jpg"
    "https://wallpaperaccess.com/full/4705942.jpg"
    "https://wallpaperaccess.com/full/8926501.jpg"
    "https://wallpapercat.com/w/full/4/8/1/295349-3554x1960-desktop-hd-moscow-wallpaper.jpg"
    "https://wallpapercat.com/w/full/5/7/d/295524-2048x1172-desktop-hd-moscow-background.jpg"
    "https://wallpapercat.com/w/full/c/d/c/295459-2048x1365-desktop-hd-moscow-background.jpg"
    "https://wallpapercat.com/w/full/d/8/b/295451-1920x1200-desktop-hd-moscow-wallpaper-photo.jpg"
    "https://wallpapercat.com/w/full/a/b/1/295429-2048x1365-desktop-hd-moscow-background-photo.jpg"
    "https://wallpapercat.com/w/full/c/6/3/295466-2560x1600-desktop-hd-moscow-wallpaper.jpg"
    "https://wallpapercat.com/w/full/3/3/0/295478-2560x1600-desktop-hd-moscow-wallpaper-image.jpg"
    "https://wallpapercat.com/w/full/0/c/1/295426-3840x2160-desktop-4k-moscow-wallpaper-photo.jpg"
    "https://wallpapercat.com/w/full/2/0/b/295475-2522x1599-desktop-hd-moscow-background-photo.jpg"
    "https://wallpapercat.com/w/full/2/f/e/295440-3000x1995-desktop-hd-moscow-background-photo.jpg"
    "https://wallpapercat.com/w/full/4/e/4/295406-3840x2160-desktop-4k-moscow-wallpaper-image.jpg"
    "https://wallpapercat.com/w/full/4/0/2/295419-3000x1900-desktop-hd-moscow-background.jpg"
    # Add more direct high-res links to brutalist buildings here
)

# Pick a random URL from the array
RANDOM_URL="${URLS[$RANDOM % ${#URLS[@]}]}"

echo "Fetching a brutalist architecture wallpaper..."
curl -s -L "$RANDOM_URL" -o "$SAVE_PATH"

# Verify download and minimum file size (to ensure it's a valid image, e.g., > 50KB)
if [ -f "$SAVE_PATH" ] && [ $(stat -c%s "$SAVE_PATH") -gt 50000 ]; then
    echo "Wallpaper saved to $SAVE_PATH"
    
    # Apply wallpaper for GNOME / Ubuntu
    export DISPLAY="${DISPLAY:-:0}"
    export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    
    if [ -n "$XDG_RUNTIME_DIR" ] && [ -S "$XDG_RUNTIME_DIR/bus" ]; then
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
    fi

    gsettings set org.gnome.desktop.background picture-uri "file://$SAVE_PATH"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$SAVE_PATH"
    
    echo "Brutalist wallpaper applied successfully!"
else
    echo "Error: Download failed or file too small."
    rm -f "$SAVE_PATH"
    exit 1
fi
