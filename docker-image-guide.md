# Docker Image Guide

This guide explains how to build and push your Docker image to Docker Hub for use with Kubernetes.

## Prerequisites

- Docker installed on your local machine
- Docker Hub account (e.g., username 'akkeri')
- Your application code with a valid Dockerfile

## Building and Pushing Your Image

### Step 1: Navigate to your application directory

```bash
cd /Users/akkeri/micro2
```

### Step 2: Build your Docker image

```bash
# Replace 'latest' with a specific version tag in production
docker build -t akkeri/authentication:latest .
```

### Step 3: Login to Docker Hub

```bash
docker login -u akkeri
# Enter your Docker Hub password when prompted
```

### Step 4: Push the image to Docker Hub

```bash
docker push akkeri/authentication:latest
```

### Step 5: Verify the image is available

```bash
docker search akkeri/authentication
```

## Using Your Image in Kubernetes

Once your image is pushed to Docker Hub, update your Kubernetes deployment YAML:

```yaml
containers:
  - name: auth
    image: akkeri/authentication:latest # Your image
```

## Troubleshooting

### Image Not Found Error

If you see `failed to pull and unpack image: not found`, check:

1. Is the image pushed correctly to Docker Hub?
2. Is the image name correct in your deployment YAML?
3. If the image is private, are you using the correct dockerhub-secret?

### Private Images

For private images, ensure your Kubernetes cluster has the correct Docker Hub credentials:

```bash
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=akkeri \
  --docker-password="your-password" \
  --docker-email=your-email@example.com \
  -n auth
```

And make sure your deployment references this secret:

```yaml
spec:
  template:
    spec:
      containers:
        # container definitions
      imagePullSecrets:
        - name: dockerhub-secret
```

## Best Practices

1. **Use Specific Tags**: In production, use specific version tags instead of 'latest'
2. **Use Private Images**: For production workloads, use private repositories
3. **Automate Image Building**: Set up CI/CD to automatically build and push images
