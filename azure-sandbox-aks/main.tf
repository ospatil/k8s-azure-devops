terraform {
  cloud {
    organization = "omkarpatil"

    workspaces {
      name = "azure-sandbox-aks"
    }
  }
}

locals {
  name_prefix = "azure-sandbox-aks"
}

data "azuread_group" "aksAdminsGroup" {
  display_name = "aks-admins"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-rg"
  location = var.azure_region
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.name_prefix}-vnet"
  address_space       = ["10.0.0.0/24"]
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${local.name_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/25"]
}

module "k8s" {
  source = "./modules/aks"

  cluster_name           = "${local.name_prefix}-cluster"
  location               = var.azure_region
  vm_size                = var.vm_size
  rg_name                = azurerm_resource_group.rg.name
  dns_prefix             = "ak8s"
  subnet_id              = azurerm_subnet.subnet.id
  admin_group_object_ids = [data.azuread_group.aksAdminsGroup.object_id]
}
