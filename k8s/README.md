# Kubernetes Deployment on AKS

This directory contains Kubernetes manifests to deploy the Flask-MySQL application on Azure Kubernetes Service (AKS) with a LoadBalancer.

## Prerequisites

1. **Azure CLI** installed and logged in
2. **kubectl** installed
3. **Azure Container Registry (ACR)** created
4. **AKS cluster** created and configured

## Setup Instructions

### 1. Create Azure Resources

```bash
# Set variables
RESOURCE_GROUP="flask-mysql-rg"
LOCATION="eastus"
ACR_NAME="flaskmysqlacr"  # Must be globally unique
AKS_CLUSTER_NAME="flask-mysql-aks"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Azure Container Registry
az acr create --resource-group $RESOURCE_GROUP \
  --name $ACR_NAME \
  --sku Basic

# Create AKS cluster
az aks create \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --node-count 2 \
  --node-vm-size Standard_B2s \
  --enable-managed-identity \
  --attach-acr $ACR_NAME \
  --generate-ssh-keys

# Get AKS credentials
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME
```

### 2. Build and Push Docker Image to ACR

```bash
# Login to ACR
az acr login --name $ACR_NAME

# Build and push the Flask app image
cd ../app
docker build -t $ACR_NAME.azurecr.io/flask-app:latest .
docker push $ACR_NAME.azurecr.io/flask-app:latest
```

### 3. Update Kubernetes Manifests

Update the image name in `flask-deployment.yaml`:
```yaml
image: <your-acr-name>.azurecr.io/flask-app:latest
```

Replace `<your-acr-name>` with your actual ACR name.

### 4. Deploy to AKS

```bash
# Apply deployments
kubectl apply -f deployment.yml

# Apply services
kubectl apply -f service.yml

# Or apply all at once
kubectl apply -f .
```

### 5. Check Deployment Status

```bash
# Check all resources in the namespace
kubectl get all -n flask-mysql-app

# Check pods status
kubectl get pods -n flask-mysql-app

# Check services (get LoadBalancer external IP)
kubectl get svc -n flask-mysql-app

# View pod logs
kubectl logs -f deployment/flask-app -n flask-mysql-app
kubectl logs -f deployment/mysql -n flask-mysql-app
```

### 6. Access the Application

Wait for the LoadBalancer to be provisioned (this may take a few minutes):

```bash
kubectl get svc flask-app -n flask-mysql-app -w
```

Once you see an EXTERNAL-IP assigned, access your application at:
```
http://<EXTERNAL-IP>
```

## Scaling

Scale the Flask application:
```bash
kubectl scale deployment flask-app --replicas=5 -n flask-mysql-app
```

## Monitoring

```bash
# Watch pods
kubectl get pods -n flask-mysql-app -w

# Describe a pod
kubectl describe pod <pod-name> -n flask-mysql-app

# View logs
kubectl logs -f <pod-name> -n flask-mysql-app

# Execute commands in a pod
kubectl exec -it <pod-name> -n flask-mysql-app -- /bin/bash
```

## Cleanup

```bash
# Delete all resources in the namespace
kubectl delete namespace flask-mysql-app

# Or delete the entire resource group (including AKS and ACR)
az group delete --name $RESOURCE_GROUP --yes --no-wait
```

## Architecture

- **Flask App**: 3 replicas behind a LoadBalancer service
- **MySQL**: Single replica with persistent storage (10GB Azure Disk)
- **Storage**: Uses Azure Managed Disks (managed-csi storage class)
- **Secrets**: MySQL credentials stored in Kubernetes secrets
- **Health Checks**: Liveness and readiness probes configured
- **Init Container**: Ensures MySQL is ready before Flask starts

## Storage Classes Available in AKS

- `managed-csi` (default): Azure Disk (Standard_LRS)
- `managed-csi-premium`: Azure Disk (Premium_LRS)
- `azurefile-csi`: Azure Files (for ReadWriteMany)
- `azurefile-csi-premium`: Azure Files Premium

## Cost Optimization

To reduce costs for development/testing:
- Use `Standard_B2s` VM size for nodes (as shown above)
- Set `--node-count 1` for single-node cluster
- Reduce Flask replicas to 1-2
- Use Standard_LRS storage instead of Premium
- Stop the cluster when not in use: `az aks stop --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP`
