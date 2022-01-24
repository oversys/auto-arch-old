#!/bin/bash

clear

echo "Auto-arch script started..."

# Set Font (bigger text)
setfont ter-v32n
echo -e "\e[32m\e[1mChanged Font.\e[m"

bash pre-chroot.sh
arch-chroot /mnt "bash chroot.sh"
USERNAME=$(cat /mnt/username.txt)
rm /mnt/username.txt
arch-chroot /mnt "su -c \"zsh post-install.sh\" $USERNAME -"

echo "Done!"
