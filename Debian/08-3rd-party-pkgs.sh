#!/bin/bash

# ██   ██  █████  ██████  ██████  ██     ██     ██  ██████  ███████     ██   ██ ███████ ██████  ███████ 
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██     ██ ██    ██    ███      ██   ██ ██      ██   ██ ██      
# ███████ ███████ ██████  ██████  ██     ██  █  ██ ██    ██   ███       ███████ █████   ██████  █████   
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██ ███ ██ ██    ██  ███        ██   ██ ██      ██   ██ ██      
# ██   ██ ██   ██ ██   ██ ██   ██ ██      ███ ███   ██████  ███████     ██   ██ ███████ ██   ██ ███████ 
                                                                                                      
# Debian 3rd Party Packages
# Last Updated [04-03-2024]

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Update Repositories
apt update

# Collect list of available scripts for dialog into an array
scripts=(/opt/harrilabstuff/3rd-party/*.sh)

# Create a menu items array
menu_items=()
for i in "${!scripts[@]}"; do
  filename=$(basename "${scripts[$i]}")
  menu_items+=("$i" "$filename")
done

# Run dialog to give options to run other scripts
dialog --title "Select a script to run" \
--menu "Choose one of the following options:" 15 40 4 \
--ok-label "Run" \
--cancel-label "Back" \
"${menu_items[@]}" 2> /tmp/selection

# Check the exit status of dialog
if [ $? -eq 0 ]; then
    # Run the selected script
    bash "${scripts[$(cat /tmp/selection)]}"
else
    # Exit the script if cancel was pressed
    exit 0
fi

# return to the previous dialog after the script has finished
if [ $? -eq 0 ]; then
    bash /opt/harrilabstuff/Debian/07-3rd-party-pkgs.sh
fi

# Clean up
exit 0