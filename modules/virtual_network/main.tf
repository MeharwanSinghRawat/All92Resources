resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                                          = coalesce(each.value.name, each.key)
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = each.value.address_prefixes
  service_endpoints                             = length(each.value.service_endpoints) > 0 ? each.value.service_endpoints : null
  service_endpoint_policy_ids                   = length(each.value.service_endpoint_policy_ids) > 0 ? each.value.service_endpoint_policy_ids : null
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = each.value.delegations
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = try(delegation.value.service_delegation.actions, [])
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = {
    for k, v in var.subnets : k => v.network_security_group_id
    if try(v.network_security_group_id, null) != null
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = each.value
}

resource "azurerm_subnet_route_table_association" "rt_assoc" {
  for_each = {
    for k, v in var.subnets : k => v.route_table_id
    if try(v.route_table_id, null) != null
  }

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = each.value
}
