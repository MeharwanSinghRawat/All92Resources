output "id" {
  description = "The ID of the Virtual Network Peering."
  value       = azurerm_virtual_network_peering.peering.id
}

output "name" {
  description = "The name of the Virtual Network Peering."
  value       = azurerm_virtual_network_peering.peering.name
}

output "virtual_network_name" {
  description = "The name of the local Virtual Network containing this peering."
  value       = var.virtual_network_name
}

output "remote_virtual_network_id" {
  description = "The resolved ID of the remote Virtual Network."
  value       = local.resolved_remote_vnet_id
}
