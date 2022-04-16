#!/bin/bash
#######################################
# Bash script to install apps on a new system (Debian)

## Update packages and Upgrade system
sudo apt update && sudo apt upgrade -y

package="tmux screenfetch docker.io htop tmux bmon curl nano wget"

echo installing the nice-to-have pre-requisites
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6

#install dependencies
for packageName in $package; do
  dpkg -l | grep -qw $packageName || sudo apt install -y $packageName
done

sudo usermod -aG docker $USER

# 1. Set the file to write to
file='$HOME/.bashrc'

# 2. Append text with '>>'
cat <<EOT >> $file
#custom
export EDITOR='nano'
if [ -f /usr/bin/screenfetch ]; then screenfetch; fi
EOT

if [ -f /var/run/reboot-required ]; then
  echo 'reboot required'
fi
