#!/bin/bash

# Parse Variables
BOOTDEV=$1
ROOTDEV=$2
CHOICE=$3

# Functions
infobox() {
	whiptail --backtitle "Auto Arch" --title "$1" --infobox "$2" 12 0
}

getdesc() { pacman -Si $1 | grep -Po '^Description\s*: \K.+'; }
getsize() { pacman -Si $1 | grep -Po '^Installed Size\s*: \K.+'; }

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
PKGS=(
	"base"
	"linux"
	"linux-firmware"
	"linux-headers"
	"base-devel"
	"dkms"
	"intel-ucode"
	"libnewt"
)

getindex() {
	for i in "${!PKGS[@]}"; do
		if [[ "${PKGS[i]}" = "$1" ]]; then echo $(expr $i + 1); fi
	done
}

fastinstall() {
	infobox "Base System" "Installing base system..."
	pacstrap /mnt "${PKGS[@]}" > /dev/null
}

slowinstall() {
	for pkg in "${PKGS[@]}"; do
		infobox "Base System Installation" "Name: $pkg\nDescription: $(getdesc $pkg)\nSize: $(getsize $pkg)\n$(getindex $pkg) out of ${#PKGS[@]}"
		pacstrap /mnt $pkg > /dev/null
	done
}

case $CHOICE in
	1) fastinstall;;
	2) slowinstall;;
esac

# Generate fstab file
infobox "fstab" "Generating fstab file..."
genfstab -U /mnt >> /mnt/etc/fstab

rm $0
