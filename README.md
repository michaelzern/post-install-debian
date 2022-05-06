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

Edit packages inside install.sh to add or remove <br />
Sets nano as editor <br />
Runs screenfetch at startup <br />

## Better solutions
vagrant <br />
ansible (agentless) <br />
chef <br />
puppet <br />
