# My Post Install Script Linux
<div id="header" align="center">
  <img src="https://media.giphy.com/media/MCRQ0Nkn4KfeQDdM7N/giphy.gif" width="150"/>
</div>

## Installation

For a one-step command run (includes file integrity check using SHA256 checksums):
### ```curl -O https://raw.githubusercontent.com/michaelzern/post-install-debian/main/run_install.sh && chmod +x run_install.sh && ./run_install.sh```
</br>

Alternatively, you can manually download and run the script:
```
git clone https://github.com/michaelzern/post-install-debian.git
cd post-install-debian
chmod +x install.sh
./install.sh
```


## Notes

- Edit packages inside `packages.txt`
- The script now includes optional packages. You can choose to install all optional packages, select them one by one, or skip them during the installation process.
- Sets nano as the default editor
- Runs neofetch at startup

## Better solutions

- Vagrant
- Ansible (agentless)
- Chef
- Puppet
