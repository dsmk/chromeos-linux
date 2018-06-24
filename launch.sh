#!/bin/sh
# Simple script to get a container and then put 
# ssh key into it
#
REMOTE_ROOT="https://raw.githubusercontent.com/dsmk/chromeos-linux/master"
CONTAINER="test"
MAIN_CONTAINER="penguin"
CHROMEOS_USER="dsmking"

# create the container
if [ "x${REMOTE_ROOT}" != x ]; then
  curl "${REMOTE_ROOT}/container.sh" "/tmp/container.sh"
else
  lxc file pull "${MAIN_CONTAINER}/home/${CHROMEOS_USER}/projects/chromeos-linux/container.sh" /tmp/container.sh
fi
/tmp/container.sh "$CONTAINER" "$CHROMEOS_USER"

# now we pull the id_rsa from penguin container and putting it
# in the destination container
lxc file pull "${MAIN_CONTAINER}/home/${CHROMEOS_USER}/.ssh/id_rsa" /tmp/id_rsa
lxc file push /tmp/id_rsa "${CONTAINER}/home/${CHROMEOS_USER}/.ssh/id_rsa"
