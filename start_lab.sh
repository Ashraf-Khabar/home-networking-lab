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

echo -e "\n ▶ STEP 1: Initial setup and K3s installation..."
bash scripts/setup.sh
bash scripts/install_k3s.sh

echo -e "\n ▶ STEP 2: Deploying Pi-hole (DNS Sinkhole)..."
bash scripts/deploy.sh

echo -e "\n ▶ STEP 3: Preparing Helm for package management..."
bash scripts/get_helm.sh

echo -e "\n ▶ STEP 4: Deploying Observability Stack (Prometheus & Grafana)..."
# Adding the official Prometheus community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# SRE FIX: Using 'upgrade --install' and setting a custom Grafana password
helm upgrade --install mon-monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set grafana.adminPassword="administrateur"

echo -e "\n ▶ STEP 5: Deploying NGINX Ingress Controller & Routing Rules..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# SRE FIX: Using 'upgrade --install' here as well
helm upgrade --install mon-receptionniste ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

# Apply the routing rules for both Pi-hole and Grafana (if any)
kubectl apply -f k8s_pods/

echo "=========================================================="
echo "SUCCESS! The infrastructure is fully deployed."
echo "=========================================================="

# SRE Automation: Kill any existing port-forward processes to avoid port conflicts
killall kubectl 2>/dev/null || true

echo "Opening background network tunnels..."

# NGINX Ingress tunnel (Background)
nohup kubectl port-forward -n ingress-nginx svc/mon-receptionniste-ingress-nginx-controller 8080:80 > /dev/null 2>&1 &

# Grafana tunnel (Background)
nohup kubectl port-forward svc/mon-monitoring-grafana 3000:80 --namespace monitoring > /dev/null 2>&1 &

# Wait 2 seconds to ensure tunnels are established
sleep 2

echo "=========================================================="
echo "YOUR DASHBOARDS ARE READY:"
echo "Pi-hole (Via Ingress) : http://pihole.lab:8080/admin"
echo "Grafana Direct        : http://grafana.lab:3000/dashboards"
echo "=========================================================="