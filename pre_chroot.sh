#!/bin/bash

# Update the System Clock
timedatectl set-ntp true
echo -e "\e[92m\e[1mUpdated the System Clock."

# Set Font (bigger text)
setfont ter-v32n
echo -e "\e[92m\e[1mChanged Font."

# Get Boot Partition
echo "Boot Partition (sdaX):"
read BOOT_PART
if [[ $BOOT_PART  =~ "sda" ]]
then
    echo -e "\e[92m\e[1mValid boot partition."
    echo $BOOT_PART > boot_part.txt
else
    echo -e "\e[91m\e[1mInvalid input."
    exit
fi

# Get Root Partition
echo "Root Partition (sdaX):"
read ROOT_PART
if [[ $ROOT_PART =~ "sda" ]]
then
    echo -e "\e[92m\e[1mValid root partition."
else
    echo -e "\e[91m\e[1mInvalid input."
    exit
fi

# Format Partitions
mkfs.fat -F32 /dev/$BOOT_PART
echo -e "\e[92m\e[1mFormatted Boot Partition"
mkfs.ext4 /dev/$ROOT_PART
echo -e "\e[92m\e[1mFormatted Root Partition"
mount /dev/$ROOT_PART /mnt
echo -e "\e[92m\e[1mMounted \"$ROOT_PART /mnt\"."

# Install System
pacstrap /mnt base linux linux-firmware
echo -e "\e[92m\e[1mInstalled base system."

# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "\e[92m\e[1mGenerated fstab file."

# Move Boot Partition Name
mv boot_part.txt /mnt

# Part One Done
echo -e "\e[92m\e[1mPre-Chroot installation complete."
rm $0
