#!/bin/bash

set -euf -o pipefail

curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh


# make it so the chromeos user can do docker commands without becoming root
if [ "x$CHROME_USER" != x ]; then
  sudo usermod -aG docker "$CHROME_USER"
fi
