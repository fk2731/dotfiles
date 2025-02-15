#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

cd ~/.dotfiles

# Update pacman configuration
sudo tee /etc/pacman.conf < pacman.conf > /dev/null

# Update cursor configuration
sudo tee /usr/share/icons/default/index.theme < ./login/index.theme > /dev/null

# Install packages with pacman
sudo pacman -S brightnessctl lsd waybar hyprland kitty ripgrep hyprcursor hypridle hyprlock hyprpaper tldr stow wl-clipboard bat sddm npm unzip system-config-printer neovim wget bluez bluez-utils refind plymouth --noconfirm

# Dependencies for sddm
sudo pacman -Syu qt6-svg qt6-declarative qt5-quickcontrols2

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
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  export RUNZSH=no
  export CHSH=yes
  sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
else
  echo "Oh My Zsh is already installing"
fi

# Change shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting Zsh as the default shell..."
  sudo chsh -s "$(which zsh)" "$USER"
else
  echo "Already using zsh"
fi

# Setup for prompt and plugins
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  git clone --depth=2 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k || echo "Powerlevel10k ya existe"
else
  echo "Powerlevel10k is already installed"
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions || echo "zsh-autosuggestions ya existe"
else
  echo "zsh-autosuggestions is already installed"
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || echo "zsh-syntax-highlighting ya existe"
else
  echo "zsh-syntax-highlighting is already installed"
fi

# Install packages with yay
yay -S hyprshot cava telegram-desktop swaync-git spotify brave-bin --noconfirm

# Apply dotfiles configurations using stow
stow config --adopt

# Set theme for bat
bat cache --build

#Setup SDDM
sudo cp -rf ./login/catppuccin-mocha/ /usr/share/sddm/themes/
sudp cp -r ./login/sddm.conf /etc/sddm.conf

# Setup rEFInd
sudo cp -f ./boot/refind.conf /boot/EFI/refind/refind.conf
sudo mkdir /boot/EFI/refind/themes/ 
sudo cp -r ./boot/catppuccin/ /boot/EFI/refind/themes/

# Reload systemd user daemon and enable battery-monitor timer
systemctl --user daemon-reload
systemctl --user enable --now battery-monitor.timer

# Enabling services for sddm
sudo systemctl restart display-manager
sudo systemctl enable sddm.service --force

# Plymouth config
sudo cp -r ./boot/plymouth/catppuccin-mocha/ /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R catppuccin-mocha
sudo cp -f ./boot/plymouth/plymouthd.conf /etc/plymouth/plymouthd.conf
sudo systemctl enable plymouth-start.service
sudo systemctl start plymouth-start.service

sudo mkinitcpio -P
