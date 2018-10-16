#!/bin/sh -x 
# 
# Simple script to set up Crostini linux environment.  It consists of:
#
# 0. Make certain we have our local timezone
# 1. Copy the ssh keys locally
# 2. Set up the AWS credentials
# 3. Git clone the lib area
# 4. Git clone the chromeos area
# 5. Run select set up scripts from that area
#
REMOTE_LOCATION="dsmk@hagrid.rexden.us"

# ####
# 0. Make certain we have our local timezone
#
sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# ####
# 1. Copy the ssh keys locally
#
if [ ! -d "${HOME}/.ssh" ]; then
  mkdir "${HOME}/.ssh"
  chmod 0700 "${HOME}/.ssh"
fi
for file in id_rsa id_rsa.pub ; do
  fullfilename="${HOME}/.ssh/$file"
  if [ ! -r "$fullfilename" ]; then
    scp "${REMOTE_LOCATION}:.ssh/$file" "$fullfilename"
  fi
done

# ####
# If the first parameter is not _in_ssh_ then we rerun the command inside the ssh-agent
#
if [ "x$1" != "x_in_ssh_" ]; then
  ssh-agent "$0" "_in_ssh_"
  exit
fi

# ####
# The rest of this is inside the ssh-agent
#

# First, add our local ssh keys
ssh-add "${HOME}/.ssh/id_rsa"

# ####
# make certain we have our basic packages
#
for pkg in python ansible awscli rsync ; do
  if dpkg -l "$pkg" > /dev/null ; then
    echo "*** $pkg already installed"
  else
    sudo apt-get install -y $pkg
  fi
done

# ####
# 1. (reprise) Copy the rest of the ssh keys locally
#
rsync -av "${REMOTE_LOCATION}:.ssh/keys/" "${HOME}/.ssh/keys/"

# ####
# 2. Set up the AWS credentials
#
rsync -av "${REMOTE_LOCATION}:.aws/" "${HOME}/.aws"

# ensure_git_repo name directory gituri
ensure_git_repo () {
  if [ -d "$2/$1" ]; then
    # update
    cd "$2/$1"
    git pull
  else
    # clone
    cd "$2"
    git clone "$3"
  fi

}

# ####
# 3. Git clone the lib area if it does not already exist (otherwise pull it to make certain it is up to date)
#
ensure_git_repo lib "$HOME" "git@bitbucket.org:dsmking/lib.git"

# ####
# Install the dot files into place
#
(cd "${HOME}/lib"; python install.py )

# ####
# 4. Git clone the chromeos area
#
if [ ! -d "${HOME}/projects" ]; then
  mkdir "${HOME}/projects"
  chmod 0700 "${HOME}/projects"
fi
ensure_git_repo chromeos-linux "${HOME}/projects" git@github.com:dsmk/chromeos-linux.git

# ####
# 5. Run select set up scripts from that area
#
SW="vscode docker misc"

for sw in $SW ; do
  echo "=================================================================="
  echo "=================================================================="
  echo "##### $sw"
  echo "=================================================================="
  "${HOME}/projects/chromeos-linux/software/get_$sw.sh" "$USER"
done

