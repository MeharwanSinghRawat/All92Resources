output "id" {
  description = "The Route Table ID."
  value       = azurerm_route_table.route_table.id
}

output "name" {
  description = "The Route Table name."
  value       = azurerm_route_table.route_table.name
}

output "subnets" {
  description = "The list of Subnet IDs associated with this route table."
  value       = azurerm_route_table.route_table.subnets
}

output "routes" {
  description = "Map of created routes."
  value = {
    for k, v in azurerm_route.routes : k => {
      id                     = v.id
      name                   = v.name
      address_prefix         = v.address_prefix
      next_hop_type          = v.next_hop_type
      next_hop_in_ip_address = v.next_hop_in_ip_address
    }
  }
}
