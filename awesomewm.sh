#!/bin/bash

# Install packages
pacman -Syu lightdm lightdm-gtk-greeter awesome xorg-server xterm gnome-terminal ttf-dejavu

# Get username
while IFS= read -r line
do
    USERNAME=$line
done < username.txt
rm username.txt

# Lightdm autologin
echo "autologin-user=$USERNAME" >> /etc/lightdm/lightdm.conf
echo "autologin-session=awesome" >> /etc/lightdm/lightdm.conf
groupadd -r autologin
gpasswd -a $USERNAME autologin
systemctl enable lightdm.service

# Apply Gnome Terminal edits
curl -L https://raw.githubusercontent.com/BetaLost/Arch-Install-Script/main/green_terminal.dconf > /home/$USERNAME/green_terminal.dconf
dconf load /org/gnome/terminal/legacy/profiles:/:ee86c6a3-d258-4f36-a467-8e029eba6c31/ < /home/$USERNAME/green_terminal.dconf

# Get default awesomewm config
CONF_DIR="/home/$USERNAME/.config/awesome"
mkdir -p $CONF_DIR
cp /etc/xdg/awesome/rc.lua $CONF_DIR
CONF_FILE=$CONF_DIR/rc.lua

# Edit configuration
sed -i "s/titlebars_enabled = true/titlebars_enabled = false/g" $CONF_FILE
sed -i "s/terminal = \"xterm\"/terminal = \"gnome-terminal\"/g" $CONF_FILE
sed -i "s/awful.key({ modkey,           }, \"w\", function () mymainmenu:show() end,/--awful.key({ modkey,           }, \"w\", function () mymainmenu:show() end,/g" $CONF_FILE
sed -i "s/{description = \"show main menu\", group = \"awesome\"}),/--{description = \"show main menu\", group = \"awesome\"}),/g" $CONF_FILE
