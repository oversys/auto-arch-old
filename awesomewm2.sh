#!/bin/bash

# Fix default user icon
sudo cp /usr/share/lightdm-webkit/themes/Aether/src/img/default-user.png /var/lib/AccountsService/icons/$USER
sudo sed -i "s/Icon=\/home\/$USER\/.face/Icon=\/var\/lib\/AccountsService\/icons\/$USER/g" /var/lib/AccountsService/users/$USER

echo -e "\e[92m\e[1mFixed default user icon.\e[m"

# Download Nerd Font
git clone https://aur.archlinux.org/nerd-fonts-jetbrains-mono.git
cd nerd-fonts-jetbrains-mono
makepkg -si --noconfirm
cd ../
rm -rf nerd-fonts-jetbrains-mono

# Download configuration files
if [[ $1  == "powerarrow" ]]
then
    git clone https://github.com/BetaLost/dotfiles.git
else
    git clone https://github.com/BetaLost/dotfiles-two.git
    mv $HOME/dotfiles-two $HOME/dotfiles
fi

# Configure shell
git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting

mv $HOME/dotfiles/.zshrc $HOME/

echo -e "\e[92m\e[1mConfigured the ZSH shell.\e[m"

# Configure .bashrc
mv $HOME/dotfiles/.bashrc $HOME/

echo -e "\e[92m\e[1mConfigured the BASH shell.\e[m"

# Configure VIM
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mv $HOME/dotfiles/.vimrc $HOME/
echo "{ \"suggest.enablePreselect\": true }" >> $HOME/.vim/coc-settings.json

mkdir $HOME/.vim/colors
curl -L https://raw.githubusercontent.com/ErichDonGubler/vim-sublime-monokai/master/colors/sublimemonokai.vim > $HOME/.vim/colors/sublimemonokai.vim

echo -e "\e[92m\e[1mConfigured VIM.\e[m"

# Configure awesome window manager
sudo mv $HOME/dotfiles/awesome $HOME/.config/

if [[ $1  == "powerarrow" ]]
then
    git clone https://github.com/BetaLost/wallpapers.git $HOME/.config/awesome/themes/powerarrow/wallpapers
    sudo chmod +x $HOME/.config/awesome/themes/powerarrow/s_wall.sh
else
    git clone https://github.com/BetaLost/wallpapers.git
    sudo chmod +x $HOME/.config/awesome/s_wall.sh
fi

echo -e "\e[92m\e[1mConfigured awesome window manager.\e[m"

# Configure rofi
sudo mv $HOME/dotfiles/rofi $HOME/.config/

echo -e "\e[92m\e[1mConfigured rofi.\e[m"

# Get brave
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin
makepkg -si --noconfirm
cd ../
rm -rf brave-bin

echo -e "\e[92m\e[1mInstalled brave browser.\e[m"

# Get picom
# git clone https://aur.archlinux.org/picom-ibhagwan-git.git
# cd picom-ibhagwan-git
# makepkg -si --noconfirm
# cd ../
# rm -rf picom-ibhagwan-git
# sudo mv $HOME/dotfiles/picom $HOME/.config/
#
# echo -e "\e[92m\e[1mInstalled and configured picom compositor.\e[m"

# Configure alacritty
sudo mv $HOME/dotfiles/alacritty $HOME/.config/

echo -e "\e[92m\e[1mConfigured alacritty terminal.\e[m"

rm -rf $HOME/dotfiles

echo -e "\e[92m\e[1mConfigured desktop. Press Ctrl + Super + R to refresh.\e[m"

rm $0
