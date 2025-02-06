#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update pacman configuration
sudo tee /etc/pacman.conf < pacman.conf > /dev/null

# Install packages with pacman
sudo pacman -S --needed waybar hyprland kitty ripgrep hyprcursor hypridle hyprlock hyprpaper tldr stow wl-clipboard bat ly npm unzip system-config-printer neovim --noconfirm

# Installation for obs-studio
sudo pacman -S --needed qt5-wayland xdg-desktop-portal xdg-desktop-portal-hyprland --noconfirm

# Install yay if not installed
if ! command -v yay &> /dev/null; then
  echo "yay not found, installing..."
  git clone https://aur.archlinux.org/yay.git ~/yay-installer
  cd ~/yay-installer
  makepkg -si --noconfirm
  cd ..
  rm -rf ~/yay-installer
fi

# Clone Powerlevel10k theme for Zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Install packages with yay
yay -S --needed hyprshot cava telegram-desktop swaync-git spotify brave-bin zsh-autosuggestions zsh-syntax-highlighting --noconfirm

# Apply dotfiles configurations using stow
cd ~/.dotfiles && stow config

# Update Ly configuration
sudo tee /etc/ly/config.ini < config.ini > /dev/null

# Enable Ly service (optional)
sudo systemctl enable ly.service

# Reload systemd user daemon and enable battery-monitor timer
systemctl --user daemon-reload
systemctl --user enable --now battery-monitor.timer

