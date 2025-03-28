# Amazon EKS Deployment Guide

This guide provides detailed instructions for deploying the microservices infrastructure to Amazon EKS.

## Prerequisites

- AWS CLI configured with appropriate permissions
- kubectl installed
- eksctl installed
- helm installed

## Setting up the EKS Cluster

1. Create an EKS cluster:

```bash
eksctl create cluster \
  --name micro-cluster \
  --region us-east-1 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed
```

2. Configure kubectl to use your EKS cluster:

```bash
aws eks update-kubeconfig --name micro-cluster --region us-east-1
```

## Installing the AWS Load Balancer Controller

The AWS Load Balancer Controller is required for the ALB Ingress to work properly:

1. Create an IAM policy for the AWS Load Balancer Controller:

```bash
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```

2. Create an IAM role and service account for the controller:

```bash
eksctl create iamserviceaccount \
  --cluster=micro-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::<AWS_ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```

3. Install the AWS Load Balancer Controller using Helm:

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=micro-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

## Deploying the Infrastructure

1. Create the namespace:

```bash
kubectl apply -f infra/k8s/ns.yaml
```

2. Deploy the MongoDB database:

```bash
kubectl apply -f infra/k8s/db/
```

3. Deploy the authentication service:

```bash
kubectl apply -f infra/k8s/app/
```

4. Deploy the Ingress:

```bash
kubectl apply -f infra/k8s/ingress.yaml
```

## Verifying the Deployment

1. Check that all deployments are running:

```bash
kubectl get deployments -n auth
```

2. Check the services:

```bash
kubectl get services -n auth
```

3. Check the Ingress and get the ALB URL:

```bash
kubectl get ingress -n auth
```

The ADDRESS field in the Ingress output will show the ALB domain name that you can use to access your service.

## Accessing the Application

Once the ALB provisioning is complete (which may take a few minutes), your authentication service will be accessible at:

```
http://<ALB_ADDRESS>/api/auth/
```

## Clean Up

To delete all resources and avoid incurring AWS charges:

```bash
kubectl delete -f infra/k8s/
eksctl delete cluster --name micro-cluster --region us-east-1
```
