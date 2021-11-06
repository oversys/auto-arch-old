#!/bin/bash

# Fix default user icon
sudo cp /usr/share/lightdm-webkit/themes/Aether/src/img/default-user.png /var/lib/AccountsService/icons/$USER
sudo sed -i "s/Icon=\/home\/$USER\/.face/Icon=\/var\/lib\/AccountsService\/icons\/$USER/g" /var/lib/AccountsService/users/$USER

echo -e "\e[92m\e[1mFixed default user icon.\e[m"

# Configure shell
printf "\nbind \\\t forward-word\ncat ~/.cache/wal/sequences &" >> $HOME/.config/fish/config.fish

# Download configuration files
git clone https://github.com/BetaLost/dotfiles.git

# Configure .bashrc
mv $HOME/dotfiles/.bashrc $HOME/

echo -e "\e[92m\e[1mConfigured bash.\e[m"

# Configure awesome window manager
mkdir $HOME/.config/
sudo mv $HOME/dotfiles/awesome $HOME/.config/
sudo chmod +x $HOME/.config/awesome/themes/powerarrow/s_wall.sh

echo -e "\e[92m\e[1mConfigured awesome window manager.\e[m"

# Configure rofi
sudo mv $HOME/dotfiles/rofi $HOME/.config/

echo -e "\e[92m\e[1mConfigured rofi.\e[m"

# Get brave
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin
makepkg -si --noconfirm
cd ../
rm -rf brave-bin

echo -e "\e[92m\e[1mInstalled brave browser.\e[m"

# Get picom
git clone https://aur.archlinux.org/picom-ibhagwan-git.git
cd picom-ibhagwan-git
makepkg -si --noconfirm
cd ../
rm -rf picom-ibhagwan-git
sudo mv $HOME/dotfiles/picom $HOME/.config/

echo -e "\e[92m\e[1mInstalled and configured picom compositor.\e[m"

# Configure alacritty
sudo mv $HOME/dotfiles/alacritty $HOME/.config/

echo -e "\e[92m\e[1mConfigured alacritty terminal.\e[m"

rm -rf $HOME/dotfiles

echo -e "\e[92m\e[1mConfigured desktop. Press Ctrl + Super + R to refresh.\e[m"

rm $0
