# Data source to dynamically discover an existing remote Virtual Network across projects,
# subscriptions, or resource groups when use_remote_vnet_data_source is true.
data "azurerm_virtual_network" "remote" {
  count               = var.use_remote_vnet_data_source ? 1 : 0
  name                = var.remote_virtual_network_name
  resource_group_name = coalesce(var.remote_resource_group_name, var.resource_group_name)
}
