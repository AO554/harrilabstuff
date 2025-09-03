#!/bin/bash

# ██   ██  █████  ██████  ██████  ██     ██     ██  ██████  ███████     ██   ██ ███████ ██████  ███████ 
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██     ██ ██    ██    ███      ██   ██ ██      ██   ██ ██      
# ███████ ███████ ██████  ██████  ██     ██  █  ██ ██    ██   ███       ███████ █████   ██████  █████   
# ██   ██ ██   ██ ██   ██ ██   ██ ██     ██ ███ ██ ██    ██  ███        ██   ██ ██      ██   ██ ██      
# ██   ██ ██   ██ ██   ██ ██   ██ ██      ███ ███   ██████  ███████     ██   ██ ███████ ██   ██ ███████ 
                                                                                                      
# Debian Base Packages
# Last Updated [04-09-2025]

# Check if the script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Configure Global Locales to en_GB.UTF-8
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LANGUAGE=en_GB.UTF-8

# Generate locales
sudo locale-gen $LANG
# Additional locale-gen for US
sudo locale-gen en_US.UTF-8

# Update and upgrade
apt update && apt upgrade -y

# Set default locale to $LANG
echo "locales locales/default_environment_locale select $LANG" | sudo debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect $LANG UTF-8" | sudo debconf-set-selections
sudo dpkg-reconfigure --frontend=noninteractive locales

# Install base packages
apt install -y \
    sudo \
    curl \
    wget \
    nload \
    vnstat \
    net-tools \
    dnsutils \
    build-essential \
    fail2ban \
    gnupg \
    iptables \
    python3 \
    python3-pip \
    axel \
    bpytop \
    git \
    zsh \
    fastfetch \
    htop \
    tmux \
    tmate \
    nano \
    unzip \
    zip \
    p7zip-full \
    bzip2 \
    ncdu \
    dialog \
    ruby \ 
    lsof \
    auditd \
    apt-transport-https \
    ca-certificates \


# Clean up
apt autoremove -y
apt autoclean -y
apt clean -y

# Done
echo "Base packages installed successfully"
