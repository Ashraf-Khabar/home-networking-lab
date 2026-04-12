#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Date : 04/11/2026                   #######
#######            Last updates Date : 03/29/2026           #######
#######               Title : deploy all services           #######
###################################################################

# Debugging mode activated
set -x

# Run kubernetes services by scripts
# FIX SRE : Correction de la faute de frappe sur le dossier 'deployements'
bash shell-scripts/deployements/deploy-kube-infra.sh
bash shell-scripts/helm-deployement/monitoring-helm-installing.sh
bash shell-scripts/helm-deployement/octant-helm-installing.sh
bash shell-scripts/helm-deployement/authentik-helm-installing.sh

sleep 2

bash ./run-services.sh