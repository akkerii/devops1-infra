# Microservices Infrastructure

This repository contains the Kubernetes infrastructure for a microservices application.

## Directory Structure

- `infra/k8s/app/`: Application-specific Kubernetes manifests
- `infra/k8s/db/`: Database-related Kubernetes manifests
- `skaffold.yaml`: Skaffold configuration for continuous development

## Getting Started

To deploy this infrastructure:

1. Install Skaffold: `curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-darwin-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin`
2. Deploy with Skaffold: `skaffold run`
3. For development mode: `skaffold dev`

## Components

- Authentication Service
- MongoDB Database
- Kubernetes ConfigMaps and Secrets
- Service definitions for internal and external communication
