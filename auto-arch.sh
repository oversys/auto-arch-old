#!/bin/bash

# Functions
yesno() {
	whiptail --backtitle "Auto Arch" --title "$1" --yesno "$2" 0 0
}

inputbox() {
	whiptail --backtitle "Auto Arch" --title "$1" --inputbox --nocancel "$2" 0 0
}

passwordbox() {
	whiptail --backtitle "Auto Arch" --title "$1" --passwordbox --nocancel "$2" 8 0
}

msgbox() {
	whiptail --backtitle "Auto Arch" --title "$1" --msgbox "$2" 0 0
}

installCancel() { 
	msgbox "Cancel" "Installation cancelled."
	exit
}

# Setup
setfont ter-v32n

# Start script
yesno "Start" "Welcome to the installer. Would you like to start?" 
case $? in
	1) installCancel;;
esac

# Configuration 

# Partitions
PARTITIONS=$(lsblk -p -n -l -o NAME -e 7,11)
OPTIONS=()

for PARTITION in $PARTITIONS; do
	if [ $PARTITION != "/dev/sda" ]; then
		OPTIONS+=("$PARTITION" " $(lsblk -n $PARTITION | awk '{print $4}')")
	fi
done

BOOTDEV=$(whiptail --backtitle "Auto Arch" --title "Boot Partition" --menu --nocancel "Select boot partition:" 0 0 0 "${OPTIONS[@]}" 3>&1 1>&2 2>&3)

ROOTDEV=$(whiptail --backtitle "Auto Arch" --title "Root Partition" --menu --nocancel "Select root partition:" 0 0 0 "${OPTIONS[@]}" 3>&1 1>&2 2>&3)

if [ "$BOOTDEV" = "$ROOTDEV" ]; then
	msgbox "Partitions" "Boot and Root partitions cannot be the same."
	exit
fi

unset OPTIONS

# Timezone
REGIONS=$(ls -l /usr/share/zoneinfo/ | grep '^d' | gawk -F':[0-9]* ' '/:/{print $2}')
OPTIONS=()
for REGION in ${REGIONS}; do
	OPTIONS+=("${REGION}" "")
done

REGION=$(whiptail --backtitle "Auto Arch" --title "Timezone" --menu --nocancel "Select Region:" 0 0 0 "${OPTIONS[@]}" 3>&1 1>&2 2>&3)

unset OPTIONS

CITIES=$(ls /usr/share/zoneinfo/${REGION}/)
OPTIONS=()
for CITY in ${CITIES}; do
	OPTIONS+=("${CITY}" "")
done

CITY=$(whiptail --backtitle "Auto Arch" --title "Timezone" --menu --nocancel "Select City:" 0 0 0 "${OPTIONS[@]}" 3>&1 1>&2 2>&3)

# Hostname
HOSTNAME=$(inputbox "Hostname" "Set hostname:" 3>&1 1>&2 2>&3)

if [ -z "$HOSTNAME" ]; then 
	msgbox "Hostname" "Hostname cannot be empty"
	exit
fi

# Username
USERNAME=$(inputbox "Username" "Set username:" 3>&1 1>&2 2>&3)

if [ -z "$USERNAME" ]; then 
	msgbox "Username" "Username cannot be empty"
	exit
fi

# Root Password
ROOT_PASSWORD=$(passwordbox "Password" "Set password for root:" 3>&1 1>&2 2>&3)
CONFIRM_ROOT_PASSWORD=$(passwordbox "Password" "Confirm password for root:" 3>&1 1>&2 2>&3)

if [ $ROOT_PASSWORD != $CONFIRM_ROOT_PASSWORD ]; then
	msgbox "Password" "Passwords do not match"
    exit
elif [ -z "$ROOT_PASSWORD" ]; then
	msgbox "Password" "Password cannot be empty"
	exit
fi

# User Password
USER_PASSWORD=$(passwordbox "Password" "Set password for \"$USERNAME\":" 3>&1 1>&2 2>&3)
CONFIRM_USER_PASSWORD=$(passwordbox "Password" "Confirm password for \"$USERNAME\":" 3>&1 1>&2 2>&3)

if [ $USER_PASSWORD != $CONFIRM_USER_PASSWORD ]; then
	msgbox "Password" "Passwords do not match"
    exit
elif [ -z "$USER_PASSWORD" ]; then
	msgbox "Password" "Password cannot be empty"
	exit
fi

# Confirm data
yesno "Confirm Data" "You have entered the following data:\n\nBOOT PARTITION: $BOOTDEV\nROOT PARTITION: $ROOTDEV\nREGION, CITY: $REGION, $CITY\nHOSTNAME: $HOSTNAME\nUSERNAME: $USERNAME\n\nAre you sure you want to install Arch Linux with the data listed above?"

case $? in
	1) installCancel;;
esac

# Run the first script
curl -Lso pre-chroot.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/pre-chroot.sh
bash pre-chroot.sh $BOOTDEV $ROOTDEV

# Run the second script
curl -Lso /mnt/chroot.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/chroot.sh
arch-chroot /mnt /bin/bash "./chroot.sh $REGION $CITY $HOSTNAME $USERNAME $ROOT_PASSWORD $USER_PASSWORD $BOOTDEV"

# Run the third script
curl -Lso /mnt/home/$USERNAME/post-install.sh https://raw.githubusercontent.com/BetaLost/auto-arch/main/post-install.sh
arch-chroot /mnt /bin/su -c "cd ~; bash post-install.sh" $USERNAME -
msgbox "Finished Installation" "Arch Linux has successfully been installed on this machine."
