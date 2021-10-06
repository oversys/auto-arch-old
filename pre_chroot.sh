#!/bin/bash

# Update the System Clock
timedatectl set-ntp true

# Set Font (bigger text)
setfont ter-v32n

# Get Boot Partition
echo "Boot Partition (sdaX):"
read BOOT_PART
if [[ $BOOT_PART  =~ "sda" ]]
then
    echo "Valid boot partition."
    echo $BOOT_PART > boot_part.txt
else
    echo "Invalid input."
    exit
fi

# Get Root Partition
echo "Root Partition (sdaX):"
read ROOT_PART
if [[ $ROOT_PART =~ "sda" ]]
then
    echo "Valid root partition."
else
    echo "Invalid input."
    exit
fi

# Format Partitions
mkfs.fat -F32 /dev/"${BOOT_PART}"
mkfs.ext4 /dev/"${ROOT_PART}"
mount /dev"${ROOT_PART}" /mnt

# Install System
pacstrap /mnt base linux linux-firmware

# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Part One Done
echo "Pre-Chroot installation complete."
