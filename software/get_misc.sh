#! /bin/bash
# misc items for our base system
# tmux
# ansible
#

set -euf -o pipefail

sudo apt-get install tmux -y
sudo apt-get install ansible -y
sudo apt-get install packer -y
