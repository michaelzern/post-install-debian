#!/bin/bash
# Bash script to install apps on a new system (Debian)

## Update packages and Upgrade system
sudo apt update && sudo apt upgrade -y

package="
neofetch
docker.io
htop
tmux
bmon
nano
wget"

echo
echo Installing the nice-to-have pre-requisites
echo
echo you have 5 seconds to proceed ...
echo
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6

## install dependencies
for packageName in $package; do
  dpkg -l | grep -qw $packageName || sudo apt install -y $packageName
done

sudo usermod -aG docker $USER

## 1. Set the file to write to
file=$HOME/.bashrc
isInFile=$(cat $file | grep -c "neofetch")

## 2. Append text
if [ $isInFile -eq 0 ]; then
 cat <<EOT >> $file
#custom
export EDITOR='nano'
if [ -f /usr/bin/neofetch ]; then neofetch; fi
EOT
else
  echo bashrc already contains neofetch
fi

## check for reboot
if [ -f /var/run/reboot-required ]; then
  echo 'reboot required'
fi

echo
echo // Complete //
echo
