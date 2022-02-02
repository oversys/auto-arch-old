#!/bin/bash

# Parse Variables
REGION=$1
CITY=$2
HOSTNAME=$3
USERNAME=$4
ROOT_PASSWORD=$5
USER_PASSWORD=$6
BOOTDEV=$7

# Infobox Function
infobox() {
	whiptail --backtitle "Auto Arch" --title "$1" --infobox "$2" 8 0
}

# Enable multilib
infobox "Multilib" "Enabling multilib (32 bit support) in pacman..."
printf "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Enable parallel downloading
infobox "Parallel Downloading" "Enabling parallel downloading in pacman..."
sed -i "s/#ParallelDownloads/ParallelDownloads/g" /etc/pacman.conf

# Enable parallel compilation
infobox "Parallel Compilation" "Enabling parallel compilation ($(nproc) threads) in pacman..."
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$(nproc)\"/g" /etc/makepkg.conf

# Install ZSH
infobox "ZSH" "Installing the Z Shell..."
pacman -S --noconfirm zsh > /dev/null

# Set time zone
infobox "Timezone" "Setting timezone to $REGION, $CITY..."
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc

# Localization
infobox "Locale" "Setting and generating locale (en_US.UTF-8)..."
sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
# sed -i "s/#ar_SA.UTF-8/ar_SA.UTF-8/g" /etc/locale.gen
locale-gen > /dev/null

echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hosts
infobox "Hostname" "Setting the hostname..."
echo $HOSTNAME > /etc/hostname
echo "127.0.0.1  localhost" >> /etc/hosts
echo "::1        localhost" >> /etc/hosts
echo "127.0.1.1  $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Get Necessary Boot Packages
infobox "Boot Packages" "Installing boot packages..."
pacman -Syu --noconfirm grub efibootmgr mtools os-prober dosfstools > /dev/null

# Install GRUB
infobox "GRUB" "Installing GRUB..."
mkdir /boot/EFI
mount $BOOTDEV /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --efi-directory=/boot/EFI --recheck &> /dev/null
sed -i "s/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/g" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null

# Adding a user
infobox "User" "Adding user \"$USERNAME\"..."
useradd -m -s /bin/zsh $USERNAME
usermod -aG wheel,audio,video $USERNAME

# Set Passwords
infobox "Passwords" "Setting passwords..."
printf "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd
printf "$USER_PASSWORD\n$USER_PASSWORD" | passwd $USERNAME

# Configure Sudo
infobox "Sudo" "Configuring sudo..."
pacman -S --noconfirm sudo > /dev/null
echo "$USERNAME  ALL=(ALL:ALL) NOPASSWD: ALL" | EDITOR="tee -a" visudo

# Install Network Packages
infobox "Network" "Installing network packages..."
pacman -S --noconfirm networkmanager iw wpa_supplicant dialog > /dev/null
systemctl enable NetworkManager.service > /dev/null

# Install Bluetooth Packages
infobox "Bluetooth" "Installing bluetooth packages..."
pacman -s --noconfirm bluez bluez-utils > /dev/null
systemctl enable bluetooth.service > /dev/null

# Set permissions for brightness and mute button led
infobox "Permissions" "Setting permissions for intel_backlight and mute button LED..."
chmod a+rw /sys/class/backlight/intel_backlight/brightness > /dev/null
chmod a+rw /sys/class/leds/hda\:\:mute/brightness > /dev/null

rm $0
