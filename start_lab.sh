#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Title : Master Start Lab Script     #######
###################################################################

# SRE Best Practice: 'set -e' stops the script IMMEDIATELY 
# if any command or sub-script fails.
set -e

echo "=========================================================="
echo "STARTING HOME LAB DEPLOYMENT (K3s + Pi-hole + SRE)"
echo "=========================================================="

echo -e "\n STEP 1: Initial setup and K3s installation..."
# Call the scripts from the new 'scripts' directory
bash scripts/setup.sh
bash scripts/install_k3s.sh

echo -e "\n STEP 2: Deploying Pi-hole (DNS Sinkhole)..."
bash scripts/deploy.sh

echo -e "\n STEP 3: Preparing Helm for package management..."
bash scripts/get_helm.sh

echo -e "\n STEP 4: Deploying Observability Stack (Prometheus & Grafana)..."
# Adding the official Prometheus community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Installing the kube-prometheus-stack in the 'monitoring' namespace
helm install mon-monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

echo "=========================================================="
echo " SUCCESS! The infrastructure is fully deployed."
echo "=========================================================="
echo "Access Reminders:"
echo " Pi-hole Admin : kubectl port-forward svc/pihole-service 8080:80"
echo " Grafana UI    : kubectl port-forward svc/mon-monitoring-grafana 3000:80 --namespace monitoring"