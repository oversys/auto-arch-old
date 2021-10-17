# Arch Install Script
This is my personal Arch Linux installation script. This script will install the Awesome window manager and the Alacritty terminal.

# Instructions:
> **Before chrooting into the system**
- Partition the disk using the tool of your choice (fdisk, cfdisk, etc)
- Download the script: `curl -L tinyurl.com/vjh-pre-chroot > pre-chroot.sh`
- Make it executable: `chmod +x pre-chroot.sh`
- Run the script: `./pre-chroot.sh`
- Answer the prompts.

- Chroot into the system: `arch-chroot /mnt`

> **After chrooting into the system**
- Download the second script: `curl -L tinyurl.com/vjh-chroot > chroot.sh`
- Make it executable: `chmod +x chroot.sh`
- Run the script: `./chroot.sh`
- Answer the prompts.

> **After base install**
- Download the third script: `curl -L tinyurl.com/vjh-awesomewm > awesomewm.sh`
- Make it executable: `chmod +x awesomewm.sh`
- Run the script: `./awesomewm.sh`
- Wait for the script to install the packages.
- Exit chroot: `exit`
- Boot into the system: `reboot` (Make sure to unplug the install medium)

> **After first boot**
- Download the fourth script: `curl -L tinyurl.com/vjh-awesomewm2 > awesomewm2.sh`
- Make it executable: `sudo chmod +x awesomewm2.sh`
- Run the script: `./awesomewm2.sh`
- Wait for the script to install more packages and configure the system.
