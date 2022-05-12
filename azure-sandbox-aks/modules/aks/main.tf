resource "azurerm_kubernetes_cluster" "k8s" {
  name                              = var.cluster_name
  location                          = var.location
  resource_group_name               = var.rg_name
  dns_prefix                        = var.dns_prefix
  automatic_channel_upgrade         = "stable"
  kubernetes_version                = var.k8s_version
  local_account_disabled            = true
  role_based_access_control_enabled = true
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.admin_group_object_ids
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
    max_pods            = 30
    os_sku              = "Ubuntu"
    vnet_subnet_id      = var.subnet_id
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
}
