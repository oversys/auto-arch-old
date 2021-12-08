#!/bin/bash

# Set the time zone
echo -e "\e[92m\e[1mRegion:\e[m"
read REGION
echo -e "\e[92m\e[1mCity:\e[m"
read CITY

ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc
echo -e "\e[92m\e[1mSet the time zone.\e[m"

# Localization
sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo -e "\e[92m\e[1mSet the system locales.\e[m"

# Hosts
echo -e "\e[92m\e[1mEnter hostname:\e[m"
read HOSTNAME

echo $HOSTNAME > /etc/hostname
echo "127.0.0.1  localhost" >> /etc/hosts
echo "::1        localhost" >> /etc/hosts
echo "127.0.1.1  $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

echo -e "\e[92m\e[1mSet the hostname.\e[m"

# Get Necessary Boot Packages
pacman -S --noconfirm grub efibootmgr mtools os-prober dosfstools

echo -e "\e[92m\e[1mInstalled boot packages.\e[m"
mkdir /boot/EFI

# Read Selected Boot Partition
while IFS= read -r line
do
    BOOT_PART=$line
done < boot_part.txt

# Install GRUB
mount /dev/$BOOT_PART /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --efi-directory=/boot/EFI --recheck
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\e[92m\e[1mInstalled GRUB.\e[m"

# Adding a user
echo -e "\e[92m\e[1mEnter username:\e[m"
read USERNAME
useradd -m $USERNAME
usermod -aG wheel,audio,video $USERNAME

echo -e "\e[92m\e[1mAdded user: \"$USERNAME\".\e[m"

# Setting Passwords
echo -e "\e[92m\e[1mSet password for ROOT:\e[m"
passwd

echo -e "\e[92m\e[1mSet password for \"$USERNAME\":\e[m"
passwd $USERNAME

# Configure Sudo
pacman -S --noconfirm sudo
echo "$USERNAME  ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo -e "\e[92m\e[1mConfigured sudo.\e[m"

# Additional necessary packages
pacman -S --noconfirm --needed base-devel

echo -e "\e[92m\e[1mInstalled additional necessary packages.\e[m"

# Install Network Packages
pacman -S --noconfirm networkmanager iw wpa_supplicant dialog netctl
systemctl enable NetworkManager.service

echo -e "\e[92m\e[1mInstalled network packages.\e[m"

# Done
echo -e "\e[92m\e[1mBasic installation complete.\e[m"
rm boot_part.txt $0
