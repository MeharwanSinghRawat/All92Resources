resource "azurerm_private_dns_zone" "zone" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each = var.virtual_network_links

  name                  = coalesce(each.value.name, "${var.name}-${each.key}-link")
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.zone.name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = each.value.registration_enabled
  tags                  = merge(var.tags, try(each.value.tags, {}))
}
