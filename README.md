# Kubernetes, Azure, Terraform and DevOps Sandbox

## Base setup

* Install Azure CLI: `brew install azure-cli`.
* Install terraform: `brew install terraform`.

## Initial Steps

* Login into Azure using the command `az login`.
  The subscription list can be obtained using `az account list`.
  Default subscription can be set using `az account set --subscription <SUBSCRIPTION_ID>`
* Terraform Cloud has a free plan that allows managing remote state. [Create a TF Cloud account and a workspace](https://learn.hashicorp.com/collections/terraform/cloud-get-started).
* Login to Terraform Cloud using `terraform login` and follow the instructions.
* [Create and configure an Azure service principal in TF Cloud workspace](https://learn.hashicorp.com/tutorials/terraform/azure-remote?in=terraform/azure-get-started#configure-a-service-principal). This will allow TF workspace to connect to and create resources in the Azure subscription.

  [Add the necessary permissions to the SP to get the AKS admin group name from the `azuread` provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration). We only need `Group.Read.All` permission.

## Examples

Each subdirectory represents one scenario and usually corresponds to one TF Cloud workspace.

### azure-sandbox-aks

Create an AKS cluster with following features:

* Single nodepool with autoscaling enabled
* AKS managed Azure AD integration
* System-assigned managed Identity
* Cluster auto-upgrade enabled

#### Steps

Run the following steps after changing into `azure-sandbox-aks` directory.

* Run `terraform init` for the first time. `Terraform get` can be run subsequently to install and update modules.
* Validate the code using: `terraform validate`.
* Validate the plan using `terraform plan`.
* Apply the changes using: `terraform apply`.
* Destroy the infrastructure using: `terraform destroy`.

##### AKS Managed Azure AD integration verification

1. Run the user creation script: `./create-dev-user.sh`. Note that the *User Principal Name (UPN)* should be of format *USERNAME@AD-DOMAIN*.
2. Connect to cluster using admin user: `az aks get-credentials --resource-group azure-sandbox-aks-rg --name azure-sandbox-aks-cluster`.
3. Run the k8s role setup script: `./k8s-user-setup.sh`.
4. Run `az login` and login using the user created in 1.
5. Connect to cluster and verify that it has access to only `dev` workspace.

##### Notes

It's very much possible to run into VM `NotAvailableForSubscription` error especially for the free account. In such case, find the region where suitable size VM is available.

Get list of Azure regions: `az account list-locations -o table`
Find a suitable VM size: `az vm list-skus --location <LOCATION> --size Standard_B2 --all --output table`

Once we have it, pass the variables to `terraform apply` command: `terraform apply -var 'azure_region=<LOCATION>' -var 'vm_size=<VM_SIZE>'`

**TODO**
With k8s v1.22+ clusters, there will be a deprecation warning about azure auth plugin as shown below:

```sh
✦ ❯ k run nginx --image=nginx -n dev
W0512 14:50:41.205014   98531 azure.go:92] WARNING: the azure auth plugin is deprecated in v1.22+, unavailable in v1.25+; use https://github.com/Azure/kubelogin instead.
To learn more, consult https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins
pod/nginx created
```

Investigate how to configure and use *Azure kubelogin*.
