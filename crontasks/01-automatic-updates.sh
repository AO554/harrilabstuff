#!/bin/bash

# ██   ██  █████  ██████  ██████  ██     ██     ██  ██████  ███████     ██   ██ ███████ ██████  ███████ 
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██     ██ ██    ██    ███      ██   ██ ██      ██   ██ ██      
# ███████ ███████ ██████  ██████  ██     ██  █  ██ ██    ██   ███       ███████ █████   ██████  █████   
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██ ███ ██ ██    ██  ███        ██   ██ ██      ██   ██ ██      
# ██   ██ ██   ██ ██   ██ ██   ██ ██      ███ ███   ██████  ███████     ██   ██ ███████ ██   ██ ███████ 

# Automatic Updates Cron Task
# Last Updated [05-07-2024]

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Add crontask to run automatic updates via apt every Saturday at 1:00 AM
echo "0 1 * * 6 apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get autoclean -y && if [ -f /var/run/reboot-required ]; then echo 'Please reboot your system to apply kernel updates' | mail -s 'Reboot Required' root; fi" > /etc/cron.d/automatic-updates

# Notify on completion
echo -e "\nAutomatic updates cron task added to run every Saturday at 1:00 AM\n"

# Clean up
exit 0
