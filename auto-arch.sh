#!/bin/bash

clear

echo -e "\e[32m\e[1mAuto-arch script started...\e[m"

# Set Font (bigger text)
setfont ter-v32n
echo -e "\e[32m\e[1mChanged Font.\e[m"

curl -Lo pre-chroot.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/pre-chroot.sh
bash pre-chroot.sh

arch-chroot /mnt /bin/bash -c "curl -Lo chroot.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/chroot.sh; bash chroot.sh"

USERNAME=$(cat /mnt/username.txt)
rm /mnt/username.txt
echo "Running script as \"$USERNAME\".."
arch-chroot /mnt /bin/bash -c "cd /home/$USERNAME; curl -Lo post-install.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/post-install.sh; su -c \"zsh post-install.sh\" $USERNAME -"

echo -e "\e[32m\e[1mAuto-arch script completed!\e[m"
