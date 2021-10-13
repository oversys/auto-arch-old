#!/bin/bash

# Get awesomewm configuration
mkdir /home/$USER/.config/
mkdir /home/$USER/.config/awesome
sudo curl -L tinyurl.com/vjh-awesomewm-config > /home/$USER/.config/awesome/rc.lua

# Get wallpaper
wget -O /home/$USER/wallpaper.png https://github.com/BetaLost/Arch-Install-Script/blob/main/wallpaper.png?raw=true

# Terminal colorscheme
printf "\n(cat ~/.cache/wal/sequences &)" >> /home/$USER/.bashrc

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
mkdir /home/$USER/.config/polybar
sudo curl -L tinyurl.com/vjh-polybar-config > /home/$USER/.config/polybar/config

# Get polywins
git clone https://github.com/tam-carre/polywins.git
mkdir /home/$USER/.config/polybar/scripts
PW_FILE="/home/$USER/.config/polybar/scripts/polywins.sh"
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
mkdir /home/$USER/.config/picom
sudo cp /etc/xdg/picom.conf.example /home/$USER/.config/picom/picom.conf

# Get alacritty configuration
mkdir /home/$USER/.config/alacritty
curl -L tinyurl.com/vjh-alacritty > /home/$USER/.config/alacritty/alacritty.yml

printf '#!/bin/bash\nkillall -q polybar\nwhile pgrep -u '"$UID -x polybar >/dev/null; do sleep 1; done\npolybar default &" >> /home/$USER/.config/polybar/launch.sh
sudo chmod +x /home/$USER/.config/polybar/launch.sh
