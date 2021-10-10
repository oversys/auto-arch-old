#!/bin/bash

# Install packages
pacman -Syu --noconfirm lightdm lightdm-gtk-greeter awesome xorg-server xterm wget git ttf-dejavu ttf-fira-sans network-manager-applet
echo -e "\e[92m\e[1mInstalled window manager packages.\e[m"

# Get username
while IFS= read -r line
do
    USERNAME=$line
done < username.txt

# Lightdm autologin
echo "autologin-user=$USERNAME" >> /etc/lightdm/lightdm.conf
echo "autologin-session=awesome" >> /etc/lightdm/lightdm.conf
groupadd -r autologin
gpasswd -a $USERNAME autologin
systemctl enable lightdm.service
echo -e "\e[92m\e[1mEnabled display manager.\e[m"

# Get awesomewm configuration
mkdir /home/$USERNAME/.config/awesome
curl -L tinyurl.com/vjh-awesomewm-config > /home/$USERNAME/.config/awesome/rc.lua
CONF_FILE="/home/$USERNAME/.config/awesome/rc.lua"

# Get wallpaper
wget -O /home/$USERNAME/wallpaper.jpg https://github.com/BetaLost/Arch-Install-Script/blob/main/wallpaper.jpg?raw=true

# Get polybar
git clone https://aur.archlinux.org/polybar.git
cd polybar
makepkg -si
cd ../
rm -rf polybar
mkdir /home/$USERNAME/.config/polybar
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

echo -e "\e[92m\e[1mConfigured awesomewm.\e[m"
rm username.txt $0
