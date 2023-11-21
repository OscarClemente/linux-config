#!/bin/bash
# Read Password
echo -n Password: 
read -s password
echo

echo "..."
echo "---- Adding PPAs"
# Add git-core for latest git
echo $password | sudo -S add-apt-repository ppa:git-core/ppa

# GIT
echo "---- Installing Git from added apt"
echo $password | sudo -S apt update
echo $password | sudo -S apt install git -y

echo "---- Installing Curl"
echo $password | sudo -S apt install curl -y

echo "---- Installing Tmux"
echo $password | sudo -S apt install tmux -y

echo "---- Installing latest Kitty terminal"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
echo "---- Configuring Kitty terminal"
# Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
mkdir ~/.local/bin/
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty.desktop file(s)
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

echo "---- Installing FISH shell"
# FISH shell
echo $password | sudo -S apt install libtinfo5
wget -O fishbin 'https://launchpad.net/~fish-shell/+archive/ubuntu/release-3/+files/fish_3.6.1-1~jammy_amd64.deb'
echo $password | sudo -S dpkg -i fishbin
rm fishbin
echo $password | sudo -S chsh -s /usr/bin/fish 
echo $password | apt install libxcb-xkb-dev -y

echo "---- Installing Neovim Nightly"
# NEOVIM
wget -O nvim.appimage 'https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage'
echo $password | chmod u+x nvim.appimage
echo $password | sudo ln nvim.appimage /usr/bin/nvim

# RIPGREP for neovim treesitter
echo $password | sudo -S apt install ripgrep -y

echo "---- Getting Neovim config"
# NEOVIM config

git clone https://github.com/OscarClemente/nvim-conf.git ~/.config/nvim
git config --global core.editor "nvim"

echo "---- Installing latest Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "---- Installing Go 1.21"
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
echo $password | sudo -S tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
rm go1.21.0.linux-amd64.tar.gz

echo "---- Installing Hack Nerd font"
mkdir nerdfont
cd nerdfont
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Italic/HackNerdFontMono-Italic.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/BoldItalic/HackNerdFontMono-BoldItalic.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/HackNerdFontMono-Bold.ttf
echo $password | sudo -S mkdir /usr/share/fonts/hack
echo $password | sudo -S cp * /usr/share/fonts/hack
cd ..
echo $password | sudo -S rm -r nerdfont/

echo "---- Copying Kitty config"
wget -P ~/.config/kitty/ https://github.com/OscarClemente/linux-config/raw/main/current-theme.conf
wget -P ~/.config/kitty/ https://github.com/OscarClemente/linux-config/raw/main/kitty.conf
wget -P ~/.config/fish/ https://github.com/OscarClemente/linux-config/raw/main/config.fish

echo "---- FINISHED. Restarting your system is recommended"
echo "---- You will still need to save the plugin file inside nvim config and get the LSP plugins with Mason"
