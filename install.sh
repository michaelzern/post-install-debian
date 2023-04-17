#!/bin/bash
# Color definitions
COL_NC='\033[0m' # No Color
COL_LIGHT_GREEN='\033[1;32m'
COL_LIGHT_RED='\033[1;31m'

# Shortened script to install apps on a new system (Debian)

readarray -t opt_pkgs < <(grep '^# ' packages.txt | sed 's/^# //')
prompt_optional_pkgs() {
  grep -v '^# ' packages.txt > temp_packages.txt
  echo "Install optional packages? (yes/yes -a/no)"
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
    [[ "$p" == "# "* ]] && continue
    sudo apt install -y "$p" && echo -e "  ${p}:\\t\\t${COL_LIGHT_GREEN}Installation successful${COL_NC}" || { echo -e "  ${p}:\\t\\t${COL_LIGHT_RED}Error installing${COL_NC}"; exit 1; }
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
  [ -f /var/run/reboot-required ] && echo "Reboot required"
}

main() {
  [ ! -f packages.txt ] && echo "Error: Package list file packages.txt not found." && exit 1
  update_upgrade
  prompt_optional_pkgs
  install_pkgs temp_packages.txt
  grep -q "docker.io" temp_packages.txt && add_user_docker_group
  update_bashrc
  check_reboot
  rm -f temp_packages.txt
  echo -e "\n${COL_LIGHT_GREEN}Installation Complete${COL_NC}\n"
}

main
