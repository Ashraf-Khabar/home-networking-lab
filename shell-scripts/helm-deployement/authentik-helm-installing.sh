#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######           Title : Install and Deploy Authentik      #######
###################################################################

set -x
set -e

echo "▶ Ajout du catalogue Authentik..."
helm repo add authentik https://charts.goauthentik.io
helm repo update

echo "▶ Génération des mots de passe internes de sécurité..."
# Génération de clés aléatoires fortes à la volée (Pratique SRE)
AUTHENTIK_SECRET_KEY=$(openssl rand -base64 36)
AUTHENTIK_POSTGRES_PASSWORD=$(openssl rand -base64 16)

echo "▶ Déploiement d'Authentik..."
# On déploie Authentik avec ses propres petites bases de données intégrées (Redis et Postgres)
helm upgrade --install authentik authentik/authentik \
  --namespace authentik \
  --create-namespace \
  --set authentik.secret_key="$AUTHENTIK_SECRET_KEY" \
  --set postgresql.enabled=true \
  --set postgresql.auth.password="$AUTHENTIK_POSTGRES_PASSWORD" \
  --set redis.enabled=true

echo " Authentik a été envoyé au cluster !"