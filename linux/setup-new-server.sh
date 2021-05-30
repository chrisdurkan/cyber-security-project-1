#!/bin/bash
# setup script for new server

# chekc for output file
if [ ! "$1" ]
then
    echo "Please specify an output file."
    exit
fi

# exit if not run as root
if [ ! $UID = 0 ]
then
  echo "Please run this script as root."
  exit
fi

# log file header
echo "Log file for general server setup script." >> "$1"
echo "############################" >> "$1"
echo "Log generated on: $(date)" >> "$1"
echo "############################" >> "$1"
echo "" >> "$1"

# list of packages
PACKAGES=(
  'nano'
  'wget'
  'net-tools'
  'python'
  'tripwire'
  'tree'
  'curl'
)

# check for packages and install if not there
for PACKAGE in "${PACKAGES[@]}";
do
  if [ ! $(which $PACKAGE) ];
  then
    apt install -y "$PACKAGE"
  fi
done

# print and log the installs
echo "$(date) Installed packages: ${PACKAGES[*]}" | tee -a "$1"

# create a sysadmin user with no password
useradd sysadmin
chage -d 0 sysadmin

# add sysadmin user to the `sudo` group
usermod -aG sudo sysadmin

# print and log
echo "$(date) Created sys_admin user. Password to be created upon login" | tee -a "$1"

# remove root login shell and lock the root account.
usermod -s /sbin/nologin root
usermod -L root

# print and log
echo "$(date) Disabled root shell. Root user cannot login." | tee -a "$1"

# change perms on sensitive files
chmod 600 /etc/shadow
chmod 600 /etc/gshadow
chmod 644 /etc/group
chmod 644 /etc/passwd

# print and log
echo "$(date) Changed permissions on sensitive /etc files." | tee -a "$1"

# add scripts directory
SCRIPTS=/home/sysadmin/scripts
if [ ! -d "$SCRIPTS" ];
then
  mkdir "$SCRIPTS"
  chown sysadmin:sysadmin "$SCRIPTS"
fi

# add scripts to .bashrc
BASHRC=/home/sysadmin/.bashrc
echo "" >> "$BASHRC"
echo "PATH=$PATH:$SCRIPTS" >> "$BASHRC"
echo "" >> "$BASHRC"

# print and log
echo "$(date) Added ~/scripts directory to sysadmin's PATH." | tee -a "$1"

# Add custom aliases to $BASHRC
cat >> /home/sysadmin/.bashrc << END
Custom Aliases
alias reload='source ~/.bashrc && echo Bash config reloaded'
alias ll='ls -la'
alias lsa='ls -a'
alias cd..='cd ..'
alias docs='cd ~/Documents'
alias dwnlds='cd ~/Downloads'
alias etc='cd /etc'
alias rc='nano ~/.bashrc'
END

# print and log
echo "$(date) Added custom alias collection to sysadmin's bashrc." | tee -a "$1"

# print and log and exit
echo "$(date) Script Finished. Exiting." | tee -a "$1"
exit