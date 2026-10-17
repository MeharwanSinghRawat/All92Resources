resource "azurerm_firewall_policy" "policy" {
  count                    = var.create_firewall_policy && var.firewall_policy_id == null ? 1 : 0
  name                     = "${var.name}-policy"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku_tier
  threat_intelligence_mode = var.threat_intel_mode

  dynamic "dns" {
    for_each = var.dns_proxy_enabled || length(var.dns_servers) > 0 ? [1] : []
    content {
      proxy_enabled = var.dns_proxy_enabled
      servers       = length(var.dns_servers) > 0 ? var.dns_servers : null
    }
  }

  tags = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "rcg" {
  count              = (var.create_firewall_policy && var.firewall_policy_id == null) && (length(var.network_rule_collections) > 0 || length(var.application_rule_collections) > 0 || length(var.nat_rule_collections) > 0) ? 1 : 0
  name               = "DefaultRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.policy[0].id
  priority           = 500

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collections
    content {
      name     = network_rule_collection.key
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.key
          protocols             = rule.value.protocols
          destination_ports     = rule.value.destination_ports
          source_addresses      = length(rule.value.source_addresses) > 0 ? rule.value.source_addresses : null
          destination_addresses = length(rule.value.destination_addresses) > 0 ? rule.value.destination_addresses : null
          destination_fqdns     = length(rule.value.destination_fqdns) > 0 ? rule.value.destination_fqdns : null
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = var.application_rule_collections
    content {
      name     = application_rule_collection.key
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name              = rule.key
          source_addresses  = length(rule.value.source_addresses) > 0 ? rule.value.source_addresses : null
          destination_fqdns = length(rule.value.destination_fqdns) > 0 ? rule.value.destination_fqdns : null

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              port = protocols.value.port
              type = protocols.value.type
            }
          }
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = var.nat_rule_collections
    content {
      name     = nat_rule_collection.key
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.key
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          destination_address = coalesce(rule.value.destination_address, var.public_ip_address)
          destination_ports   = rule.value.destination_ports
          translated_address  = rule.value.translated_address
          translated_port     = rule.value.translated_port
        }
      }
    }
  }
}

resource "azurerm_firewall" "fw" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  zones               = length(var.zones) > 0 ? var.zones : null
  firewall_policy_id  = var.create_firewall_policy && var.firewall_policy_id == null ? azurerm_firewall_policy.policy[0].id : var.firewall_policy_id

  ip_configuration {
    name                 = "firewallIpConfig"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_id
  }

  dynamic "management_ip_configuration" {
    for_each = var.sku_tier == "Basic" && var.management_subnet_id != null ? [1] : []
    content {
      name                 = "mgmtIpConfig"
      subnet_id            = var.management_subnet_id
      public_ip_address_id = var.management_public_ip_id
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_firewall_policy_rule_collection_group.rcg
  ]
}
