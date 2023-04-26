#!/bin/bash

download_files() {
  echo "Downloading files..."
  curl -O --remote-name-all https://raw.githubusercontent.com/michaelzern/post-install-debian/main/install.sh \
                               https://raw.githubusercontent.com/michaelzern/post-install-debian/main/packages.txt \
                               https://raw.githubusercontent.com/michaelzern/post-install-debian/main/checksums.sha256 || { echo "Error downloading files."; exit 1; }
}

verify_checksums() {
  echo "Verifying checksums..."
  if sha256sum -c checksums.sha256; then
    echo "Checksums match. Proceeding with installation."
  else
    echo "Checksums do not match. Aborting installation."
    exit 1
  fi
}

execute_install() {
  chmod +x install.sh || { echo "Error making install.sh executable."; exit 1; }
  ./install.sh
}

cleanup() {
  rm -f install.sh packages.txt checksums.sha256
}

check_required_utilities() {
  command -v curl >/dev/null 2>&1 || { echo "Error: curl is required but not installed."; exit 1; }
  command -v sha256sum >/dev/null 2>&1 || { echo "Error: sha256sum is required but not installed."; exit 1; }
}

# Help flag
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "Usage: ./run_install.sh"
  echo "Downloads, verifies, and executes an install.sh script and a packages.txt file from a GitHub repository."
  exit 0
fi

# Check for required utilities
check_required_utilities

# Create a directory for the files
mkdir -p post-install
cd post-install || { echo "Error navigating to post-install directory."; exit 1; }

# Download and verify files
download_files
verify_checksums

# Execute the install script
execute_install

# Cleanup
echo "Do you want to remove downloaded files? (yes/no)"
read -r cleanup_ans
if [[ "$cleanup_ans" =~ ^(yes|y)$ ]]; then
  cleanup
fi
