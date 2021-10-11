#!/bin/bash

# Install packages
pacman -Syu --noconfirm lightdm lightdm-gtk-greeter awesome xorg-server alacritty wget git ttf-dejavu ttf-fira-sans ttf-fira-mono network-manager-applet feh powerline-fonts
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

# Better terminal
mkdir /home/$USERNAME/.config/
git clone --recursive https://github.com/andresgongora/synth-shell.git
chmod +x synth-shell/setup.sh
synth-shell/setup.sh
curl -L tinyurl.com/vjh-synth-shell > /home/$USERNAME/.config/synth-shell/synth-shell-prompt.config

# Get alacritty configuration
mkdir /home/$USERNAME/.config/alacritty
curl -L tinyurl.com/vjh-alacritty > /home/$USERNAME/.config/alacritty/alacritty.yml

rm username.txt $0
