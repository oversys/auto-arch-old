#!/bin/bash

# Get Boot Partition
echo "Boot Partition (sdaX):"
read BOOT_SPART
if [[ $BOOT_SPART  =~ "sda" ]]
then
    echo "Valid boot partition."
    echo $BOOT_SPART > boot_spart.txt
else
    echo "Invalid input."
    exit
fi

# Get Root Partition
echo "Root Partition (sdaX):"
read ROOT_SPART
if [[ $ROOT_SPART =~ "sda" ]]
then
    echo "Valid root partition."
else
    echo "Invalid input."
    exit
fi

# Format Partitions
BOOT_PART=/dev/"$BOOT_SPART"
ROOT_PART=/dev/"$ROOT_SPART"
mkfs.fat -F32 "$BOOT_PART"
mkfs.ext4 "$ROOT_PART"
mount "$ROOT_PART" /mnt

# Install System
pacstrap /mnt base linux linux-firmware

# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Part One Done
echo "Pre-Chroot installation complete."
