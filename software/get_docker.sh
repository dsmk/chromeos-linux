#!/bin/bash
# $1 - chromeos user
#
set -euf -o pipefail

curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh


# make it so the chromeos user can do docker commands without becoming root
if [ "x$1" != x ]; then
  sudo usermod -aG docker "$1"
fi
