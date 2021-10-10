#!/bin/bash

clear

# Set Font (bigger text)
setfont ter-v32n
echo -e "\e[92m\e[1mChanged Font.\e[m"

# Update the System Clock
timedatectl set-ntp true
echo -e "\e[92m\e[1mUpdated the System Clock.\e[m"

# Get Boot Partition
echo -e "\e[92m\e[1mBoot Partition (sdaX):\e[m"
read BOOT_PART
if [[ $BOOT_PART  =~ "sda" ]]
then
    echo -e "\e[92m\e[1mValid boot partition.\e[m"
    echo $BOOT_PART > boot_part.txt
else
    echo -e "\e[91m\e[1mInvalid input.\e[m"
    exit
fi

# Get Root Partition
echo -e "\e[92m\e[1mRoot Partition (sdaX):\e[m"
read ROOT_PART
if [[ $ROOT_PART =~ "sda" ]]
then
    echo -e "\e[92m\e[1mValid root partition.\e[m"
else
    echo -e "\e[91m\e[1mInvalid input.\e[m"
    exit
fi

# Format Partitions
mkfs.fat -F32 /dev/$BOOT_PART
echo -e "\e[92m\e[1mFormatted Boot Partition.\e[m"
mkfs.ext4 /dev/$ROOT_PART
echo -e "\e[92m\e[1mFormatted Root Partition.\e[m"
mount /dev/$ROOT_PART /mnt
echo -e "\e[92m\e[1mMounted \"/dev/$ROOT_PART /mnt\".\e[m"

# Install System
pacstrap /mnt base linux linux-firmware
echo -e "\e[92m\e[1mInstalled base system.\e[m"

# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "\e[92m\e[1mGenerated fstab file.\e[m"

# Move Boot Partition Name
mv boot_part.txt /mnt

# Part One Done
echo -e "\e[92m\e[1mPre-Chroot installation complete.\e[m"
rm $0
