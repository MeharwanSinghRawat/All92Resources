resource "azurerm_container_registry" "acr" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundancy_enabled       = var.sku == "Premium" ? var.zone_redundancy_enabled : false
  export_policy_enabled         = var.sku == "Premium" ? var.export_policy_enabled : true

  dynamic "georeplications" {
    for_each = var.sku == "Premium" ? var.georeplications : []
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = try(georeplications.value.zone_redundancy_enabled, false)
      tags                    = try(georeplications.value.tags, {})
    }
  }

  dynamic "network_rule_set" {
    for_each = var.sku == "Premium" && var.network_rule_set != null ? [var.network_rule_set] : []
    content {
      default_action = try(network_rule_set.value.default_action, "Allow")
      ip_rule = [
        for ip in try(network_rule_set.value.ip_rules, []) : {
          action   = "Allow"
          ip_range = ip
        }
      ]
    }
  }

  tags = var.tags
}
