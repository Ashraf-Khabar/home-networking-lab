#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Date : 03/28/2026                   #######
#######            Last updates Date : 03/29/2026           #######
#######               Title : run k8s objects               #######
###################################################################

# Debugging mode activated
set -x
set -e

echo "Deploying Kubernetes objects from k8s_pods/ directory..."
kubectl apply -f k8s_pods/

echo "Waiting for Pi-hole to be fully running..."
kubectl rollout status deployment/pihole-deployment

echo "Setting Pi-hole admin password..."
kubectl exec deploy/pihole-deployment -- pihole setpassword Ashraf-password123

echo "Pi-hole deployment is complete and configured."