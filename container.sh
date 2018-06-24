#!/bin/bash -x
# adapted from https://gist.github.com/Zate/a6be5e5528f177b2e3e2e193b91e350c
# but made more generic

#if [ "x$1" = x ]; then
#  echo "$0 x x"
#  exit
#fi

REMOTE_ROOT="https://raw.githubusercontent.com/dsmk/chromeos-linux/master"
CONTAINER_NAME="test"
if [ "x$1" != x ]; then
  CONTAINER_NAME="$1"
fi
CHROMEOS_USER="dsmking"
if [ "x$2" != x ]; then
  CHROMEOS_USER="$2"
fi
SOFTWARE="vscode docker"
if [ "x$3" != x ]; then
  SOFTWARE="$3"
fi
CMD="code ."

run_container.sh --container_name "$CONTAINER_NAME" --user "$CHROMEOS_USER"
sleep 3
# make certain that we are privleged (and rebooted) prior to anything else 
# this is necessary for docker to work
# this comes from https://github.com/lxc/lxd/issues/2255
#
lxc config set "$CONTAINER_NAME" security.nesting true
lxc config set "$CONTAINER_NAME" security.privileged true
lxc stop --force "$CONTAINER_NAME"
lxc start "$CONTAINER_NAME"
sleep 1
# make certain we are up to date and have the latest packages
lxc exec "$CONTAINER_NAME" -- sh -c "apt-get update && sleep 1 && apt-get upgrade -y && sleep 1 && apt-get install wget curl -y"
sleep 1
for sw in $SOFTWARE ; do
  lxc exec "$CONTAINER_NAME" -- sudo -u "$CHROMEOS_USER" bash -c "cd ~ && pwd && curl '${REMOTE_ROOT}/software/get_${sw}.sh' -o 'get_${sw}.sh' && chmod +x 'get_${sw}.sh' && './get_${sw}.sh' '$CHROMEOS_USER' "
  sleep 1
done

# now run a command as the user if requested
if [ "x$CMD" != x ]; then
  lxc exec "$CONTAINER_NAME" -- sudo su -l "$CHROMEOS_USER" -c "cd ~ && $CMD"
fi

#lxc exec test -- sudo su -l dsmking -c 'cd ~ && code .'


#lxc exec test -- sudo -u dsmking bash -c 'cd ~ && pwd && curl https://gist.githubusercontent.com/Zate/b3c8e18cbb2bbac2976d79525d95f893/raw/acbe81fe161ec194ab9eb30f1bf17f1f79919a45/get_go.sh -o get_go.sh && chmod +x get_go.sh && ./get_go.sh'
#sleep 1
#lxc exec test -- sudo -u dsmking bash -c 'cd ~ && pwd && curl https://gist.githubusercontent.com/dsmk/5331dfc4d14e09659ebfc02a6476f9b1/raw/6b75ad137430d73574783a8cfd58e68c53d34c4d/get_vscode.sh -o get_vscode.sh && chmod +x get_vscode.sh && ./get_vscode.sh'
#sleep 1
#lxc exec test -- sudo -u dsmking bash -c 'cd ~ && pwd && curl https://gist.githubusercontent.com/dsmk/5331dfc4d14e09659ebfc02a6476f9b1/raw/6b75ad137430d73574783a8cfd58e68c53d34c4d/get_docker.sh -o get_docker.sh && chmod +x get_docker.sh && ./get_docker.sh'
#sleep 1
#lxc exec test -- sudo su -l dsmking -c 'cd ~ && code .'
