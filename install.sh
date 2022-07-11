#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Máquina ${machine}"

distro=$(cat /proc/version)
echo "Distro ${distro}"

has_package() {
  type "$1" > /dev/null 2>&1
}

# install cURL
if has_package "curl"; then
    echo "curl already available"
else
    sudo apt-get install curl
fi


# install NVM
echo "installing NVM"
if has_package "nvm"; then
    echo "NVM already installed"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

# Set git user
echo "git config user"
read -p "E-mail:" gituseremail
git config --global user.email "$gituseremail"
read -p "Name:" gitusername
git config --global user.name "$gitusername"

# Install yarn
# --no-install-recommends due to using NVM
if [ unameOut = "Linux"]; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install --no-install-recommends yarn
fi

# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
# GH login (will add RSA keys and so on)
gh auth login