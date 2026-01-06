az login

az account set --subscription "<SUBSCRIPTION_ID>"


az group create \
  --name myRG \
  --location eastus

az aks create \
  --resource-group myRG \
  --name myAKSCluster \
  --node-count 2 \
  --generate-ssh-keys

az aks get-credentials \
  --resource-group myRG \
  --name myAKSCluster \
  --overwrite-existing

kubectl get nodes

kubectl cluster-info
kubectl get namespaces

az group delete --name myRG --yes --no-wait
