# Microservices Infrastructure

This repository contains the Kubernetes infrastructure for a microservices application, designed for deployment on Amazon EKS.

## Directory Structure

- `infra/k8s/app/`: Application-specific Kubernetes manifests
- `infra/k8s/db/`: Database-related Kubernetes manifests
- `infra/k8s/ingress.yaml`: Ingress configuration for external access via AWS ALB
- `argocd/`: Argo CD configuration for GitOps deployment
- `skaffold.yaml`: Skaffold configuration for continuous development

## Getting Started

To deploy this infrastructure:

### Option 1: Using Skaffold (Development)

1. Install Skaffold: `curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-darwin-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin`
2. Deploy with Skaffold: `skaffold run`
3. For development mode: `skaffold dev`

### Option 2: Deploying to Amazon EKS

1. Set up an EKS cluster:

```bash
eksctl create cluster --name micro-cluster --region us-east-1 --nodegroup-name standard-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4
```

2. Install AWS Load Balancer Controller:

```bash
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=micro-cluster \
  --set serviceAccount.create=true
```

3. Apply Kubernetes manifests:

```bash
kubectl apply -f infra/k8s/
kubectl apply -f infra/k8s/app/
kubectl apply -f infra/k8s/db/
```

### Option 3: Using Argo CD (GitOps approach)

1. Follow the setup instructions in [argocd/README.md](argocd/README.md)
2. Apply the Argo CD application manifest: `kubectl apply -f argocd/application.yaml`

## Components

- Authentication Service
- MongoDB Database
- Kubernetes ConfigMaps and Secrets
- Service definitions for internal and external communication
- AWS Application Load Balancer Ingress for external access
- Argo CD configuration for GitOps deployments

## Accessing the Application

Once deployed on EKS, the authentication service will be accessible at:

- Internal: `auth-svc.auth.svc.cluster.local:3005`
- External: The URL will be available from the AWS Load Balancer. Get it with:
  ```bash
  kubectl get ingress -n auth
  ```
