#!/bin/bash

# Color definitions
COL_NC='\033[0m' # No Color
COL_LIGHT_GREEN='\033[1;32m'
COL_LIGHT_RED='\033[1;31m'

# Functions for colored output
success_message() {
  echo -e "${COL_LIGHT_GREEN}$1${COL_NC}"
}

error_message() {
  echo -e "${COL_LIGHT_RED}$1${COL_NC}"
}

# Help flag
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "Usage: ./install.sh"
  echo "Installs a list of packages specified in the packages.txt file."
  exit 0
fi

# Prompt for noninteractive mode
echo "Do you want to set noninteractive mode? (yes/no)"
read -r noninteractive_ans
if [[ "$noninteractive_ans" =~ ^(yes|y)$ ]]; then
  export DEBIAN_FRONTEND=noninteractive
fi

# Shortened script to install apps on a new system (Debian)
readarray -t opt_pkgs < <(grep '^# ' packages.txt | sed 's/^# //')
prompt_optional_pkgs() {
  grep -v '^# ' packages.txt > temp_packages.txt
  echo "Install optional packages? (yes / yes -a / no)"
  while read -r ans; do
    case $ans in
      "yes -a" | "y -a" )
        printf '%s\n' "${opt_pkgs[@]}" >> temp_packages.txt; break;;
      "yes" | "y" )
        for p in "${opt_pkgs[@]}"; do
          echo "Install $p? (yes/no)"; read -r opt
          [[ "$opt" =~ ^(yes|y)$ ]] && echo "$p" >> temp_packages.txt
        done; break;;
      "no" | "n" ) break;;
      * ) echo "Invalid option, please type 'yes', 'yes -a', or 'no'.";;
    esac
  done
}

update_upgrade() {
  sudo apt update -y || { echo "Error updating packages."; exit 1; }
  sudo apt upgrade -y || { echo "Error upgrading the system."; exit 1; }
}

install_pkgs() {
  while IFS=$'\n' read -r p; do
    if sudo apt install -y "$p"; then
      success_message "  ${p}:\t\tInstallation successful"
    else
      error_message "  ${p}:\t\tError installing"
      exit 1
    fi
  done < "$1"
}

add_user_docker_group() {
  sudo usermod -aG docker "$USER" || { echo "Error adding user to Docker group."; exit 1; }
}

update_bashrc() {
  grep -q "neofetch" "$HOME/.bashrc" || cat <<EOT >> "$HOME/.bashrc"
# Custom settings
export EDITOR='nano'
[ -f /usr/bin/neofetch ] && neofetch
EOT
}

check_reboot() {
  if [ -f /var/run/reboot-required ]; then
    echo "Reboot required"
    echo "Do you want to reboot now? (yes/no)"
    read -r reboot_ans
    if [[ "$reboot_ans" =~ ^(yes|y)$ ]]; then
      sudo reboot
    fi
  fi
}

main() {
  [ ! -f packages.txt ] && error_message "Error: Package list file packages.txt not found." && exit 1
  update_upgrade
  prompt_optional_pkgs
  install_pkgs temp_packages.txt
  grep -q "docker.io" temp_packages.txt && add_user_docker_group
  update_bashrc
  check_reboot
  rm -f temp_packages.txt
  success_message "\nInstallation Complete\n"
}

main
