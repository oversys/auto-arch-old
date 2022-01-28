#!/bin/bash

clear

echo -e "\e[32m\e[1mAuto-arch script started...\e[m"

# Set Font (bigger text)
setfont ter-v32n
echo -e "\e[32m\e[1mChanged Font.\e[m"

# User prompts

# Print partitions
echo -e "\e[32m\e[1mCurrent partitions:\e[m"
fdisk -l /dev/sda

# Boot Partition
echo -e "\e[32m\e[1mBoot Partition (sdaX):\e[m"
read BOOT_PART
if [[ $BOOT_PART  =~ "sda" ]]
then
    echo -e "\e[32m\e[1mValid boot partition.\e[m"
else
    echo -e "\e[31m\e[1mInvalid input.\e[m"
    exit
fi

# Root Partition
echo -e "\e[32m\e[1mRoot Partition (sdaX):\e[m"
read ROOT_PART
if [[ $ROOT_PART =~ "sda" ]]
then
    echo -e "\e[32m\e[1mValid root partition.\e[m"
else
    echo -e "\e[31m\e[1mInvalid input.\e[m"
    exit
fi

# Region
clear
echo -e "\e[32m\e[1mValid Regions:\e[m" 
for file in /usr/share/zoneinfo/*; do
    echo $file | awk '{print NR, $0}'
done
echo -e "\e[32m\e[1mRegion:\e[m"
read REGION

# City
clear
echo -e "\e[32m\e[1mValid Cities:\e[m" 
for file in /usr/share/zoneinfo/$REGION/*; do
    echo $file | awk '{print NR, $0}'
done
echo -e "\e[32m\e[1mCity:\e[m"
read CITY

# Hostname
echo -e "\e[32m\e[1mEnter hostname:\e[m"
read HOSTNAME

# Username
echo -e "\e[32m\e[1mEnter username:\e[m"
read USERNAME

# Root Password
echo -e "\e[32m\e[1mSet password for ROOT:\e[m"
read -s ROOT_PASSWORD

echo -e "\e[32m\e[1mConfirm password for ROOT:\e[m"
read -s CONFIRM_ROOT_PASSWORD

if [ $ROOT_PASSWORD != $CONFIRM_ROOT_PASSWORD ]; then
    echo -e "\e[31m\e[1mPasswords do not match.\e[m"
    exit
fi

# User Password
echo -e "\e[32m\e[1mSet password for \"$USERNAME\":\e[m"
read -s USER_PASSWORD

echo -e "\e[32m\e[1mConfirm password for \"$USERNAME\":\e[m"
read -s CONFIRM_USER_PASSWORD

if [ $USER_PASSWORD != $CONFIRM_USER_PASSWORD ]; then
    echo -e "\e[31m\e[1mPasswords do not match.\e[m"
    exit
fi

# Run the first script
curl -Lo pre-chroot.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/pre-chroot.sh
bash pre-chroot.sh $BOOT_PART $ROOT_PART

# Run the second script
arch-chroot /mnt /bin/bash -c "curl -Lo chroot.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/chroot.sh; bash chroot.sh $REGION $CITY $HOSTNAME $USERNAME $ROOT_PASSWORD $USER_PASSWORD $BOOT_PART"

# Run the third script
echo "Running script as \"$USERNAME\".."
arch-chroot /mnt /bin/bash -c "cd /home/$USERNAME; curl -Lo post-install.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/post-install.sh; su -c \"zsh post-install.sh\" $USERNAME -"

echo -e "\e[32m\e[1mAuto-arch script completed!\e[m"
