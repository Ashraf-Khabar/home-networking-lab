#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Date : 03/29/2026                   #######
#######            Last updates Date : 03/29/2026           #######
#######              Title : Install k3s clustor            #######
###################################################################

# Debugging mode activated
set -x

echo "Starting K3s (Lightweight Kubernetes) installation..."

# Install K3s using the official script
echo "Downloading and executing the K3s installation script..."
curl -sfL https://get.k3s.io | sh -

# Check if the service is running (using --no-pager to avoid blocking the script)
echo "Checking K3s service status..."
systemctl status k3s --no-pager

# Allow our custom user to use kubectl without sudo
echo "Configuring kubectl access for user administrator_ashraf..."
sudo mkdir -p /home/administrator_ashraf/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/administrator_ashraf/.kube/config
sudo chown -R administrator_ashraf:administrator_ashraf /home/administrator_ashraf/.kube

# Wait a few seconds for the cluster to be fully up
echo "Waiting 10 seconds for the cluster to initialize..."
sleep 10

# Verify the installation by listing the core system pods
echo "Listing pods in the kube-system namespace..."
sudo -u administrator_ashraf kubectl get pods -n kube-system

echo "Phase 2: K3s installation completed successfully!"

# download Helm (v3)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update