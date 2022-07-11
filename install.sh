#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "OS: ${machine}"

distro=$(cat /proc/version)
echo "Distro: ${distro}"

has_package() {
  type "$1" > /dev/null 2>&1
}

# install cURL
if has_package "curl"; then
    echo "curl already available"
else
    sudo apt-get install curl
fi

# install wget
if has_package "curl"; then
    echo "wget already available"
else
    sudo apt install wget
fi

if has_package "unzip"; then
    echo "zip already available"
else
    sudo apt install unzip
fi

# install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f
google-chrome
rm -f ./google-chrome-stable_current_amd64.deb

# JetBrains Mono font
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"


# install NVM
echo "installing NVM"
if has_package "nvm"; then
    echo "NVM already installed"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

# Install yarn
# --no-install-recommends due to using NVM
if [ unameOut = "Linux"]; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install --no-install-recommends yarn
elif [ unameOut = "Mac"]; then
    curl -o- -L https://yarnpkg.com/install.sh | bash
fi

# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
# GH login (will add RSA keys and so on)
gh auth login

# Set git user
echo "git config user"
read -p "E-mail:" gituseremail
git config --global user.email "$gituseremail"
read -p "Name:" gitusername
git config --global user.name "$gitusername"


# ZSH
sudo apt-get install zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# VS Code
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code
