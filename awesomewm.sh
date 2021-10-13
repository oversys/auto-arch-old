#!/bin/bash

# Install packages
pacman -Syu --noconfirm lightdm lightdm-gtk-greeter awesome xorg-server alacritty wget git ttf-dejavu ttf-fira-sans ttf-fira-mono network-manager-applet feh imagemagick python-pywal
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
