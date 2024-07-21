#!/bin/bash

# ██   ██  █████  ██████  ██████  ██     ██     ██  ██████  ███████     ██   ██ ███████ ██████  ███████ 
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██     ██ ██    ██    ███      ██   ██ ██      ██   ██ ██      
# ███████ ███████ ██████  ██████  ██     ██  █  ██ ██    ██   ███       ███████ █████   ██████  █████   
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██ ███ ██ ██    ██  ███        ██   ██ ██      ██   ██ ██      
# ██   ██ ██   ██ ██   ██ ██   ██ ██      ███ ███   ██████  ███████     ██   ██ ███████ ██   ██ ███████ 
                                                                                                      
# Debian Cron Task List
# Last Updated [05-07-2024]

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Collect list of available tasks for dialog into an array
tasks=(/opt/harrilabstuff/crontasks/*.sh)

# Create a menu items array
menu_items=()
for i in "${!tasks[@]}"; do
  filename=$(basename "${tasks[$i]}")
  menu_items+=("$i" "$filename")
done

# Run dialog to give options to run other scripts
dialog --title "Select a script to run" \
--menu "Choose one of the following options:" 15 40 4 \
"${menu_items[@]}" 2> /tmp/selection

# Check the exit status of dialog
if [ $? -eq 0 ]; then
    # Run the selected script
    bash "${tasks[$(cat /tmp/selection)]}"
else
    # Exit the script if cancel was pressed
    exit 0
fi

# return to the previous dialog after the script has finished
if [ $? -eq 0 ]; then
    bash /opt/harrilabstuff/Debian/08-3rd-party-pkgs.sh
fi

# Clean up
exit 0