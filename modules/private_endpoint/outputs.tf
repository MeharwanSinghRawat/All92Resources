output "id" {
  description = "The ID of the Private Endpoint."
  value       = azurerm_private_endpoint.pe.id
}

output "name" {
  description = "The Name of the Private Endpoint."
  value       = azurerm_private_endpoint.pe.name
}

output "resource_group_name" {
  description = "The Resource Group Name of the Private Endpoint."
  value       = azurerm_private_endpoint.pe.resource_group_name
}

output "location" {
  description = "The Location of the Private Endpoint."
  value       = azurerm_private_endpoint.pe.location
}

output "network_interface_ids" {
  description = "The IDs of the Network Interfaces associated with the Private Endpoint."
  value       = azurerm_private_endpoint.pe.network_interface[*].id
}

output "custom_dns_configs" {
  description = "Custom DNS configurations associated with this Private Endpoint."
  value       = azurerm_private_endpoint.pe.custom_dns_configs
}

output "private_dns_zone_configs" {
  description = "Private DNS Zone configurations associated with this Private Endpoint."
  value       = azurerm_private_endpoint.pe.private_dns_zone_configs
}
