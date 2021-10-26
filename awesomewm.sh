#!/bin/bash

# Install packages

# Update the database
pacman -Syu --noconfirm

# Display manager
pacman -S --noconfirm lightdm lightdm-webkit2-greeter

# Window Manager
pacman -S --noconfirm awesome xorg-server ttf-dejavu ttf-fira-sans dmenu light network-manager-applet

# Terminal
pacman -S --noconfirm alacritty ttf-fira-mono

# Retrieving tools
pacman -S --noconfirm wget git

# Audio tools
pacman -S --noconfirm pulseaudio pavucontrol alsa-utils

# Bluetooth
pacman -S --noconfirm bluez bluez-utils pulseaudio-bluetooth
systemctl enable bluetooth.service

# Wallpaper + Colorscheme
pacman -S --noconfirm feh imagemagick python-pywal jq

# Polywins (Polybar script)
# pacman -S --noconfirm wmctrl xorg-xprop slop

# Cursor
pacman -S --noconfirm libx11 libxcursor libpng

# GPU Drivers
pacman -S --noconfirm mesa mesa-demos lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader xf86-video-amdgpu

echo -e "\e[92m\e[1mInstalled packages.\e[m"

# Get username
while IFS= read -r line
do
    USERNAME=$line
done < username.txt

# Lightdm

chmod a+rw /sys/class/backlight/intel_backlight/brightness

# Get Aether theme
git clone https://github.com/NoiSek/Aether.git
cp --recursive Aether /usr/share/lightdm-webkit/themes/
rm -rf Aether
sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = lightdm-webkit-theme-aether #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
ln -s /usr/share/lightdm-webkit/themes/Aether /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether
sed -i "s/# greeter-session = Session to load for greeter/greeter-session = lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sed -i "s/# user-session = Session to load for users/user-session = awesome/g" /etc/lightdm/lightdm.conf
sed -i "s/#user-session=default/user-session=awesome/g" /etc/lightdm/lightdm.conf
systemctl enable lightdm.service

echo -e "\e[92m\e[1mEnabled display manager.\e[m"

# Install cursor
wget https://github.com/BetaLost/Arch-Install-Script/raw/main/macOSBigSur.tar.gz
tar -xf macOSBigSur.tar.gz
mv macOSBigSur /usr/share/icons/
rm -rf macOSBigSur.tar.gz

sudo sed -i "s/Inherits=Adwaita/Inherits=macOSBigSur/g" /usr/share/icons/default/index.theme

echo -e "\e[92m\e[1mInstalled cursor theme.\e[m"

rm username.txt $0
