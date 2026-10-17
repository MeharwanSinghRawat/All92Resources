output "id" {
  description = "The ID of the Virtual WAN."
  value       = azurerm_virtual_wan.vwan.id
}

output "name" {
  description = "The name of the Virtual WAN."
  value       = azurerm_virtual_wan.vwan.name
}

output "virtual_hubs" {
  description = "Map of created Virtual Hub IDs."
  value = {
    for k, v in azurerm_virtual_hub.hubs : k => v.id
  }
}

output "hub_connections" {
  description = "Map of created Virtual Hub connection IDs."
  value = {
    for k, v in azurerm_virtual_hub_connection.connections : k => v.id
  }
}
