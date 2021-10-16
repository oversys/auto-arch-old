#!/bin/bash

# Fix default user icon
sudo cp /usr/share/lightdm-webkit/themes/Aether/src/img/default-user.png /var/lib/AccountsService/icons/$USER.png
sudo sed -i "s/Icon=\/home\/$USER\/.face/\/var\/lib\/AccountsService\/icons\/$USER.png/g" /var/lib/AccountsService/users/$USER

echo -e "\e[92m\e[1mFixed default user icon.\e[m"

# Configure .bashrc
curl -L tinyurl.com/vjh-bashrc > $HOME/.bashrc

# Get awesomewm configuration
mkdir $HOME/.config/
mkdir $HOME/.config/awesome
sudo curl -L tinyurl.com/vjh-awesomewm-config > $HOME/.config/awesome/rc.lua

echo -e "\e[92m\e[1mConfigured awesome window manager.\e[m"

# Get wallpaper
wget -O $HOME/wallpaper.png https://github.com/BetaLost/Arch-Install-Script/blob/main/wallpaper.png?raw=true

echo -e "\e[92m\e[1mDownloaded wallpaper..\e[m"

# Terminal colorscheme
wal -i $HOME/wallpaper.png
printf "\n(cat ~/.cache/wal/sequences &)" >> $HOME/.bashrc

echo -e "\e[92m\e[1mSet terminal colorscheme.\e[m"

# Get brave
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin
makepkg -si --noconfirm

echo -e "\e[92m\e[1mDownloaded brave browser.\e[m"

# Get polybar
git clone https://aur.archlinux.org/polybar.git
cd polybar
makepkg -si --noconfirm
cd ../
rm -rf polybar
mkdir $HOME/.config/polybar
sudo curl -L tinyurl.com/vjh-polybar-config > $HOME/.config/polybar/config

echo -e "\e[92m\e[1mDownloaded and configured polybar.\e[m"

# Get polywins
git clone https://github.com/tam-carre/polywins.git
mkdir $HOME/.config/polybar/scripts
PW_FILE="$HOME/.config/polybar/scripts/polywins.sh"
mv polywins/polywins.sh $PW_FILE
rm -rf polywins
sed -i "s/active_text_color=\"#250F0B\"/active_text_color=\"#FFFFFF\"/g" $PW_FILE
sed -i "s/inactive_text_color=\"#250F0B\"/inactive_text_color=\"#FFFFFF\"/g" $PW_FILE
sed -i "s/active_underline=\"#ECB3B2\"/active_underline=\"#D9C8A0\"/g" $PW_FILE

echo -e "\e[92m\e[1mDownloaded and configured polywins.\e[m"

# Get picom
git clone https://aur.archlinux.org/picom-ibhagwan-git.git
cd picom-ibhagwan-git
makepkg -si --noconfirm
cd ../
rm -rf picom-ibhagwan-git
mkdir $HOME/.config/picom
curl -L tinyurl.com/vjh-picom > $HOME/.config/picom/picom.conf

echo -e "\e[92m\e[1mDownloaded picom compositor.\e[m"

# Get alacritty configuration
mkdir $HOME/.config/alacritty
curl -L tinyurl.com/vjh-alacritty > $HOME/.config/alacritty/alacritty.yml

echo -e "\e[92m\e[1mConfigured alacritty terminal.\e[m"

printf '#!/bin/bash\nkillall -q polybar\nwhile pgrep -u '"$UID -x polybar >/dev/null; do sleep 1; done\npolybar default &" >> $HOME/.config/polybar/launch.sh
sudo chmod +x $HOME/.config/polybar/launch.sh

echo -e "\e[92m\e[1mCreated polybar launch script.\e[m"

echo -e "\e[92m\e[1mConfigured desktop. Press Ctrl + Super + R to refresh.\e[m"

rm $0
