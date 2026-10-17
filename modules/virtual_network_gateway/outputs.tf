output "id" {
  description = "The ID of the Virtual Network Gateway."
  value       = azurerm_virtual_network_gateway.gateway.id
}

output "name" {
  description = "The name of the Virtual Network Gateway."
  value       = azurerm_virtual_network_gateway.gateway.name
}

output "bgp_settings" {
  description = "The BGP settings of the Virtual Network Gateway."
  value       = try(azurerm_virtual_network_gateway.gateway.bgp_settings[0], null)
}

output "local_network_gateways" {
  description = "Map of created Local Network Gateway IDs."
  value = {
    for k, v in azurerm_local_network_gateway.local_gw : k => v.id
  }
}

output "connections" {
  description = "Map of created Virtual Network Gateway Connection IDs."
  value = {
    for k, v in azurerm_virtual_network_gateway_connection.conn : k => v.id
  }
}
