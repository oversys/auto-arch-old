#!/bin/bash

# Parse Variables
BOOT_PART=$1
ROOT_PART=$2

# Update the System Clock
timedatectl set-ntp true
wait
echo -e "\e[32m\e[1mUpdated the System Clock.\e[m"

# Format Partitions
mkfs.fat -F32 /dev/$BOOT_PART
echo -e "\e[32m\e[1mFormatted Boot Partition.\e[m"
mkfs.ext4 /dev/$ROOT_PART
echo -e "\e[32m\e[1mFormatted Root Partition.\e[m"

# Mount root partition
mount /dev/$ROOT_PART /mnt
echo -e "\e[32m\e[1mMounted \"/dev/$ROOT_PART /mnt\".\e[m"

# Enable parallel downloading
sed -i "s/#ParallelDownloads/ParallelDownloads/g" /etc/pacman.conf

# Install System
pacstrap /mnt base linux linux-firmware
echo -e "\e[32m\e[1mInstalled base system.\e[m"

# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "\e[32m\e[1mGenerated fstab file.\e[m"

# Save Boot Partition Name
echo $BOOT_PART > /mnt/boot_part.txt

# Part One Done
echo -e "\e[32m\e[1mPre-Chroot installation complete.\e[m"
rm $0
