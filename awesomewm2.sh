#!/bin/bash

# Get awesomewm configuration
mkdir /home/$USER/.config/
mkdir /home/$USER/.config/awesome
sudo curl -L tinyurl.com/vjh-awesomewm-config > /home/$USER/.config/awesome/rc.lua

# Get wallpaper
wget -O /home/$USER/wallpaper.jpg https://github.com/BetaLost/Arch-Install-Script/blob/main/wallpaper.jpg?raw=true

# Get polybar
git clone https://aur.archlinux.org/polybar.git
cd polybar
makepkg -si
cd ../
rm -rf polybar
mkdir /home/$USER/.config/polybar
sudo curl -L tinyurl.com/vjh-polybar-config > /home/$USER/.config/polybar/config

# Get picom
git clone https://aur.archlinux.org/picom-ibhagwan-git.git
cd picom-ibhagwan-git
makepkg -si
cd ../
rm -rf picom-ibhagwan-git
mkdir /home/$USER/.config/picom
sudo cp /etc/xdg/picom.conf.example /home/$USER/.config/picom/picom.conf

# Get alacritty configuration
mkdir /home/$USER/.config/alacritty
curl -L tinyurl.com/vjh-alacritty > /home/$USER/.config/alacritty/alacritty.yml

printf "#!/bin/bash\nkillall -q polybar\nwhile pgrep -u $UID -x polybar >/dev/null; do sleep 1; done\npolybar default &" >> /home/$USER/.config/polybar/launch.sh
sudo chmod +x /home/$USER/.config/polybar/launch.sh
