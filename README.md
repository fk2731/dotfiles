```bash
    sudo pacman -S --needed base-devel git
    git clone https://github.com/fk2731/dotfiles.git
    ~/.dotfiles/setup.sh
```

you need to install jdk manually, go [jdk](https://www.oracle.com/mx/java/technologies/downloads/) on Downloads (preffered) and run

```bash
    tar -xvzf ~/Downloads/jdk-17.0.14_linux-x64_bin.tar.gz -C /opt
```

To install p10k `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k`
`git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions`
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting`

clipboard for neovim `sudo pacman -S wl-clipboard`

live-grep `sudo pacman -S ripgrep`

insatll npm (to install prettier on nvim) and unzip (for stylua)

Open neovim -> `:Mason` -> press 1 -> search for 'lua-language-server' and install it

Open neovim -> `:Mason` -> press 5 -> search for 'prettier' and install it

Open neovim -> `:Mason` -> press 5 -> search for 'stylua' and install it

Open neovim -> `:Mason` -> press 5 -> search for 'black' and install it (for python)

`sudo pacman -S ttf-font-awesome` for waybar fonts

### bluetooth

Install `sudo pacman -S bluez bluez-utils`
`sudo systemctl start bluetooth`
`sudo systemctl enable bluetooth`
Do `bluetoothctl` and then this secuence

- `power on`
- `agent on`
- `default-agent`
- Identify your device

### Wifi

- `nmcli d wifi`
- identify your network
- `nmcli d wifi conection <name_of_your_network> password <your_password>`
