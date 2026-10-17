resource "azurerm_virtual_wan" "vwan" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  type                              = var.type
  disable_vpn_encryption            = var.disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.office365_local_breakout_category
  tags                              = var.tags
}

resource "azurerm_virtual_hub" "hubs" {
  for_each = var.virtual_hubs

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = each.value.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = each.value.address_prefix
  sku                 = each.value.sku
  tags                = merge(var.tags, try(each.value.tags, {}))

  dynamic "route" {
    for_each = each.value.routes
    content {
      address_prefixes    = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }
}

resource "azurerm_virtual_hub_connection" "connections" {
  for_each = var.hub_connections

  name                      = each.key
  virtual_hub_id            = azurerm_virtual_hub.hubs[each.value.virtual_hub_name].id
  remote_virtual_network_id = each.value.remote_virtual_network_id
  internet_security_enabled = each.value.internet_security_enabled

  dynamic "routing" {
    for_each = each.value.routing != null ? [each.value.routing] : []
    content {
      associated_route_table_id = routing.value.associated_route_table_id

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null ? [routing.value.propagated_route_table] : []
        content {
          labels          = propagated_route_table.value.labels
          route_table_ids = propagated_route_table.value.route_table_ids
        }
      }
    }
  }
}
