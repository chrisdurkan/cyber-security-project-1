#!/bin/bash

# remove temp files
rm -rf /tmp/*
rm -rf /var/tmp/*	

# clear apt cache
apt clean -y

# clear thumbnail cache for sysadmin, instructor, student, and root
rm -rf /home/sysadmin/.cache/thumbnails
rm -rf /home/instructor/.cache/thumbnails
rm -rf /home/student/.cache/thumbnails
rm -rf /root/.cache/thumbnails
