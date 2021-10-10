#!/bin/bash

# Get awesomewm configuration
mkdir .config
mkdir /home/$USER/.config/awesome
curl -L tinyurl.com/vjh-awesomewm-config > /home/$USER/.config/awesome/rc.lua

# Get wallpaper
wget -O /home/$USER/wallpaper.jpg https://github.com/BetaLost/Arch-Install-Script/blob/main/wallpaper.jpg?raw=true

# Get polybar
git clone https://aur.archlinux.org/polybar.git
cd polybar
makepkg -si
cd ../
rm -rf polybar
mkdir /home/$USER/.config/polybar
curl -L tinyurl.com/vjh-polybar-config > /home/$USERNAME/.config/polybar/config

# Get picom
git clone https://aur.archlinux.org/picom-ibhagwan-git.git
cd picom-ibhagwan-git
makepkg -si
cd ../
rm -rf picom-ibhagwan-git
mkdir /home/$USERNAME/.config/picom
cp /etc/xdg/picom.conf.example /home/$USERNAME/.config/picom/picom.conf

printf "#!/bin/bash\nkillall -q polybar\nwhile pgrep -u $UID -x polybar >/dev/null; do sleep 1; done\npolybar default &" >> /home/$USERNAME/.config/polybar/launch.sh
chmod +x /home/$USERNAME/.config/polybar/launch.sh
