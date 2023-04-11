#!/bin/bash
# Bash script to install apps on a new system (Debian)

# Update packages and Upgrade system
update_and_upgrade() {
  echo "Updating packages and upgrading the system..."
  sudo apt update && sudo apt upgrade -y || { echo "Error updating and upgrading."; exit 1; }
}

# Function to install packages
install_packages() {
  local packages_list="$1"
  echo "Installing packages from $packages_list..."
  while IFS= read -r package_name; do
    if ! dpkg -l | grep -qw "$package_name"; then
      sudo apt install -y "$package_name" || { echo "Error installing $package_name."; exit 1; }
    fi
  done < "$packages_list"
}

# Function to add user to the Docker group
add_user_to_docker_group() {
  echo "Adding user to the Docker group..."
  sudo usermod -aG docker "$USER" || { echo "Error adding user to Docker group."; exit 1; }
}

# Function to update .bashrc
update_bashrc() {
  local file="$HOME/.bashrc"
  local is_in_file=$(grep -c "neofetch" "$file")

  if [ "$is_in_file" -eq 0 ]; then
    echo "Updating .bashrc..."
    cat <<EOT >> "$file"
# Custom settings
export EDITOR='nano'
[ -f /usr/bin/neofetch ] && neofetch
EOT
  else
    echo "bashrc already contains neofetch"
  fi
}

# Function to check for reboot requirement
check_for_reboot() {
  if [ -f /var/run/reboot-required ]; then
    echo "Reboot required"
  fi
}

# Main script
main() {
  local packages_list="packages.txt"

  if [ ! -f "$packages_list" ]; then
    echo "Error: Package list file $packages_list not found."
    exit 1
  fi

  update_and_upgrade
  install_packages "$packages_list"
  add_user_to_docker_group
  update_bashrc
  check_for_reboot

  echo
  echo "Installation Complete"
  echo
}