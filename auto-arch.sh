#!/bin/bash

clear

echo -e "\e[32m\e[1mAuto-arch script started...\e[m"

# Set Font (bigger text)
setfont ter-v32n
echo -e "\e[32m\e[1mChanged Font.\e[m"

curl -Lo pre-chroot.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/pre-chroot.sh
bash pre-chroot.sh

arch-chroot /mnt "curl -Lo chroot.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/chroot.sh; bash chroot.sh"

USERNAME=$(cat /mnt/username.txt)
rm /mnt/username.txt
arch-chroot /mnt "curl -Lo post-install.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/post-install.sh; echo \"Running script as \"$USERNAME\"..\"; su -c \"zsh post-install.sh\" $USERNAME -"

echo -e "\e[32m\e[1mAuto-arch script completed!\e[m"
