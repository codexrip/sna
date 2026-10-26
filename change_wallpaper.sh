#!/bin/bash

# Configuration
IMAGE_URL="https://wallpaperaccess.com/full/8926441.jpg" # Replace with your online image link
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

# Apply wallpaper based on the desktop environment
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] || [[ "$DESKTOP_SESSION" == *"gnome"* ]]; then
    gsettings set org.gnome.desktop.background picture-uri "file://$SAVE_PATH"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$SAVE_PATH"
elif [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then
    # KDE Plasma script approach
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript \
    "var allDesktops = desktops();for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = 'org.kde.image';d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];d.writeConfig('Image', 'file://$SAVE_PATH');}"
elif [[ "$XDG_CURRENT_DESKTOP" == *"XFCE"* ]]; then
    # XFCE
    property=$(xfconf-query -c xfce4-desktop -p /backdrop -l | grep last-image | head -n 1)
    if [ -n "$property" ]; then
        xfconf-query -c xfce4-desktop -p "$property" -s "$SAVE_PATH"
    fi
else
    echo "Unsupported desktop environment: $XDG_CURRENT_DESKTOP"
    exit 1
fi

echo "Wallpaper updated successfully!"
