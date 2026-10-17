locals {
  resolved_remote_vnet_id = var.use_remote_vnet_data_source ? data.azurerm_virtual_network.remote[0].id : var.remote_virtual_network_id
}

resource "azurerm_virtual_network_peering" "peering" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.virtual_network_name
  remote_virtual_network_id    = local.resolved_remote_vnet_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways
}
