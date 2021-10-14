#!/bin/bash

# Install packages

# Update the database
pacman -Syu --noconfirm

# Display manager
pacman -S --noconfirm lightdm lightdm-webkit2-greeter

# Window Manager
pacman -S --noconfirm awesome xorg-server ttf-dejavu dmenu light

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

# Get Aether theme
git clone https://github.com/NoiSek/Aether.git
cp --recursive Aether /usr/share/lightdm-webkit/themes/
sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = lightdm-webkit-theme-aether #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
ln -s /usr/share/lightdm-webkit/themes/Aether /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether
sed -i "s/# greeter-session = Session to load for greeter/greeter-session = lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sed -i "s/# user-session = Session to load for users/user-session = awesome/g" /etc/lightdm/lightdm.conf
sed -i "s/#user-session=default/user-session=awesome/g" /etc/lightdm/lightdm.conf
systemctl enable lightdm.service

echo -e "\e[92m\e[1mEnabled display manager.\e[m"

rm username.txt $0
