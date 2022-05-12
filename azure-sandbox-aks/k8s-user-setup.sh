#!/usr/bin/env bash

# COnnect to the cluster as admin before running the script
# az aks get-credentials --resource-group azure-sandbox-aks-rg --name azure-sandbox-aks-cluster

echo "Creating dev namespace"
kubectl create namespace dev

echo "Getting object id of the aks-dev group"
GROUP_OBJECT_ID=$(az ad group show --group aks-dev --query objectId -o tsv)

echo "Creating role and role bindings in the dev workspace"
cat <<EOF | kubectl apply -f -
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dev-user-full-access
  namespace: dev
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources:
  - jobs
  - cronjobs
  verbs: ["*"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dev-user-access
  namespace: dev
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: dev-user-full-access
subjects:
- kind: Group
  namespace: dev
  name: $GROUP_OBJECT_ID
EOF
