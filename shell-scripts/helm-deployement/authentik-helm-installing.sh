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
# On garde uniquement la clé secrète d'Authentik, on n'a plus besoin de générer un mot de passe DB
AUTHENTIK_SECRET_KEY=$(openssl rand -base64 36)

echo "▶ Déploiement d'Authentik lié à core-postgres..."
# SRE FIX : On désactive la DB interne et on pointe vers le service core-postgres
helm upgrade --install authentik authentik/authentik \
  --namespace authentik \
  --create-namespace \
  --set authentik.secret_key="$AUTHENTIK_SECRET_KEY" \
  --set postgresql.enabled=false \
  --set authentik.postgresql.host="core-postgres.databases.svc.cluster.local" \
  --set authentik.postgresql.name="authentik_db" \
  --set authentik.postgresql.user="labadmin" \
  --set authentik.postgresql.password="labsecret123" \
  --set redis.enabled=true

echo "Authentik a été envoyé au cluster et branché sur la base de données externe !"