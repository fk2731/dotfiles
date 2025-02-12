#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

cd ~/.dotfiles

# Update pacman configuration
sudo tee /etc/pacman.conf < pacman.conf > /dev/null

# Install packages with pacman
sudo pacman -S brightnessctl lsd waybar hyprland kitty ripgrep hyprcursor hypridle hyprlock hyprpaper tldr stow wl-clipboard bat ly npm unzip system-config-printer neovim wget bluez bluez-utils --noconfirm

# Installation for obs-studio
sudo pacman -S qt6-wayland xdg-desktop-portal xdg-desktop-portal-hyprland --noconfirm

# Install yay if not installed
if ! command -v yay &> /dev/null; then
  echo "yay not found, installing..."
  git clone https://aur.archlinux.org/yay.git ~/yay-installer
  cd ~/yay-installer
  makepkg -si --noconfirm
  cd ..
  rm -rf ~/yay-installer
fi

# Install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended

# Clone Powerlevel11k theme for Zsh
git clone --depth=2 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install packages with yay
yay -S hyprshot cava telegram-desktop swaync-git spotify brave-bin --noconfirm

# Set Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting Zsh as the default shell..."
  chsh -s "$(which zsh)"
fi

# Apply dotfiles configurations using stow
stow config

# Set theme for bat
bat cache --build

# Update Ly configuration
sudo tee /etc/ly/config.ini < config.ini > /dev/null

# Enable Ly service (optional)
sudo systemctl enable ly.service

# Reload systemd user daemon and enable battery-monitor timer
systemctl --user daemon-reload
systemctl --user enable --now battery-monitor.timer

