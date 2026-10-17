output "id" {
  description = "The ID of the Private DNS Zone."
  value       = azurerm_private_dns_zone.zone.id
}

output "name" {
  description = "The Name of the Private DNS Zone."
  value       = azurerm_private_dns_zone.zone.name
}

output "resource_group_name" {
  description = "The Resource Group Name where the Private DNS Zone is deployed."
  value       = azurerm_private_dns_zone.zone.resource_group_name
}

output "virtual_network_link_ids" {
  description = "Map of virtual network link keys to their resource IDs."
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.vnet_links : k => v.id }
}
