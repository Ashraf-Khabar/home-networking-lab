#!/bin/bash
source .env
set -e

echo "=========================================================="
echo "STARTING OBSERVABILITY DEPLOYMENT"
echo "=========================================================="

# Création du namespace si inexistant
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Installation avec le fichier de config SSO
helm upgrade --install mon-monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f SSO-configuration/grafana-sso-values.yaml \
  --set grafana.adminPassword=$GRAFANA_ADMIN_PASSWORD

echo "▶ Observability Stack deployed successfully."