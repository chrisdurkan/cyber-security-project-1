#!/bin/bash

# update apt
# apt update -y

# upgrade installed packages
# apt upgrade -y

# install new packages, uninstall any old packages that must be removed to install the new ones
# apt full-upgrade -y

# remove unused packages and their config files
# apt autoremove --purge -y

# perform all update with a single line
apt update -y && apt upgrade -y && apt full-upgrade -y && apt-get autoremove --purge -y
