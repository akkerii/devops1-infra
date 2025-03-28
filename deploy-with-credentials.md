# Deploying with DockerHub Credentials

This guide explains how to deploy the authentication service with DockerHub credentials.

## Setting up DockerHub Secret

When deploying to EKS or any Kubernetes cluster, you need to create a secret containing your DockerHub credentials so that the cluster can pull your private images.

### Option 1: Using kubectl command (Recommended for Production)

```bash
# Replace with your actual DockerHub email
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=akkeri \
  --docker-password="your-password" \
  --docker-email=your-email@example.com \
  -n auth
```

### Option 2: Using the provided script (For Development)

```bash
# Make the script executable
chmod +x create-docker-secret.sh

# Run the script with your DockerHub credentials
./create-docker-secret.sh akkeri "your-password"

# Apply the generated secret
kubectl apply -f infra/k8s/dockerhub-secret-final.yaml
```

## Deploying the Application

After setting up the DockerHub secret, you can deploy the application:

1. Make sure the secret is created in the 'auth' namespace
2. Deploy the application using Skaffold or Argo CD:

```bash
# Option 1: Deploy with Skaffold
skaffold run

# Option 2: Deploy with Argo CD
kubectl apply -f argocd/application-fixed.yaml
```

## Verifying the Deployment

Check if the pods are running and can pull the image successfully:

```bash
kubectl get pods -n auth
```

If the pods are in "ImagePullBackOff" state, check the pod description for errors:

```bash
kubectl describe pod <pod-name> -n auth
```

## Security Notes

- Never commit your actual DockerHub password to Git
- Use environment variables or secure secret management tools in production
- Consider using AWS ECR instead of DockerHub for tighter integration with EKS 