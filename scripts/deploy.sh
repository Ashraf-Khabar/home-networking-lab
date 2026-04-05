#!/bin/bash

###################################################################
#######                 Author : Achraf KHABAR              #######
#######                 Date : 03/28/2026                   #######
#######            Last updates Date : 03/29/2026           #######
#######               Title : run k8s objects               #######
###################################################################

# Debugging mode activated
set -x

echo "Deploying Kubernetes objects from k8s_pods/ directory..."
kubectl apply -f k8s_pods/

# WAIT FOR THE POD TO BE READY (Crucial step!)
echo "Waiting for Pi-hole to be fully running..."
kubectl rollout status deployment/pihole-deployment

echo "Listing current services:"
kubectl get services

echo "=========================================================="
echo "SUCCESS! The deployment is ready."
echo "Access the Pi-hole admin interface at: http://localhost:8080/admin"
echo "Password: admin123"
echo "Note: This terminal is now locked by the port-forward process."
echo "Press Ctrl+C to stop the tunnel when you are done."
echo "=========================================================="

# Forward the port 80 to 8080 on the local machine
kubectl port-forward svc/pihole-service 8080:80

# Set the password
exec -it pihole-deployment-566bbc565f-sr9hm -- pihole setpassword 'Ashraf-password123'