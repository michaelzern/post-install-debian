# My Post Install Script Linux
<div id="header" align="center">
  <img src="https://media.giphy.com/media/MCRQ0Nkn4KfeQDdM7N/giphy.gif" width="150"/>
</div>

## Installation

For one step command run
### `curl https://raw.githubusercontent.com/michaelzern/post-install-debian/main/install.sh | bash`

Otherwise
```
curl -o install.sh https://raw.githubusercontent.com/michaelzern/post-install-debian/main/install.sh
less install.sh
sudo chmod +x install.sh
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
