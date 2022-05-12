provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Azure Active Directory Provider
provider "azuread" {
  tenant_id = "4fa4074b-69e2-47ee-8e60-eb390d5056ce"
}
