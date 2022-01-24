#!/bin/zsh

PKGS=(
	"lightdm" # Display manager
	"lightdm-webkit2-greeter" # LightDM theme
	"bspwm" # Tiling Window Manager
	"sxhkd" # Hotkey tool
	"xorg-server" # Dependency of BSPWM
	"light" # Manage brightness
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
	"bluez" # BlueZ bluetooth management
	"bluez-utils" # BlueZ utilities
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

# Update the database
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S --noconfirm $PKGS

# Install AMD GPU drivers
sudo pacman -S --noconfirm $GPU_PKGS

echo -e "\e[32m\e[1mInstalled packages.\e[m"

# Enable bluetooth service
sudo systemctl enable bluetooth.service

# Set permissions for brightness and mute button led
sudo chmod a+rw /sys/class/backlight/intel_backlight/brightness
sudo chmod a+rw /sys/class/leds/hda\:\:mute/brightness

# Install LightDM Aether theme
git clone https://github.com/NoiSek/Aether.git
sudo cp --recursive Aether /usr/share/lightdm-webkit/themes/
rm -rf Aether
sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = lightdm-webkit-theme-aether #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
sudo ln -s /usr/share/lightdm-webkit/themes/Aether /usr/share/lightdm-webkit/themes/lightdm-webkit-theme-aether
sudo sed -i "s/# greeter-session = Session to load for greeter/greeter-session = lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/# user-session = Session to load for users/user-session = bspwm/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/#user-session=default/user-session=bspwm/g" /etc/lightdm/lightdm.conf
sudo systemctl enable lightdm.service

echo -e "\e[32m\e[1mEnabled display manager.\e[m"

# Fix default user icon
sudo cp /usr/share/lightdm-webkit/themes/Aether/src/img/default-user.png /var/lib/AccountsService/icons/$USER
sudo sed -i "s/Icon=\/home\/$USER\/.face/Icon=\/var\/lib\/AccountsService\/icons\/$USER/g" /var/lib/AccountsService/users/$USER

echo -e "\e[32m\e[1mFixed default user icon.\e[m"

# Install cursor
wget https://github.com/BetaLost/Arch-Install-Script/raw/main/macOSBigSur.tar.gz
tar -xf macOSBigSur.tar.gz
sudo mv macOSBigSur /usr/share/icons/
rm -rf macOSBigSur.tar.gz

sudo sed -i "s/Inherits=Adwaita/Inherits=macOSBigSur/g" /usr/share/icons/default/index.theme

echo -e "\e[32m\e[1mInstalled cursor theme.\e[m"

# Install Arabic font
wget https://github.com/BetaLost/Arch-Install-Script/raw/main/khebrat-musamim.zip
unzip khebrat-musamim.zip
sudo mv "18 Khebrat Musamim Regular.ttf" /usr/share/fonts/TTF/

sudo mv $HOME/dotfiles/fonts.conf /etc/fonts/
sudo cp /etc/fonts/fonts.conf /etc/fonts/local.conf

echo -e "\e[32m\e[1mChanged default Arabic font.\e[m"

# Change shell
sudo chsh -s /bin/zsh $USER

echo -e "\e[32m\e[1mChanged default shell.\e[m"

# Install AUR packages
for aurpkg in $AUR_PKGS; do
	git clone https://aur.archlinux.org/$aurpkg.git
	cd $aurpkg
	makepkg -si --noconfirm
	cd ..
	rm -rf $aurpkg
done

echo -e "\e[32m\e[1mInstalled RTL8821CU Network Adapter Driver, JetBrains Mono Nerd Font, Poppins Font, Picom compositor, Polybar, Brave browser, btop, and NerdFetch.\e[m"

# Download dotfiles
git clone https://github.com/BetaLost/dotfiles.git
mkdir -p $HOME/.config

# Configure BSPWM and SXHKD
sudo mv $HOME/dotfiles/bspwm $HOME/.config/
sudo mv $HOME/dotfiles/sxhkd $HOME/.config/
sudo mv $HOME/dotfiles/wallpapers $HOME/.config/

find $HOME/.config/bspwm -type f -exec chmod +x {} \;
find $HOME/.config/sxhkd -type f -exec chmod +x {} \;

# Configure ZSH
git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
mv $HOME/dotfiles/.zshrc $HOME/

echo -e "\e[32m\e[1mConfigured the ZSH shell.\e[m"

# Configure BASH
mv $HOME/dotfiles/.bashrc $HOME/

echo -e "\e[32m\e[1mConfigured the BASH shell.\e[m"

# Configure VIM
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mv $HOME/dotfiles/.vimrc $HOME/
vim +PlugInstall +CocInstall +qa

echo -e "\e[32m\e[1mConfigured VIM.\e[m"

# Configure Rofi
sudo mv $HOME/dotfiles/rofi $HOME/.config/

echo -e "\e[32m\e[1mConfigured Rofi.\e[m"

# Configure Kitty
sudo mv $HOME/dotfiles/kitty $HOME/.config/

echo -e "\e[32m\e[1mConfigured Kitty.\e[m"

# Configure Alacritty
# sudo mv $HOME/dotfiles/alacritty $HOME/.config/
#
# echo -e "\e[32m\e[1mConfigured Alacritty.\e[m"

# Configure Picom 
sudo mv $HOME/dotfiles/picom $HOME/.config/

echo -e "\e[32m\e[1mConfigured Picom.\e[m"

# Configure Polybar
sudo mv $HOME/dotfiles/polybar $HOME/.config/

for script in $HOME/.config/polybar/scripts/*; do
    sudo chmod +x $script
done

echo -e "\e[32m\e[1mConfigured Polybar.\e[m"

# Configure Firefox
# mv $HOME/dotfiles/prefs.js $HOME/
# printf "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/\nhttps://addons.mozilla.org/en-US/firefox/addon/ctrl-number-to-switch-tabs/\nhttps://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/" > extensions.txt
# echo -e "\e[32m\e[1mMoved Firefox files to the home directory. Extension links are in the \"extensions.txt\" file. \e[31m\e[1mREMEMBER TO MOVE IT TO THE DEFAULT PROFILE FOLDER (~/.mozilla/firefox/PROFILE-FOLDER/).\e[m"
# echo -e "\e[32m\e[1mConfigured desktop. Restart this machine to see the changes.\e[m"

rm -rf $HOME/dotfiles $0
