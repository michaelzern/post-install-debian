#!/bin/bash
# Bash script to install apps on a new system (Debian)

# Load optional packages into an array
readarray -t optional_packages < <(grep '^# ' packages.txt | sed 's/^# //')

# Function to prompt user for optional packages installation
prompt_optional_packages() {
  echo "Would you like to install optional packages? (yes/yes -a/no)"
  while read -r answer; do
    case $answer in
      "yes -a" | "y -a" )
        for package in "${optional_packages[@]}"; do
          package="${package/\#/}"
          echo "Installing $package..."
          echo "$package" >> packages.txt
        done
        break
        ;;
      "yes" | "y" )
        tmp_packages_list=$(mktemp)
        cp packages.txt "$tmp_packages_list"
        for package in "${optional_packages[@]}"; do
          package="${package/\#/}"
          echo "Install $package? (yes/no)"
          read -r opt
          case $opt in
            "yes" | "y" ) echo "$package" >> "$tmp_packages_list";;
            "no" | "n" ) ;;
            * ) echo "Invalid option, please type 'yes' or 'no'.";;
          esac
        done
        cp "$tmp_packages_list" packages.txt
        rm "$tmp_packages_list"
        break
        ;;
      "no" | "n" ) break;;
      * ) echo "Invalid option, please type 'yes', 'yes -a', or 'no'.";;
    esac
  done
}

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
      if [[ "$package_name" == "#"* ]]; then
        package_name="${package_name/\#/}"
      fi
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
  prompt_optional_packages
  install_packages "$packages_list"
  # Check if docker.io is in packages.txt
  if grep -q "docker.io" "$packages_list"; then
  add_user_to_docker_group
  fi
  update_bashrc
  check_for_reboot

  echo
  echo "Installation Complete"
  echo
}

main # Call the main function to start the script