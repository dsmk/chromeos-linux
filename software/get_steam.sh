#!/bin/sh
#
# $1 = CHROMEOS_USER
#
# Simple install of Steam for Linux based on
# https://www.reddit.com/r/Crostini/wiki/howto/install-steam
#
if [ "x$1" = x ]; then
  echo "user needs to be provided"
  exit
fi

sudo usermod -a -G video,audio "$1"

# Modify the sources to have contrib and non-free in the list but only do it once
#
if [ -f /etc/apt/sources.list.bak ]; then
  echo "Skipping sources.list edit as it is already done"
else
  sudo sed -i.bak 's/ main$/ main contrib non-free/' /etc/apt/sources.list
fi

# Add i386 hardware
sudo dpkg --add-architecture i386

sudo apt-get update

#Install the following packages, and accept all of the terms as prompted:
sudo apt-get install -y libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libglapi-mesa:i386 steam

#Launch steam and enjoy! It will download and install updates upon first run.