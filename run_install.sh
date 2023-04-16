#!/bin/bash

# Download install.sh and packages.txt
curl -O --remote-name-all https://raw.githubusercontent.com/michaelzern/post-install-debian/main/install.sh \
                             https://raw.githubusercontent.com/michaelzern/post-install-debian/main/packages.txt

# Download the checksums
curl -O https://raw.githubusercontent.com/michaelzern/post-install-debian/main/checksums.sha256

# Verify the files using the checksums
if sha256sum -c checksums.sha256; then
  echo "Checksums match. Proceeding with installation."
else
  echo "Checksums do not match. Aborting installation."
  exit 1
fi

# Make install.sh executable
chmod +x install.sh

# Execute install.sh
./install.sh
