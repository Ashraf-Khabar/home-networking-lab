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

# SRE FIX : Génération à la volée d'un fichier custom values.yaml pour intégrer le SSO Keycloak
cat <<EOF > grafana-sso-values.yaml
grafana:
  adminPassword: ${GRAFANA_ADMIN_PASSWORD}
  grafana.ini:
    server:
      root_url: http://grafana.lab:8080
    auth.generic_oauth:
      enabled: true
      name: Connexion SSO (Keycloak)
      allow_sign_up: true
      client_id: grafana
      # Le secret devra être récupéré dans Keycloak plus tard. On met un placeholder pour l'instant.
      client_secret: \${KEYCLOAK_GRAFANA_SECRET} 
      scopes: openid profile email roles
      auth_url: http://localhost:8081/realms/homelab/protocol/openid-connect/auth
      # Les URLs internes utilisent le DNS de Kubernetes pour que Grafana parle à Keycloak sans sortir de l'usine
      token_url: http://my-keycloak.keycloak.svc.cluster.local:80/realms/homelab/protocol/openid-connect/token
      api_url: http://my-keycloak.keycloak.svc.cluster.local:80/realms/homelab/protocol/openid-connect/userinfo
      role_attribute_path: contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || 'Viewer'
EOF

# SRE FIX: Utilisation de '-f grafana-sso-values.yaml' pour injecter toutes nos préférences
# Dans monitoring-helm-installing.sh
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