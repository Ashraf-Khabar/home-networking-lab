#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Date : 03/28/2026                   #######
#######            Last updates Date : 03/29/2026           #######
#######               Title : setup linux tools             #######
###################################################################

# Debugging mode activated
set -x

# Save the current state of installed packages to a file
echo "Saving the list of currently installed packages..."
apt list --installed

# Update the local package index
echo "Updating package lists..."
sudo apt update

# Upgrade all installed packages to their latest versions
echo "Upgrading installed packages..."
sudo apt upgrade -y

# Install required base tools
echo "Installing basic tools (wget, curl, git, ufw)..."
sudo apt install wget curl git ufw -y

# Configure the firewall
echo "Configuring UFW firewall..."

# Allow SSH connection (vital to not get locked out)
sudo ufw allow 22/tcp

# Allow DNS traffic (Pi-hole)
sudo ufw allow 53/tcp
sudo ufw allow 53/udp

# Allow Web traffic (HTTP/HTTPS)
sudo ufw allow 80
sudo ufw allow 443

# Enable the firewall without prompting for confirmation
echo "Enabling UFW..."
sudo ufw --force enable

# Create a user with sudo privileges
echo "Creating user administrator_ashraf with sudo privileges..."
# -m creates the home directory, -s defines the default shell
sudo useradd -m -s /bin/bash administrator_ashraf

# Set a default password for the user (Replace 'ChangeMe123!' with a strong password)
echo "administrator_ashraf:AshrafKhabar123" | sudo chpasswd

# Add the user to the sudo group
echo "Adding user to sudo group..."
sudo usermod -aG sudo administrator_ashraf

echo "Phase 1: Initial setup completed successfully!"