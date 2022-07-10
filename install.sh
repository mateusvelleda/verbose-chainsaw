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


git config --global user.email "mateusvelleda@gmail.com"
git config --global user.name "Mateus V. Vellar"