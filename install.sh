#!/bin/bash

set -e

echo "📦 Updating package list and upgrading existing packages..."
sudo apt update && sudo apt upgrade -y

echo "🔧 Installing required packages..."
sudo apt install -y \
  i3 \
  picom \
  rofi \
  nitrogen \
  xbacklight \
  lxappearance \
  pulseaudio-utils \
  brightnessctl \
  playerctl \
  thunar \
  blueman \
  i3blocks \
  maim \
  xclip \
  copyq \
  network-manager-gnome \

echo "📁 Copying configuration files to ~/.config..."

CONFIG_SOURCE_DIR="$(pwd)/configs"
CONFIG_TARGET_DIR="$HOME/.config"

mkdir -p "$CONFIG_TARGET_DIR"

for dir in "$CONFIG_SOURCE_DIR"/*; do
  if [ -d "$dir" ]; then
    dest="$CONFIG_TARGET_DIR/$(basename "$dir")"
    echo "🔄 Replacing $dest ..."
    rm -rf "$dest"
    cp -r "$dir" "$dest"
  fi
done

echo "🔒 Making all .sh files in ~/.config/i3 executable..."
find "$HOME/.config/i3" -type f -name "*.sh" -exec chmod +x {} \;

echo "🔤 Installing fonts..."
FONTS_DIR="$HOME/.fonts"
mkdir -p "$FONTS_DIR"
cp -v ./fonts/* "$FONTS_DIR/"
fc-cache -fv

echo "🖼️ Copying wallpapers to ~/Pictures/wallpapers..."
WALLPAPER_DEST="$HOME/Pictures/wallpapers"
mkdir -p "$WALLPAPER_DEST"
cp -r ./wallpapers/* "$WALLPAPER_DEST/"

echo "🧠 Updating GNOME Terminal configuration..."
DCONF_FILE="$(pwd)/dconf/gnome-terminal-config.dconf"
if [ -f "$DCONF_FILE" ]; then
  echo "📥 Loading GNOME Terminal settings from $DCONF_FILE"
  dconf load /org/gnome/terminal/ < "$DCONF_FILE"
else
  echo "⚠️ GNOME Terminal dconf backup not found: $DCONF_FILE"
fi

XPROFILE="$HOME/.xprofile"
mkdir -p "$(dirname "$XPROFILE")"

# Append only if it doesn't already exist
if ! grep -q 'export GTK_THEME=Adwaita:dark' "$XPROFILE" 2>/dev/null; then
  echo "" >> "$XPROFILE"
  echo 'if [[ "$XDG_CURRENT_DESKTOP" == "i3" ]]; then' >> "$XPROFILE"
  echo '  export GTK_THEME=Adwaita:dark' >> "$XPROFILE"
  echo 'fi' >> "$XPROFILE"
  echo "✅ Added GTK_THEME export to $XPROFILE"
fi

echo "✅ Installation complete!"
echo "🔁 Please **log out**, and on the login screen, select the **i3** session to start using it."
