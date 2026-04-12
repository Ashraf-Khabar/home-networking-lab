#!/bin/bash
# Chargement des variables (DB_USER, DB_PASSWORD, AUTHENTIK_SECRET_KEY, etc.)
source .env 
set -e

echo "▶ Déploiement d'Authentik avec mot de passe Admin Bootstrap..."

helm upgrade --install authentik authentik/authentik \
  --namespace authentik \
  --create-namespace \
  --set authentik.secret_key="$AUTHENTIK_SECRET_KEY" \
  --set authentik.bootstrap_password="$AUTHENTIK_BOOTSTRAP_PASSWORD" \
  --set postgresql.enabled=false \
  --set authentik.postgresql.host="core-postgres.databases.svc.cluster.local" \
  --set authentik.postgresql.name="$DB_NAME" \
  --set authentik.postgresql.user="$DB_USER" \
  --set authentik.postgresql.password="$DB_PASSWORD" \
  --set redis.enabled=true

echo "▶ Authentik déployé. Utilisateur : akadmin / Mot de passe : celui du .env"