#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######           Title : install and deploy keyloak        #######
###################################################################

# SRE Best Practice: 'set -e' stops the script IMMEDIATELY 
# if any command or sub-script fails.

set -x
set -e

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

kubectl create namespace keycloak

helm install my-keycloak bitnami/keycloak \
  --namespace keycloak \
  --set auth.adminUser=admin \
  --set auth.adminPassword=supersecret \
  --set proxy=edge
