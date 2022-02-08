#!/bin/bash

# Parse Variables
BOOTDEV=$1
ROOTDEV=$2

# Infobox Function
infobox() {
	whiptail --backtitle "Auto Arch" --title "$1" --infobox "$2" 8 0
}

# Update the System Clock
infobox "System Clock" "Updating system clock..."
timedatectl set-ntp true &> /dev/null

# Format Partitions
infobox "Boot Partition" "Formatting boot partition ($BOOTDEV)..."
mkfs.fat -F32 $BOOTDEV > /dev/null

infobox "Root Partition" "Formatting root partition ($ROOTDEV)..."
yes | mkfs.ext4 $ROOTDEV > /dev/null

# Mount root partition
infobox "Root Partition" "Mounting root partition ($ROOTDEV)..."
mount $ROOTDEV /mnt

# Enable parallel downloading
infobox "Parallel Downloading" "Enabling parallel downloading in pacman..."
sed -i "s/#ParallelDownloads/ParallelDownloads/g" /etc/pacman.conf

# Install System
infobox "Base System" "Installing base system..."
pacstrap /mnt base linux linux-firmware linux-headers base-devel dkms intel-ucode libnewt > /dev/null

# Generate fstab file
infobox "fstab" "Generating fstab file..."
genfstab -U /mnt >> /mnt/etc/fstab

rm $0
