#!/bin/bash

# Infobox Function
infobox() {
	whiptail --backtitle "Auto Arch" --title "$1" --infobox "$2" 8 0
}

PKGS=(
	"lightdm" # Display manager
	"lightdm-webkit2-greeter" # LightDM theme
	"bspwm" # Tiling Window Manager
	"sxhkd" # Hotkey tool
	"xorg-server" # Dependency of BSPWM
	"light" # Manage brightness
	"zsh" # Z Shell
	"cifs-utils" # Mount Common Internet File System
	"ntfs-3g" # Mount New Technology File System
	"rofi" # Search tool
	"flameshot" # Screenshot tool
	"kitty" # Terminal Emulator
	"vim" # Editor
	"nodejs" # CoC.nvim dependency
	"npm" # CoC.nvim dependency
	"clang" # coc-clangd dependency
	"htop" # System monitor
	"exa" # ls alternative
	"bat" # cat alternative
	"wget" # Retrieve content
	"git" # Git
	"man" # Manual
	"github-cli" # Github CLI
	"pulseaudio" # PulseAudio
	"pulsemixer" # Manage audio
	"alsa-utils" # Alsa utilities
	"pulseaudio-bluetooth" # Bluetooth headset capability
	"zip" # Zip files
	"unzip" # Unzip files
	"feh" # Change wallpaper
	"python-pip" # Install Python modules/packages
	"xclip" # Copy to clipboard
	"ttf-joypixels" # Emoji font
	"libx11" # X11 Client Library
	"libxcursor" # Cursor dependency
	"libpng" # Cursor dependency
	"xorg-xprop" # Polywins dependency
	"wmctrl" # Polywins dependency
	"slop" # Polywins dependency
)

GPU_PKGS=(
	"mesa"
	"mesa-demos"
	"lib32-mesa"
	"vulkan-radeon"
	"lib32-vulkan-radeon"
	"vulkan-icd-loader"
	"lib32-vulkan-icd-loader"
	"xf86-video-amdgpu"
)

AUR_PKGS=(
	"rtl8821cu-morrownr-dkms-git" # RTL8821CU Network Adapter Driver
	"nerd-fonts-jetbrains-mono" # JetBrains Mono Nerd Font
	"ttf-poppins" # Poppins font
	"picom-ibhagwan-git" # Picom compositor
	"polybar" # Polybar
	"brave-bin" # Brave Browser
	"btop" # htop alternative
	"nerdfetch" # System information tool
)

# Install packages
infobox "Installing packages" "Installing ${#PKGS[@]} packages from the official Arch Linux repositories..."
sudo pacman -Syu --noconfirm "${PKGS[@]}" &> /dev/null

# Install AMD GPU drivers
infobox "Installing packages" "Installing ${#GPU_PKGS[@]} driver packages for AMD GPU..."
sudo pacman -S --noconfirm "${GPU_PKGS[@]}" > /dev/null

# Install AUR packages
for aurpkg in "${AUR_PKGS[@]}"; do
	infobox "AUR" "Installing \"$aurpkg\" from the Arch User Repository..."
	git clone --quiet https://aur.archlinux.org/$aurpkg.git
	cd $aurpkg
	makepkg -si --noconfirm &> /dev/null
	cd ..
	rm -rf $aurpkg
done

# Install LightDM Aether theme
infobox "LightDM" "Configuring and installing LightDM theme..."
git clone --quiet https://github.com/NoiSek/Aether.git
sudo cp --recursive Aether /usr/share/lightdm-webkit/themes/
rm -rf Aether
sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = lightdm-webkit-theme-aether #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
sudo ln -s /usr/share/lightdm-webkit/themes/Aether /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether
sudo sed -i "s/# greeter-session = Session to load for greeter/greeter-session = lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/# user-session = Session to load for users/user-session = bspwm/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/#user-session=default/user-session=bspwm/g" /etc/lightdm/lightdm.conf
sudo systemctl enable lightdm.service > /dev/null

# Fix default user icon
# sudo cp /usr/share/lightdm-webkit/themes/Aether/src/img/default-user.png /var/lib/AccountsService/icons/$USER
# sudo sed -i "s/Icon=\/home\/$USER\/.face/Icon=\/var\/lib\/AccountsService\/icons\/$USER/g" /var/lib/AccountsService/users/$USER

# echo -e "\e[32m\e[1mFixed default user icon.\e[m"

# Install cursor
infobox "Cursor" "Installing cursor..."
wget https://github.com/BetaLost/Arch-Install-Script/raw/main/macOSBigSur.tar.gz &> /dev/null
tar -xf macOSBigSur.tar.gz
sudo mv macOSBigSur /usr/share/icons/
rm -rf macOSBigSur.tar.gz

sudo sed -i "s/Inherits=Adwaita/Inherits=macOSBigSur/g" /usr/share/icons/default/index.theme

# Install Arabic font
infobox "Arabic Font" "Installing Arabic font..."
wget https://github.com/BetaLost/Arch-Install-Script/raw/main/khebrat-musamim.zip &> /dev/null
unzip khebrat-musamim.zip > /dev/null
rm khebrat-musamim.zip
sudo mkdir -p /usr/share/fonts/TTF
sudo mv "18 Khebrat Musamim Regular.ttf" /usr/share/fonts/TTF/

sudo mv $HOME/dotfiles/fonts.conf /etc/fonts/
sudo cp /etc/fonts/fonts.conf /etc/fonts/local.conf

# Install GRUB theme
infobox "GRUB Theme" "Installing GRUB theme..."
wget https://github.com/BetaLost/auto-arch/raw/main/arch.tar &> /dev/null
sudo mkdir -p /boot/grub/themes
sudo mkdir /boot/grub/themes/arch
sudo mv arch.tar /boot/grub/themes/arch/
sudo tar xf /boot/grub/themes/arch/arch.tar -C /boot/grub/themes/arch/
sudo rm /boot/grub/themes/arch/arch.tar
sudo sed -i "s/GRUB_GFXMODE=auto/GRUB_GFXMODE=1920x1080/g" /etc/default/grub
sudo sed -i "s/#GRUB_THEME=.*/GRUB_THEME=\"\/boot\/grub\/themes\/arch\/theme.txt\"/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null

# Change default shell
infobox "Default Shell" "Changing default shell to ZSH..."
sudo chsh -s /bin/zsh $USER

# Download dotfiles
infobox "Dotfiles" "Cloning dotfiles repository..."
git clone --quiet https://github.com/BetaLost/dotfiles.git
mkdir -p $HOME/.config

# Configure BSPWM and SXHKD
infobox "Dotfiles" "Configuring BSPWM and SXHKD..."
sudo mv $HOME/dotfiles/bspwm $HOME/.config/
sudo mv $HOME/dotfiles/sxhkd $HOME/.config/
sudo mv $HOME/dotfiles/wallpapers $HOME/.config/

find $HOME/.config/bspwm -type f -exec chmod +x {} \;
find $HOME/.config/sxhkd -type f -exec chmod +x {} \;

# Configure ZSH
infobox "Dotfiles" "Configuring the Z Shell (ZSH)..."
git clone --quiet https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
mv $HOME/dotfiles/.zshrc $HOME/

# Configure BASH
infobox "Dotfiles" "Configuring the Bourne Again Shell (BASH)..."
mv $HOME/dotfiles/.bashrc $HOME/

# Configure VIM
infobox "Dotfiles" "Configuring VIM..."
curl -fLso ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mv $HOME/dotfiles/.vimrc $HOME/

# Configure Rofi
infobox "Dotfiles" "Configuring Rofi..."
sudo mv $HOME/dotfiles/rofi $HOME/.config/

# Configure Kitty
infobox "Dotfiles" "Configuring the Kitty terminal emulator..."
sudo mv $HOME/dotfiles/kitty $HOME/.config/

# Configure Alacritty
# infobox "Dotfiles" "Configuring the Alacritty terminal emulator..."
# sudo mv $HOME/dotfiles/alacritty $HOME/.config/

# Configure Picom 
infobox "Dotfiles" "Configuring Picom..."
sudo mv $HOME/dotfiles/picom $HOME/.config/

# Configure Polybar
infobox "Dotfiles" "Configuring Polybar..."
sudo mv $HOME/dotfiles/polybar $HOME/.config/

for script in $HOME/.config/polybar/scripts/*; do
    sudo chmod +x $script
done

rm -rf $HOME/dotfiles $0
