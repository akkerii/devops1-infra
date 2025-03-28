#!/bin/bash

echo "Checking all resources in the auth namespace..."
echo "================================================"

echo -e "\nNamespaces:"
kubectl get namespaces | grep auth

echo -e "\nAll resources in auth namespace:"
kubectl get all -n auth

echo -e "\nDeployments:"
kubectl get deployments -n auth

echo -e "\nServices:"
kubectl get services -n auth

echo -e "\nPods:"
kubectl get pods -n auth

echo -e "\nSecrets:"
kubectl get secrets -n auth

echo -e "\nConfigMaps:"
kubectl get configmaps -n auth

echo -e "\nIngresses:"
kubectl get ingress -n auth

echo -e "\nDetailed status of auth-dep deployment (if exists):"
kubectl describe deployment auth-dep -n auth 2>/dev/null || echo "auth-dep deployment not found"

echo -e "\nDetailed status of db-auth deployment (if exists):"
kubectl describe deployment db-auth -n auth 2>/dev/null || echo "db-auth deployment not found"

echo -e "\nArgo CD Application status:"
kubectl get applications -n argocd -o wide 