#!/bin/bash

# Install packages

# Update the database
pacman -Syu --noconfirm

# Display manager
pacman -S --noconfirm lightdm lightdm-gtk-greeter

# Window Manager
pacman -S --noconfirm awesome xorg-server ttf-dejavu

# Terminal
pacman -S --noconfirm alacritty ttf-fira-mono

# Retrieving tools
pacman -S --noconfirm wget git

# Wallpaper + Colorscheme
pacman -S --noconfirm feh imagemagick python-pywal

# Polybar + Polywins
pacman -S --noconfirm ttf-fira-sans network-manager-applet wmctrl xorg-xprop slop

echo -e "\e[92m\e[1mInstalled packages.\e[m"

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

rm username.txt $0
