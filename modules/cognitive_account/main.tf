resource "azurerm_cognitive_account" "account" {
  name                               = var.name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  kind                               = var.kind
  sku_name                           = var.sku_name
  custom_subdomain_name              = coalesce(var.custom_subdomain_name, var.name)
  public_network_access_enabled      = var.public_network_access_enabled
  outbound_network_access_restricted = var.outbound_network_access_restricted
  local_auth_enabled                 = var.local_auth_enabled
  tags                               = var.tags

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      default_action = network_acls.value.default_action
      ip_rules       = network_acls.value.ip_rules

      dynamic "virtual_network_rules" {
        for_each = network_acls.value.virtual_network_rules
        content {
          subnet_id                            = virtual_network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = virtual_network_rules.value.ignore_missing_vnet_service_endpoint
        }
      }
    }
  }
}

resource "azurerm_cognitive_deployment" "deployments" {
  for_each = var.deployments

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.account.id

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = coalesce(each.value.sku_name, each.value.scale_type, "Standard")
    capacity = each.value.capacity
  }
}
