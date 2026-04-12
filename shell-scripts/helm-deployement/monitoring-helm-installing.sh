#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Title : Master Start Lab Script     #######
###################################################################

# SRE Best Practice: 'set -e' stops the script IMMEDIATELY 
# if any command or sub-script fails.
source .env

set -e

echo "=========================================================="
echo "STARTING HOME LAB DEPLOYMENT"
echo "=========================================================="

echo -e "\n ▶ STEP 4: Deploying Observability Stack (Prometheus & Grafana)..."
# Adding the official Prometheus community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# SRE FIX: Utilisation de '-f grafana-sso-values.yaml' pour injecter toutes nos préférences
helm upgrade --install mon-monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f grafana-sso-values.yaml \
  --set grafana.adminPassword=$GRAFANA_ADMIN_PASSWORD

echo -e "\n ▶ STEP 5: Deploying NGINX Ingress Controller & Routing Rules..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# SRE FIX: Using 'upgrade --install' here as well
helm upgrade --install mon-receptionniste ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

# Apply the routing rules for both Pi-hole and Grafana (if any)
kubectl apply -f ./kube-objects/

echo "=========================================================="
echo "SUCCESS! The infrastructure is fully deployed."
echo "=========================================================="