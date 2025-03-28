# Argo CD Setup Guide

This guide provides instructions for setting up Argo CD to manage this microservices infrastructure.

## Installation

1. Install Argo CD in your Kubernetes cluster:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

2. Access the Argo CD API server:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

3. Get the initial admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

4. Login with username: `admin` and the password from the previous step.

## Deploying the Application

Apply the application manifest to deploy the microservices infrastructure:

```bash
# Use the fixed application manifest if you encounter any YAML syntax errors
kubectl apply -f argocd/application-fixed.yaml
```

If you encounter a YAML syntax error with the original file, use the alternative file:

```bash
kubectl apply -f argocd/application-fixed.yaml
```

## Troubleshooting YAML Syntax Errors

If you encounter a "mapping values are not allowed in this context" error:

1. Ensure you're using the latest version from the repository
2. Use spaces (not tabs) for indentation
3. Try the alternative application-fixed.yaml file
4. Validate your YAML syntax with a tool like yamllint

## Synchronization

The application is configured with automated synchronization. Argo CD will automatically deploy changes when they are pushed to the repository.

You can also manually sync from the Argo CD UI or with the command:

```bash
argocd app sync micro-services
```

## Monitoring

Monitor the application status through the Argo CD UI or with:

```bash
argocd app get micro-services
``` 