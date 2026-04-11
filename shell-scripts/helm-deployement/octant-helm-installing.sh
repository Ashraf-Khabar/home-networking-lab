#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Title : Master Start Lab Script     #######
###################################################################

# SRE Best Practice: 'set -e' stops the script IMMEDIATELY 
# if any command or sub-script fails.

set -e

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

kubectl apply -f ./kube-objects/octant/octant-dashboard-admin.yaml

sleep 2

kubectl -n kubernetes-dashboard create token admin-user > octant_token.log

sleep 2