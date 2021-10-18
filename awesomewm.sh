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

# Audio tools
pacman -S --noconfirm pulseaudio pavucontrol alsa-utils

# Wallpaper + Colorscheme
pacman -S --noconfirm feh imagemagick python-pywal

# Polybar + Polywins
pacman -S --noconfirm ttf-fira-sans network-manager-applet wmctrl xorg-xprop slop

# Cursor
pacman -S --noconfirm libx11 libxcursor libpng

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
sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = lightdm-webkit-theme-aether #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
ln -s /usr/share/lightdm-webkit/themes/Aether /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether
sed -i "s/# greeter-session = Session to load for greeter/greeter-session = lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sed -i "s/# user-session = Session to load for users/user-session = awesome/g" /etc/lightdm/lightdm.conf
sed -i "s/#user-session=default/user-session=awesome/g" /etc/lightdm/lightdm.conf
systemctl enable lightdm.service

echo -e "\e[92m\e[1mEnabled display manager.\e[m"

# Install cursor
wget https://dl1.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MzQyMTU4NDkiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjA4Y2I3NWYxNmIwOWU5OGJmYmI4NWQxYjNkMzE4ZDNjNTc2MGU0MGQ5YmJhYjU5NzA4Y2Q0ZmQ5MDc4YzEyOTk0MTc3MTU4YWU2MjY1NDkzOWUyMWY0NGIzY2NlNDk4ZDdiNGY5NjdiZjQ2ZDZiZDA0ODY3ZDVhYTg3ZjhhY2Q4IiwidCI6MTYzNDU0NDEzNiwic3RmcCI6ImY3NTBhOTM0YTU3MzkxOTFjNWY3ZmRhZjg0NWJkZTFkIiwic3RpcCI6IjE4OC40OS42LjI0NSJ9.c5tSDwfq_pHnyOBMovd8_oWgQf8yNqTm9Igy3Egik_k/macOSBigSur.tar.gz
tar -xvf macOSBigSur.tar.gz
mv macOSBigSur /usr/share/icons/

rm username.txt $0
