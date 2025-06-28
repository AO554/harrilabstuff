#!/bin/bash

# ██   ██  █████  ██████  ██████  ██     ██     ██  ██████  ███████     ██   ██ ███████ ██████  ███████ 
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██     ██ ██    ██    ███      ██   ██ ██      ██   ██ ██      
# ███████ ███████ ██████  ██████  ██     ██  █  ██ ██    ██   ███       ███████ █████   ██████  █████   
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██ ███ ██ ██    ██  ███        ██   ██ ██      ██   ██ ██      
# ██   ██ ██   ██ ██   ██ ██   ██ ██      ███ ███   ██████  ███████     ██   ██ ███████ ██   ██ ███████ 

# Automatic Updates Cron Task
# Last Updated [28-06-2025]

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

## Rewrite
# Following Debian Docs for Unattended Upgrades
# https://wiki.debian.org/UnattendedUpgrades

# Install unattended-upgrades if not already installed
if ! command -v unattended-upgrades &> /dev/null; then
    echo "Installing unattended-upgrades..."
    apt-get update
    apt-get install -y unattended-upgrades
else
    echo "unattended-upgrades is already installed."
fi

# Enable unattended-upgrades
echo "Enabling unattended-upgrades..."
dpkg-reconfigure --priority=high unattended-upgrades

# Configure automatic updates
echo "Configuring automatic updates..."
cat <<EOL > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOL

# Configure unattended-upgrades
cat <<EOL > /etc/apt/apt.conf.d/50unattended-upgrades
// Automatically upgrade packages from these origins
Unattended-Upgrade::Origins-Pattern {
    "o=Debian,a=stable";
    "o=Debian,a=stable-updates";
    "o=Debian,a=proposed-updates";
    "o=Debian,a=security";
};

// Automatically upgrade packages from these components
Unattended-Upgrade::Allowed-Origins {
    "o=Debian,a=stable";
    "o=Debian,a=stable-updates";
    "o=Debian,a=proposed-updates";
    "o=Debian,a=security";
};

// Automatically remove unused dependencies after upgrades
Unattended-Upgrade::Remove-Unused-Dependencies "true";
// Automatically reboot if required
Unattended-Upgrade::Automatic-Reboot "true";

// Set the automatic reboot time
Unattended-Upgrade::Automatic-Reboot-Time "02:00";

// Send email notifications on upgrade
Unattended-Upgrade::Mail "root";
Unattended-Upgrade::MailOnlyOnError "true";

// Log file for unattended-upgrades
Unattended-Upgrade::LogDir "/var/log/unattended-upgrades";

// Enable automatic updates for specific packages
Unattended-Upgrade::Package-Blacklist {
    // Add packages to this list to prevent them from being automatically upgraded
};

// Enable automatic updates for specific packages
Unattended-Upgrade::Automatic-Reboot-WithUsers "true";
Unattended-Upgrade::Automatic-Reboot-WithUsers-List {
    "root";
};
EOL

# Restart unattended-upgrades service
echo "Restarting unattended-upgrades service..."
systemctl restart unattended-upgrades

# Enable unattended-upgrades service to start on boot
echo "Enabling unattended-upgrades service to start on boot..."
systemctl enable unattended-upgrades
echo ""
systemctl status unattended-upgrades

# Final message
echo "Automatic updates have been configured successfully."

# Done
exit 0
