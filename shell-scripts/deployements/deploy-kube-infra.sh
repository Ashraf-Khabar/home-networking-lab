#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Date : 03/28/2026                   #######
#######            Last updates Date : 03/29/2026           #######
#######               Title : run k8s objects               #######
###################################################################

# Env variables for security
source .env

# Debugging mode activated
set -x
set -e

echo "▶ Création du Namespace databases..."
kubectl create namespace databases --dry-run=client -o yaml | kubectl apply -f -

echo "▶ Injection du Secret pour PostgreSQL..."
# On supprime l'ancien secret s'il existe, puis on le recrée avec les valeurs du .env
kubectl delete secret core-db-secrets -n databases --ignore-not-found
kubectl create secret generic core-db-secrets \
  --from-literal=POSTGRES_USER=$DB_USER \
  --from-literal=POSTGRES_PASSWORD=$DB_PASSWORD \
  --from-literal=POSTGRES_DB=$DB_NAME \
  -n databases

echo "▶ Déploiement des objets Kubernetes natifs..."
kubectl apply -f ./kube-objects/databases/
kubectl apply -f ./kube-objects/pihole/
kubectl apply -f ./kube-objects/kuma/
kubectl apply -f ./kube-objects/grafana/