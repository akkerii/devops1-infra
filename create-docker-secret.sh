#!/bin/bash

# Check if required parameters are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <dockerhub-username> <dockerhub-password>"
  exit 1
fi

DOCKERHUB_USERNAME=$1
DOCKERHUB_PASSWORD=$2

# Create the docker config JSON
DOCKER_CONFIG="{\"auths\":{\"https://index.docker.io/v1/\":{\"username\":\"$DOCKERHUB_USERNAME\",\"password\":\"$DOCKERHUB_PASSWORD\",\"auth\":\"$(echo -n $DOCKERHUB_USERNAME:$DOCKERHUB_PASSWORD | base64)\"}}}"

# Base64 encode the entire config
BASE64_DOCKER_CONFIG=$(echo -n $DOCKER_CONFIG | base64)

# Replace the placeholder in the secret file
sed "s/\${BASE64_DOCKER_CONFIG}/$BASE64_DOCKER_CONFIG/g" infra/k8s/dockerhub-secret.yaml > infra/k8s/dockerhub-secret-final.yaml

echo "Secret file has been created at infra/k8s/dockerhub-secret-final.yaml"
echo "You can now apply it with: kubectl apply -f infra/k8s/dockerhub-secret-final.yaml" 