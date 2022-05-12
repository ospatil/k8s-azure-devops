#!/usr/bin/env bash

echo "Getting AKS cluster ID"
AKS_ID=$(az aks show \
    --resource-group azure-sandbox-aks-rg \
    --name azure-sandbox-aks-cluster \
    --query id -o tsv)

echo "Creating a aks-dev group in Azure AD"
GROUP_ID=$(az ad group create --display-name aks-dev --mail-nickname aks-dev --query objectId -o tsv)

echo "Granting Cluster User role to the AD group"
az role assignment create \
  --assignee $GROUP_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID

echo "Please enter the User Principal Name for application developers: " && read AAD_DEV_UPN
echo "Please enter the secure password for application developers: " && read AAD_DEV_PW

echo "Creating user in Azure AD"
AKSDEV_ID=$(az ad user create \
  --display-name "AKS Dev" \
  --user-principal-name $AAD_DEV_UPN \
  --password $AAD_DEV_PW \
  --query objectId -o tsv)

echo "Adding user to the aks-dev group"
az ad group member add --group aks-dev --member-id $AKSDEV_ID
