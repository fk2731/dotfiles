#! /usr/share/icons/default/index.theme/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

cd ~/.dotfiles || exit

# Definir colores con negrita
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
BLUE="\e[1;34m"
RESET="\e[0m"

# Funciones para mensajes con colores
info() { echo -e "${BLUE}[INFO] $1${RESET}"; }
success() { echo -e "${GREEN}[OK] $1${RESET}"; }
warning() { echo -e "${YELLOW}[WARNING] $1${RESET}"; }
error() { echo -e "${RED}[ERROR] $1${RESET}"; }

# --------------------------
# 1. Update System and installing basic utilities
# --------------------------
update_system() {
  info "Update system and installing basic utilities"
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed base-devel git --noconfirm
}


# --------------------------
# 2. Esential configuration (Pacman, sudo, cursor)
# --------------------------
configure_essentials() {

  # Update pacman configuration
  sudo tee /etc/pacman.conf < pacman.conf > /dev/null

  # Append Defaults pwfeedback onto /etc/sudoers
  echo "Defaults pwfeedback,insults" | sudo EDITOR='tee -a' visudo
}

# --------------------------
# 3. Installing packages with pacman
# --------------------------
install_pacman_packages() {
  sudo pacman -S --needed efibootmgr dosfstools mtools brightnessctl zsh lsd waybar hyprland kitty ripgrep \
  hyprcursor hypridle hyprlock hyprpaper tldr stow wl-clipboard bat sddm \
  npm unzip system-config-printer neovim wget bluez bluez-utils refind \
  plymouth sed --noconfirm

  if pacman -Qe grub &> /dev/null; then
    sudo pacman -Rns grub --noconfirm
  fi

  # Yazi Installation & SDDM
  sudo pacman -S --needed qt6-svg qt6-declarative qt5-quickcontrols2 --noconfirm

  # Installation for obs-studio
  sudo pacman -S --needed qt6-wayland xdg-desktop-portal xdg-desktop-portal-hyprland --noconfirm
}

# --------------------------
# 4. Yay installation (AUR Helper)
# --------------------------
install_yay() {
  if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd ~/yay || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf ~/yay
  else
    success "Yay is already installed"
  fi
}

# --------------------------
# 5. Installing packages with yay
# --------------------------
install_yay_packages() {
  yay -S --needed ttf-jetbrains-mono-nerd hyprshot cava telegram-desktop swaync-git brave-bin rose-pine-cursor rose-pine-hyprcursor --noconfirm
}

# --------------------------
# 6. Configuring Zsh and plugins
# --------------------------
setup_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    export RUNZSH=no
    export CHSH=yes
    sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    sudo chsh -s "$(which zsh)"
  else
    success "Oh My Zsh is already installed"
  fi

  if [ "$SHELL" != "$(which zsh)" ]; then
    info "Changing default shell to Zsh..."
    sudo chsh -s "$(which zsh)"
    info "Close the terminal and open it again"
  else
    success "✅ Zsh is already the default shell"
  fi

  info "Installing Powerlevel10k, zsh-autosuggestions, and zsh-syntax-highlighting..."
  if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    git clone --depth=2 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  fi
}

# --------------------------
# 7. Apllying dotfiles with stow
# --------------------------
apply_dotfiles() {
  info "Applying dotfiles with stow..."
  stow --adopt --target="$HOME" config
  bat cache --build
}

# --------------------------
# 8. Configurations for SDDM
# --------------------------
configure_sddm() {
  info "Configuring SDDM..."

  sudo cp -r ./login/catppuccin-mocha/ /usr/share/sddm/themes/
  sudo cp -f ./login/sddm.conf /etc/sddm.conf

  sudo systemctl enable sddm.service --force
}

# --------------------------
# 9. Configurations for rEFInd
# --------------------------
configure_refind() {
  info "Configuring rEFInd..."
  sudo refind-install

  sudo mkdir /boot/EFI/refind/themes/
  sudo cp ./boot/os_arch.png /boot/vmlinuz-linux.png

  sudo cp -f ./boot/refind.conf /boot/EFI/refind/refind.conf
  sudo cp -r ./boot/catppuccin/ /boot/EFI/refind/themes/
}

# --------------------------
# 10. Configurations for Plymouth
# --------------------------
configure_plymouth() {
  info "Configurations Plymouth..."

  sudo mkdir /usr/share/plymouth/themes/
  sudo mkdir /etc/plymouth/

  sudo cp -r ./boot/plymouth/catppuccin-mocha/ /usr/share/plymouth/themes/

  sudo cp -f ./boot/plymouth/plymouthd.conf /etc/plymouth/plymouthd.conf

  sudo plymouth-set-default-theme -R catppuccin-mocha

  sudo sed -i 's/^\(HOOKS=.*\)udev/\1udev plymouth/' /etc/mkinitcpio.conf

  sudo systemctl enable plymouth-start.service
  sudo systemctl start plymouth-start.service

  sudo mkinitcpio -P
}

# --------------------------
# 11. Services & Systemd
# --------------------------
enable_services() {
  info "Enabling services..."
  systemctl --user daemon-reload
  systemctl --user enable --now battery-monitor.timer
}

# --------------------------
# Installation process
# --------------------------
update_system
configure_essentials
install_pacman_packages
install_yay
install_yay_packages
setup_zsh
apply_dotfiles
configure_sddm
configure_refind
configure_plymouth
enable_services

# Update cursor configuration
sudo cp -f ./login/index.theme /usr/share/icons/default/index.theme

sudo systemctl enable bluetooth.service

sudo systemctl start sddm.service
