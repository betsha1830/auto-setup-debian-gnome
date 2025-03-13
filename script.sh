#!/bin/bash

# Check for sudo privileges upfront
sudo -v || { echo "Error: You need sudo privileges to run this script."; exit 1; }

# Update repo and install VLC, Wireguard, Qbittorrent, shell auto complete, auto time update, Flatpak
sudo sh -c '
apt update
apt upgrade -y

# Install dependencies that are required by other apps
apt install wget

# Add Lutris repo
echo "deb [signed-by=/etc/apt/keyrings/lutris.gpg] https://download.opensuse.org/repositories/home:/strycore/Debian_12/ ./" | tee /etc/apt/sources.list.d/lutris.list > /dev/null
wget -q -O- https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key | gpg --dearmor | tee /etc/apt/keyrings/lutris.gpg > /dev/null

# Add 32bit support 
dpkg --add-architecture i386
apt update
apt upgrade -y

# Install Flatpak, VLC, Wireguard, Qbittorrent, Lutris, Wine
apt install -y flatpak gnome-software-plugin-flatpak vlc resolvconf wireguard ntp bash-completion qbittorrent lutris wine64 wine32 libasound2-plugins:i386 libsdl2-2.0-0:i386 libdbus-1-3:i386 libsqlite3-0:i386

# Add Flathub repo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Using Flatpak install Discord, Spotify, Telegram, GIMP, VSCodium, Obsidian, OBS, Steam, RetroArch

flatpak install org.telegram.desktop com.spotify.Client com.discordapp.Discord org.gimp.GIMP com.vscodium.codium md.obsidian.Obsidian com.obsproject.Studio org.libretro.RetroArch -y

# Check if Docker is installed
if [ "$whereis -b docker" ]; then
	echo "Docker is already installed"
else

# Install curl and certificate
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings

# Fetch Docker key 
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to APT sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

docker run hello-world
fi
'
