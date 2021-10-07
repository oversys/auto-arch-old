#!/bin/bash

# Update the System Clock
timedatectl set-ntp true

# Set Font (bigger text)
setfont ter-v32n

# Get Boot Partition
echo "Boot Partition (/dev/sdaX):"
read BOOT_PART
if [[ $BOOT_PART  =~ "/dev/sda" ]]
then
    echo "Valid boot partition."
    echo $BOOT_PART > boot_part.txt
else
    echo "Invalid input."
    exit
fi

# Get Root Partition
echo "Root Partition (/dev/sdaX):"
read ROOT_PART
if [[ $ROOT_PART =~ "/dev/sda" ]]
then
    echo "Valid root partition."
else
    echo "Invalid input."
    exit
fi

# Format Partitions
mkfs.fat -F32 $BOOT_PART
mkfs.ext4 $ROOT_PART
mount $ROOT_PART /mnt

# Install System
pacstrap /mnt base linux linux-firmware

# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Move Boot Partition Name
mv boot_part.txt /mnt

# Part One Done
echo "Pre-Chroot installation complete."
rm $0
