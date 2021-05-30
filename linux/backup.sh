#!/bin/bash

#backup home directory

# create /var/backup if it doesnt exist
mkdir -p /var/backup

# create tar of /home
tar cvf /var/backup/home.tar /home

# rename file with date of backup
backup_date=$(date +'%m-%d-%Y')
mv /var/backup/home.tar /var/backup/home."${backup_date}".tar	

# list all files in /var/backup and save it to /var/backup/file_report.txt
ls -lh /var/backup > /var/backup/file_report.txt

# print free memory and save it to /var/backup/disk_report.txt
free -h > /var/backup/disk_report.txt
