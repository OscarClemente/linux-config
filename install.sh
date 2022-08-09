#!/bin/bash
# Read Password
echo -n Password: 
read -s password
echo

# GIT
echo "---- Installing Git from added apt"
echo password | sudo -S add-apt-repository ppa:git-core/ppa
echo password | sudo -S apt update
echo password | sudo -S apt install git

echo "---- Installing Curl"
echo password | sudo -S apt install curl -y

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
echo password | sudo -S apt install libtinfo5
TEMP_DEB="$(mktemp)"
wget -O "$TEMP_DEB" 'https://launchpad.net/~fish-shell/+archive/ubuntu/release-3/+files/fish_3.5.1-1~xenial_amd64.deb'
echo password | sudo -S dpkg -i "$TEMP_DEB"
chsh -s $(which fish)

echo "---- Installing Neovim 0.7.2"
# NEOVIM
wget -O nvim-linux64.dev 'https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb'
echo password | sudo -S apt install ./nvim-linux64.dev
rm -f ./nvim-linux64.dev

echo "---- Getting Neovim config"
# NEOVIM config
git clone https://github.com/OscarClemente/turbonvim.git ~/.config/nvim

echo "---- Installing latest Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "---- Installing Go 1.19"
echo password | sudo -S tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz

echo "---- Installing Hack Nerd font"
mkdir nerdfont
cd nerdfont
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Italic/complete/Hack%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/BoldItalic/complete/Hack%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/complete/Hack%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
echo password | sudo -S mkdir /usr/share/fonts/hack
echo password | sudo -S cp * /usr/share/fonts/hack
cd ..
echo password | sudo -S rm -r nerdfont/

