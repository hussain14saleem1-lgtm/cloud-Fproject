# Common tags applied to every resource (project requirement)
locals {
  common_tags = {
    Project     = "Final"
    StudentName = "Hussain Saleem & Ramadan Swedik"
  }
}

# Resource Group (name includes student name)
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-final-aks-rg"
  location = var.location
  tags     = local.common_tags
}

# Azure Container Registry (Basic SKU)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = local.common_tags
}

# Azure Kubernetes Service cluster (2 nodes, Standard_B2s_v2)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-final-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}finalaks"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# AKS + ACR integration: let AKS pull images from ACR with NO secrets
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}