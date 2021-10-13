#!/bin/bash

# Get awesomewm configuration
mkdir $HOME/.config/
mkdir $HOME/.config/awesome
sudo curl -L tinyurl.com/vjh-awesomewm-config > $HOME/.config/awesome/rc.lua

# Get wallpaper
wget -O $HOME/wallpaper.png https://github.com/BetaLost/Arch-Install-Script/blob/main/wallpaper.png?raw=true

# Terminal colorscheme
printf "\n(cat ~/.cache/wal/sequences &)" >> $HOME/.bashrc

# Get brave
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin
makepkg -si --noconfirm

# Get polybar
git clone https://aur.archlinux.org/polybar.git
cd polybar
makepkg -si --noconfirm
cd ../
rm -rf polybar
mkdir $HOME/.config/polybar
sudo curl -L tinyurl.com/vjh-polybar-config > $HOME/.config/polybar/config

# Get polywins
git clone https://github.com/tam-carre/polywins.git
mkdir $HOME/.config/polybar/scripts
PW_FILE="$HOME/.config/polybar/scripts/polywins.sh"
mv polywins/polywins.sh $PW_FILE
rm -rf polywins
sed -i "s/active_text_color=\"#250F0B\"/active_text_color=\"#FFFFFF\"/g" $PW_FILE
sed -i "s/inactive_text_color=\"#250F0B\"/inactive_text_color=\"#FFFFFF\"/g" $PW_FILE
sed -i "s/active_underline=\"#ECB3B2\"/active_underline=\"#D9C8A0\"/g" $PW_FILE

# Get picom
git clone https://aur.archlinux.org/picom-ibhagwan-git.git
cd picom-ibhagwan-git
makepkg -si --noconfirm
cd ../
rm -rf picom-ibhagwan-git
mkdir $HOME/.config/picom
sudo cp /etc/xdg/picom.conf.example $HOME/.config/picom/picom.conf

# Get alacritty configuration
mkdir $HOME/.config/alacritty
curl -L tinyurl.com/vjh-alacritty > $HOME/.config/alacritty/alacritty.yml

printf '#!/bin/bash\nkillall -q polybar\nwhile pgrep -u '"$UID -x polybar >/dev/null; do sleep 1; done\npolybar default &" >> $HOME/.config/polybar/launch.sh
sudo chmod +x $HOME/.config/polybar/launch.sh
