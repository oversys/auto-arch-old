#!/bin/bash

# Set the time zone
echo "Region:"
read REGION
echo "City:"
read CITY

ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc

# Localization
sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hosts
echo "Enter hostname:"
read HOSTNAME

echo $HOSTNAME > /etc/hostname
echo "127.0.0.1  localhost" >> /etc/hosts
echo "::1        localhost" >> /etc/hosts
echo "127.0.1.1  $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Boot Settings
pacman -S --noconfirm grub efibootmgr mtools os-prober dosfstools
mkdir /boot/EFI

# Read Selected Boot Partition
while IFS= read -r line
do
    BOOT_PART=$line
done < boot_part.txt

# Install GRUB
mount $BOOT_PART /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --efi-directory=/boot/EFI --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# Adding a user
echo "Enter username:"
read USERNAME
useradd -m $USERNAME
usermod -aG wheel,audio,video $USERNAME

# Setting Passwords
echo "Set password for ROOT:"
passwd

echo "Set password for $USERNAME:"
passwd $USERNAME

# Configure Sudo
pacman -S --noconfirm sudo
echo "$USERNAME  ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Additional necessary packages
pacman -S --noconfirm --needed base-devel

# Done
echo "Basic installation complete. Install additional packages, desktop environments and/or window managers and configure network."
